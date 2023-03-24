//
//  NetworkInfo.swift
//  Weather
//
//  Created by Aswathy Nair on 3/18/23.
//

import Foundation

/// enum for items in the NetworkInfo.plist
enum NetworkInfoParam: String {
    case host
    case apiKey
    case iconBaseUrl
}

/// Singleton class
class NetworkInfo {
    
    private init() {}
    
    /// Get host from NetworkInfo.plist
    class func host() -> String {
        return self.getValue(.host)
    }
    
    /// Get apiKey from NetworkInfo.plist
    class func apiKey() -> String {
        return self.getValue(.apiKey)
    }
    
    /// Get icon url
    class func iconUrl() -> String {
        return self.getValue(.iconBaseUrl)
    }
    
    /// Reads NetworkInfo.plist and return the value of the requested item
    /// param: 
    private class func getValue(_ param: NetworkInfoParam) -> String {
        
        let fileHandle: FileHandle = FileHandle(forReadingAtPath: Bundle(for: NetworkInfo.self).path(forResource: "NetworkInfo", ofType: "plist")!)!
        
        // Read data from the file
        let data = fileHandle.readDataToEndOfFile()
        
        // data to plist conversion
        if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: AnyObject] {
            if let value = result[param.rawValue] as? String {
                return value
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    
}
