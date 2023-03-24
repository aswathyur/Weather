//
//  NetworkInfoTests.swift
//  WeatherTests
//
//  Created by Aswathy Nair on 3/22/23.
//

import XCTest
@testable import Weather

final class NetworkInfoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHost() throws {
        XCTAssertTrue(NetworkInfo.host() == "https://api.openweathermap.org/", "Failed to get the host key from NetworkInfo.plist")
    }
    
    func testAPIKey() throws {
        XCTAssertTrue(!NetworkInfo.apiKey().isEmpty, "Failed to get the api key from NetworkInfo.plist")
    }

}
