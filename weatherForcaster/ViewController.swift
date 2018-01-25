//
//  ViewController.swift
//  weatherForcaster
//
//  Created by Rich Ruais on 1/24/18.
//  Copyright © 2018 Rich Ruais. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    
    var dailyWeather = [Weather]()
    var weatherSearch = WeatherForcast()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
    }

    func setupTableView() {
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
    }
    
    func setupUI() {
        searchButton.layer.cornerRadius = 10
        clearButton.layer.cornerRadius = 10
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func search(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if dailyWeather.count > 0 {
            dailyWeather.removeAll()
            weatherTableView.reloadData()
        }
        
        if (zipTextField.text?.isEmpty)! || zipTextField.text?.characters.count != 5 {
            
            zipTextField.text = ""
            cityLabel.text = "City: "

            let alertController = UIAlertController(title: "Oops!", message: "Please Enter a 5 digit zip code.", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            }
            
            alertController.addAction(ok)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            let zipCode = zipTextField.text
            weatherSearch.searchByZipCode(zipcode: zipCode!, completion: { (dailyWeather, city) -> Void in
                
                if dailyWeather != nil && city != "" {
                    self.dailyWeather = dailyWeather!
                    self.cityLabel.text = "City: \(city)"
                    self.weatherTableView.reloadData()
                } else {
                    
                    self.zipTextField.text = ""
                    self.cityLabel.text = "City: "
                    
                    let alertController = UIAlertController(title: "Oops!", message: "City not found. Please try again.", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    }
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    
    @IBAction func clearSearch(_ sender: UIButton) {
        dailyWeather.removeAll()
        self.zipTextField.text = ""
        self.cityLabel.text = "City: "
        weatherTableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as! WeatherTableViewCell
        
        let max = Double(dailyWeather[indexPath.row].max)!
        let min = Double(dailyWeather[indexPath.row].min)!
        
        cell.highLabel.text = "\(Int(max.rounded())) F"
        cell.lowLabel.text = "\(Int(min.rounded())) F"
        
        let desc = dailyWeather[indexPath.row].description
        cell.descriptionLabel.text = desc
        
        if desc == "sky is clear" {
            cell.weatherImage.image = UIImage(named: "Sunny")
        }
        if desc == "scattered clouds" {
            cell.weatherImage.image = UIImage(named: "PartlyCloudy")
        }
        if desc == "overcast clouds" {
            cell.weatherImage.image = UIImage(named: "PartlyCloudy")
        }
        if desc == "heavy intensity rain" {
            cell.weatherImage.image = UIImage(named: "Rain")
        }
        if desc == "very intensity rain" {
            cell.weatherImage.image = UIImage(named: "Rain")
        }
        if desc == "moderate rain" {
            cell.weatherImage.image = UIImage(named: "Rain")
        }
        if desc == "light rain" {
            cell.weatherImage.image = UIImage(named: "Rain")
        }
        if desc == "snow" {
            cell.weatherImage.image = UIImage(named: "Snow")
        }
        if desc == "heavy snow" {
            cell.weatherImage.image = UIImage(named: "Snow")
        }
        if desc == "light snow" {
            cell.weatherImage.image = UIImage(named: "Snow")
        }
        
        return cell
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

