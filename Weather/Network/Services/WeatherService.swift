//
//  WeatherService.swift
//  Weather
//
//  Created by Aswathy Nair on 3/20/23.
//

import Foundation

enum WeatherRequest {
    // Search by city, state, country request
    case search(searchText: String)
    
    // Fetch weather by city,state, code is deprecated by openWeather api
    case weather(city: String, stateCode: String? = nil, countryCode: String? = nil)
    
    // Fetch weather by latitude and longitude of location
    case weatherByCoordinates(latitude: Double, longitude: Double)
}

extension WeatherRequest: Request {
    
    // API end points
    var path: String {
        switch self {
        case .search:
            return "geo/1.0/direct"
        case .weather, .weatherByCoordinates:
            return "data/2.5/weather"
        }
    }
    
    // Variable defining the request type GET, POST, PUT, DELETE
    var method: RequestMethod {
        switch self {
        case .search, .weather, .weatherByCoordinates:
            return .get
        }
    }
    
    // Request header
    var header: [String : String]? {
        switch self {
        case .search, .weather, .weatherByCoordinates:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    
    // Request body.
    var body: [String : Any]? {
        switch self {
        case let .search(searchText):
            return [
                "q": searchText,
                "limit": "15",
                "appid": NetworkInfo.apiKey()
            ]
        case let .weather(city, stateCode, countryCode):
            var queryParams: [String] = [city]
            if let state = stateCode {
                queryParams.append(state)
            }
            if let country = countryCode {
                queryParams.append(country)
            }
            return [
                "q": queryParams.joined(separator: ","),
                "appid": NetworkInfo.apiKey()
            ]
        case let .weatherByCoordinates(latitude, longitude):
            return [
                "lat": "\(latitude)",
                "lon": "\(longitude)",
                "units": "metric",
                "appid": NetworkInfo.apiKey()
            ]
        }
    }
}

struct WeatherService: NetworkService {
    
    /// Search place by city, state, country
    func searchWeather(searchText: String) async -> Result<[SearchResult]?, RequestError> {
        return await sendRequest(endpoint: WeatherRequest.search(searchText: searchText), responseModel: [SearchResult].self)
    }
    
    /// Fetch the weather by city, state, country
    func fetchWeather(city: String, stateCode: String?, countryCode: String?) async -> Result<DetailedWeather?, RequestError> {
        return await sendRequest(endpoint: WeatherRequest.weather(city: city, stateCode: stateCode, countryCode: countryCode), responseModel: DetailedWeather.self)
    }
    
    /// Fetch weather by latitude and longitude of the location
    func fetchWeather(latitude: Double, longitude: Double) async -> Result<DetailedWeather?, RequestError> {
        return await sendRequest(endpoint: WeatherRequest.weatherByCoordinates(latitude: latitude, longitude: longitude), responseModel: DetailedWeather.self)
    }
}
