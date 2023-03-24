//
//  SearchViewModel.swift
//  Weather
//
//  Created by Aswathy Nair on 3/20/23.
//

import Foundation
import CoreLocation

/// Enum that defines the sections of the table view in landing screen
enum WeatherViewSections: Int, CaseIterable {
    case selectedLocation
    case searchResults
}

class WeatherViewModel: NSObject {
    
    var searchResults: [SearchResult?] = [] {
        didSet {
            Task {
                await MainActor.run { [weak self] in
                    self?.reloadUI()
                }
            }
        }
    }
    
    // Location selected by user to view the details
    var selectedLocation: SearchResult?
    
    // Saved location which loads in the landing screen
    var lastSavedLocation: SearchResult? = nil {
        didSet {
            self.fetchWeatherForSavedLocation()
        }
    }
    
    // Saved location's weather details
    var savedLocationWeather: DetailedWeather? = nil {
        didSet {
            Task {
                // Performing ui update on main thread
                await MainActor.run { [weak self] in
                    self?.reloadUI()
                }
            }
        }
    }
    
    // Used call backs as the communication channel between view and view model
    var reloadUI: () -> Void = {}
    
    // Variable indicating any network call is in progress in the view.
    // Reloading the table view to show empty table view when loading is in progress
    var isLoading: Bool = false {
        didSet {
            Task {
                await MainActor.run { [weak self] in
                    self?.reloadUI()
                }
            }
        }
    }
    
    // Location manager to get the current location of the user
    var locationManager =  CLLocationManager()
    
    override init() {
        super.init()
        // Set up loaction manager to request the access
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.startUpdatingLocation()
    }
    
    func performSearch(text: String) {
        // Search place
        self.isLoading = true
        Task(priority: .background) {
            let result = await WeatherService().searchWeather(searchText: text)
            switch result {
            case .success(let results):
                await MainActor.run { [weak self] in
                    self?.searchResults = results ?? []
                    self?.isLoading = false
                }
            case .failure(_):
                await MainActor.run { [weak self] in
                    self?.searchResults = []
                    self?.isLoading = false
                }
            }
        }
    }
    
    // Read the last saved location from User defaults
    func fetchSavedLocation() {
        self.isLoading = true
        // Check for any last saved location
        if let savedLocation = UserDefaults.standard.object(forKey: "com.weather.LastSavedLocation") as? [String: Double], let lat = savedLocation["lat"], let lon = savedLocation["lon"] {
            self.lastSavedLocation = SearchResult(name: "", lat: lat, lon: lon, country: "", state: "")
        }
    }
    
    // Get the weather of last saved location.
    private func fetchWeatherForSavedLocation() {
        if let lat = self.lastSavedLocation?.lat, let long = self.lastSavedLocation?.lon {
            self.isLoading = true
            Task(priority: .background) {
                let result = await WeatherService().fetchWeather(latitude: lat, longitude: long)
                switch result {
                case .success(let results):
                    await MainActor.run { [weak self] in
                        self?.savedLocationWeather = results
                        self?.isLoading = false
                    }
                case .failure(_):
                    print("FetchWeather api failed with error")
                    await MainActor.run { [weak self] in
                        self?.isLoading = false
                    }
                }
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.lastSavedLocation == nil, let currentLoc = manager.location {
            self.lastSavedLocation = SearchResult(name: "", lat: currentLoc.coordinate.latitude, lon: currentLoc.coordinate.longitude, country: "", state: "")
        }
    }
}
