//
//  SearchResult.swift
//  Weather
//
//  Created by Aswathy Nair on 3/20/23.
//

import Foundation

struct SearchResult: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String
}
