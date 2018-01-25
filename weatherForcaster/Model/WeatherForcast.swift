//
//  Weather.swift
//  weatherForcaster
//
//  Created by Rich Ruais on 1/24/18.
//  Copyright © 2018 Rich Ruais. All rights reserved.
//

import Foundation
import Alamofire

struct Weather {
    var description: String
    var min: String
    var max: String
    var humidity: String
}

class WeatherForcast {
    
    func searchByZipCode(zipcode: String, completion: @escaping (_ dailyWeather: [Weather]?, _ city: String) -> Void) {

        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?zip=\(zipcode)&units=imperial&appid=7ab7f589feda857e3b74f0e5e7c67fc3")!
        
        var selectedCity: String?
        
        Alamofire.request(url).responseJSON { response in            
            var dailyWeather = [Weather]()
            
            if let json = response.result.value as? [String:Any] {
                
                if let message = json["message"] as? String {
                    if String(describing: message) == "city not found" {
                        completion(nil, "Not Found")
                    }
                }
                
                guard let cityInfo = json["city"] as? [String:Any] else {
                    return
                }
                
                if let city = cityInfo["name"] {
                    selectedCity = String(describing: city)
                }
                
                if let weatherData = json["list"] as? [[String:Any]] {
                    
                    for day in weatherData {
                        
                        guard let temp = day["temp"] as? [String:Any] else {
                            return
                        }
                        
                        let min = String(describing: temp["min"]!)
                        let max = String(describing: temp["max"]!)
                        
                        
                        guard let weather = day["weather"] as? [[String:Any]] else {
                            return
                        }
                        
                        let description = String(describing: weather[0]["description"]!)
                        
                        guard let humidity = day["humidity"] as? Int else {
                            return
                        }
                        
                        let hum = String(describing: humidity)
                        
                        let newWeather = Weather(description: description, min: min, max: max, humidity: hum)
                        
                        
                        dailyWeather.append(newWeather)
                    }
                }
            }
            completion(dailyWeather, selectedCity!)
        }
    }
}
