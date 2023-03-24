//
//  Weather.swift
//  Weather
//
//  Created by Aswathy Nair on 3/19/23.
//

import Foundation

struct Weather: Decodable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
    let humidity: Double?
    let pressure: Double?
}

struct Wind: Decodable {
    let speed: Double?
    let deg: Double?
    let gust: Double?
}

struct Sys: Decodable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Double?
    let sunset: Double?
}
struct DetailedWeather: Decodable {
    let id: Int?
    let weather: [Weather]?
    let main: Main?
    let timezone: Int?
    let name: String?
    let base: String?
    let wind: Wind?
    let sys: Sys?
}
