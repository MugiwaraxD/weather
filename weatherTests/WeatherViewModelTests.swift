//
//  WeatherViewModelTests.swift
//  weatherTests
//
//  Created by Jason Zheng on 3/3/23.
//

import XCTest
import CoreLocation

final class WeatherViewModelTests: XCTestCase {
    var weatherViewModel: WeatherViewModel!
    var mockWeatherService: MockWeatherService!
    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        weatherViewModel = WeatherViewModel(weatherService: mockWeatherService)
    }
    
    override func tearDown() {
        weatherViewModel = nil
        super.tearDown()
    }
    
    // Loads weather data for city
    func testLoadWeatherDataForCity() {
        let mockWeatherData = WeatherData(main: Main(temp: 20, humidity: 80, feels_like: 30, temp_min: -20, temp_max: 100), wind: Wind(speed: 5), weather: [Weather(description: "Cloudy", icon: "04d")], name: "San Francisco")
        mockWeatherService.mockWeatherData = mockWeatherData
        weatherViewModel.delegate = self
        weatherViewModel.city = "San Francisco"
    }
}

extension WeatherViewModelTests: WeatherViewModelDelegate {
    func weatherViewModelDidUpdateData(_ weatherViewModel: WeatherViewModel) {
        XCTAssertNotNil(weatherViewModel.weatherData)
        XCTAssertEqual(weatherViewModel.weatherData?.name, "San Francisco")
        XCTAssertEqual(weatherViewModel.weatherData?.main.temp, 20)
    }
    
    func weatherViewModelDidFailWithError(_ weatherViewModel: WeatherViewModel, error: Error) {
        XCTFail("Failed to load weather data: \(error.localizedDescription)")
    }
}

class MockWeatherService: WeatherServiceProtocol {
    var mockWeatherData: WeatherData?
    var mockError: Error?
    
    func getWeatherData(forCity city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        if let weatherData = mockWeatherData {
            completion(.success(weatherData))
        } else if let error = mockError {
            completion(.failure(error))
        }
    }
    
    func getWeatherData(forCoordinate coordinate: CLLocationCoordinate2D, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        if let weatherData = mockWeatherData {
            completion(.success(weatherData))
        } else if let error = mockError {
            completion(.failure(error))
        }
    }
}
