//
//  RequestErrorTests.swift
//  WeatherTests
//
//  Created by Aswathy Nair on 3/22/23.
//

import XCTest
@testable import Weather

final class RequestErrorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRequestErrorDescription() throws {
        XCTAssertTrue(RequestError.invalidURL.description == "Invalid url", "Request Error description not matching for invalid url")
        XCTAssertTrue(RequestError.decodeError.description == "Failed to decode", "Request Error description not matching for decodeError")
        XCTAssertTrue(RequestError.unauthorized.description == "Session expired", "Request Error description not matching for unauthorized")
    }

}
