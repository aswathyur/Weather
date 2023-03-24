//
//  NetworkService.swift
//  Weather
//
//  Created by Aswathy Nair on 3/17/23.
//

import Foundation

/// HTTP Request methods
enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

/// Protocol which all service classes to conform
protocol Request {
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: Any]? { get }
}

protocol NetworkService {
    func sendRequest<T: Decodable>(endpoint: Request, responseModel: T.Type) async -> Result<T?, RequestError>
}

extension NetworkService {
    
    /// Send http request and receive the response.
    func sendRequest<T: Decodable>(endpoint: Request, responseModel: T.Type) async -> Result<T?, RequestError> {
        
        guard let url = URL(string: (NetworkInfo.host() + endpoint.path)) else {
            return .failure(.invalidURL)
        }
        var urlToCall = url
        
        // Query params for GET APIs
        if endpoint.method == .get {
            var queryItems: [URLQueryItem] = []
            if let queryParams = endpoint.body {
                for key in queryParams.keys {
                    if let value = queryParams[key] as? String {
                        queryItems.append(URLQueryItem(name: key, value: value))
                    }
                }
                urlToCall.append(queryItems: queryItems)
            }
        }
        
        // Create url request and set up header
        var request = URLRequest(url: urlToCall)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        // Set up the request body
        if let body = endpoint.body, endpoint.method != .get {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:
                // Json decoder to decode the response.
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decodeError)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unKnown)
        }
    }
}
