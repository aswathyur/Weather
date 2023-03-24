//
//  WeatherDetailViewController.swift
//  Weather
//
//  Created by Aswathy Nair on 3/21/23.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var tempRangeLabel: UILabel!
    @IBOutlet private weak var weatherTitle: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherIcon: ImageDownloader!
    // View model
    var viewModel = WeatherDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the navigation bar buttons
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        
        // Delegate approach for view and view model connection
        self.viewModel.delegate = self
    }

    /// Display the weather condition in UI
    /// Displayed only minimal data. If more time available planning to show the wind, rain details etc on table view cells based on the weather condition
    /// Avoided any image from google and so the view looks plain.
    func showWeather() {
        guard let _ = self.viewModel.weather else { return }
        
        // Clear the last data
        self.clearData()
        
        // show the new values
        self.cityLabel.text = self.viewModel.weather?.name
        
        if let temp = self.viewModel.weather?.main?.temp {
            self.temperatureLabel.text = "\(Int(temp))" + "°C"
        }
        if let title = self.viewModel.weather?.weather?.first?.main {
            self.weatherTitle.text = "\(title)"
        }
        
        // Format the temperature high and low and show it in UI
        var temperatureRange = ""
        if let maxtemp = self.viewModel.weather?.main?.temp_max {
            temperatureRange = "H:\(Int(maxtemp))" + "°C"
        }
        if let mintemp = self.viewModel.weather?.main?.temp_min {
            if !temperatureRange.isEmpty {
                temperatureRange += " "
            }
            temperatureRange += "L:\(Int(mintemp))" + "°C"
        }
        self.tempRangeLabel.text = temperatureRange
        if let iconUrl = self.viewModel.getIconUrl() {
            self.weatherIcon.loadImageWithUrl(iconUrl)
        }
    }
    
    /// Clear the content of cell.
    private func clearData() {
        self.cityLabel.text = ""
        self.temperatureLabel.text = "_ _"
        self.weatherTitle.text = ""
        self.tempRangeLabel.text = ""
    }
    
    /// Selector on tapping add button in navigation bar
    @objc func addTapped() {
        self.viewModel.saveLocation()
        self.dismiss(animated: true)
    }
    
    /// Selector on tapping cancel button in navigation bar
    @objc func cancelTapped() {
        self.dismiss(animated: true)
    }

}

// MARK: - WeatherDetailViewDelegate
extension WeatherDetailViewController: WeatherDetailViewDelegate {
    /// Gets invoked when fetching of weather from api completes
    func fetchedWeather() {
        self.showWeather()
    }
}
