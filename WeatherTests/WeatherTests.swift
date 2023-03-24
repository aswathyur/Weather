//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Aswathy Nair on 3/17/23.
//

import XCTest
@testable import Weather

@testable import Weather

final class WeatherTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchWeather() throws {
        let searchExpectation = XCTestExpectation()
        Task(priority: .background) {
            let result = await  WeatherService().searchWeather(searchText: "Sunnyvale")
            switch result {
            case .success(let searchResults):
                if searchResults?.isEmpty == true {
                    XCTFail("Search api response is empty")
                }
            case .failure(let error):
                XCTFail("Search api failed with \(error)")
            }
            searchExpectation.fulfill()
        }
        self.wait(for: [searchExpectation], timeout: 60.0)
    }
    
    func testfetchWeatherByLatitudeAndLongitude() throws {
        let fetchExpectation = XCTestExpectation()
        Task(priority: .background) {
            let result = await  WeatherService().fetchWeather(latitude: 37.774929, longitude: -122.419418)
            switch result {
            case .success(let result):
                XCTAssert(result != nil, "Failed to fetch the weather by latitude and longitude")
            case .failure(let error):
                XCTFail("Failed to fetch the weather by latitude and longitude api failed with \(error)")
            }
            fetchExpectation.fulfill()
        }
        self.wait(for: [fetchExpectation], timeout: 60.0)
    }
    
    func testWeatherRequest() throws {
        var weatherRequest = WeatherRequest.search(searchText: "Sunnyvale")
        XCTAssertTrue(weatherRequest.path == "geo/1.0/direct", "Path of Weather request search is not matching")
        XCTAssertTrue(weatherRequest.method == .get, "Method of Weather request search is not matching")
        XCTAssertTrue(weatherRequest.header == ["Content-Type": "application/json"], "Header of Weather request search is not matching")
        
        weatherRequest = WeatherRequest.weather(city: "Sunnyvale")
        XCTAssertTrue(weatherRequest.path == "data/2.5/weather", "Path of Weather request by city,state, country is not matching")
        XCTAssertTrue(weatherRequest.method == .get, "Method of Weather request by city,state, country is not matching")
        XCTAssertTrue(weatherRequest.header == ["Content-Type": "application/json"], "Header of Weather request by city,state, country is not matching")
        
        weatherRequest = WeatherRequest.weatherByCoordinates(latitude: 0, longitude: 0)
        XCTAssertTrue(weatherRequest.path == "data/2.5/weather", "Path of Weather request by latotude and longitude is not matching")
        XCTAssertTrue(weatherRequest.method == .get, "Method of Weather request by latotude and longitude is not matching")
        XCTAssertTrue(weatherRequest.header == ["Content-Type": "application/json"], "Header of Weather request by latotude and longitude is not matching")
        
    }

}
