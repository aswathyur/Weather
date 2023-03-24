//
//  WeatherCell.swift
//  Weather
//
//  Created by Aswathy Nair on 3/19/23.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var temperatureMinMaxLabel: UILabel!
    @IBOutlet private weak var mainConditionLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    
    var detailedWeather: DetailedWeather!{
        didSet {
            showWeather()
        }
    }

    /// Display the weather details
    private func showWeather() {
        self.cityLabel.text = detailedWeather.name
        self.countryLabel.text = detailedWeather.sys?.country
        if let temp = detailedWeather.main?.temp {
            self.temperatureLabel.text = "\(Int(temp))" + "°C"
        }
        
        var temperatureRange = ""
        if let maxtemp = detailedWeather.main?.temp_max {
            temperatureRange = "H:\(Int(maxtemp))" + "°C"
        }
        if let mintemp = self.detailedWeather?.main?.temp_min {
            if !temperatureRange.isEmpty {
                temperatureRange += "  "
            }
            temperatureRange += "L:\(Int(mintemp))" + "°C"
        }
        self.temperatureMinMaxLabel.text = temperatureRange
        
        self.mainConditionLabel.text = self.detailedWeather.weather?.first?.description?.capitalized
    }
    
}
