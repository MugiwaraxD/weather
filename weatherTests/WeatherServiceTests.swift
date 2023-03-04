//
//  WeatherServiceTests.swift
//  weatherTests
//
//  Created by Jason Zheng on 3/3/23.
//

import XCTest

final class WeatherServiceTests: XCTestCase {
    var weatherService: WeatherService!
        
        override func setUp() {
            super.setUp()
            weatherService = WeatherService()
        }
        
        override func tearDown() {
            weatherService = nil
            super.tearDown()
        }
        
        func testGetWeatherDataWithValidCity() {
            let expectation = self.expectation(description: "Get weather data with valid city")
            
            weatherService.getWeatherData(forCity: "New York") { result in
                switch result {
                case .success(let weatherData):
                    XCTAssertNotNil(weatherData)
                    XCTAssertEqual(weatherData.name, "New York")
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            }
            
            waitForExpectations(timeout: 5.0, handler: nil)
        }
        
        func testGetWeatherDataWithInvalidCity() {
            let expectation = self.expectation(description: "Get weather data with invalid city")
            
            weatherService.getWeatherData(forCity: "Invalid City") { result in
                switch result {
                case .success(let weatherData):
                    XCTFail("Unexpected success: \(weatherData)")
                case .failure(let error):
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                }
            }
            
            waitForExpectations(timeout: 5.0, handler: nil)
        }
}
