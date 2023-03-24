//
//  RequestError.swift
//  Weather
//
//  Created by Aswathy Nair on 3/17/23.
//

import Foundation

///Custom error messages for network errors
enum RequestError: Error {
    case invalidURL
    case decodeError
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unKnown
    
    var description: String {
           switch self {
           case .invalidURL:
               return "Invalid url"
           case .decodeError:
               return "Failed to decode"
           case .unauthorized:
               return "Session expired"
           default:
               return "Unknown error"
           }
       }
}
