//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Aswathy Nair on 3/19/23.
//

import Foundation
import UIKit

protocol WeatherDetailViewDelegate {
    func fetchedWeather()
}

class WeatherDetailViewModel {
    
    // Used another way of communication delegate pattern for view and view model bridging.
    // Apart from call backs and delegate we can use the combine framework also to acheieve MVVM design pattern
    var delegate: WeatherDetailViewDelegate?
    
    var weather: DetailedWeather? {
        didSet {
            self.delegate?.fetchedWeather()
        }
    }
    
    // Selected location for which weather details to be shown
    var location: SearchResult? {
        didSet {
            self.fetchWeather()
        }
    }
    
    // Weather icon
    var weatherImage: UIImage?
    
    /// Fetch weather details for the selected location
    private func fetchWeather() {
        if let lat = self.location?.lat, let long = self.location?.lon {
            Task(priority: .background) {
                let result = await WeatherService().fetchWeather(latitude: lat, longitude: long)
                switch result {
                case .success(let results):
                    await MainActor.run { [weak self] in
                        self?.weather = results
                    }
                case .failure(_):
                    print("FetchWeather api failed with error")
                }
            }
        }
    }
    
    /// Save the selected location in User defaults to laod when next time app launches.
    /// As the offline data storage is minimal , preferred User defaults. If there is large data to be stored we can make use of Core data.
    func saveLocation() {
        if let lat = self.location?.lat, let lon = self.location?.lon {
            let defaults = UserDefaults.standard
            let dict: [String: Double] = ["lat": lat, "lon": lon]
            defaults.set(dict, forKey: "com.weather.LastSavedLocation")
        }
    }
    
    /// Get the weather icon url
    func getIconUrl() -> URL? {
        if let imageName = self.weather?.weather?.first?.icon {
            let urlString = "\(NetworkInfo.iconUrl())*@2x.png"
                .replacingOccurrences(of: "*", with: imageName)
            return URL(string: urlString)
        }
        return nil
    }
}
