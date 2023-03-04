//
//  WeatherViewModelTests.swift
//  weatherTests
//
//  Created by Jason Zheng on 3/3/23.
//

import XCTest

final class WeatherViewModelTests: XCTestCase {
    var mockWeatherService: MockWeatherService!
    var viewModel: WeatherViewModel!
    var delegate: MockWeatherViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        viewModel = WeatherViewModel(weatherService: mockWeatherService)
        delegate = MockWeatherViewModelDelegate()
        viewModel.delegate = delegate
    }
    
    override func tearDown() {
        mockWeatherService = nil
        viewModel = nil
        delegate = nil
        super.tearDown()
    }
    
    func testLoadWeatherData_Success() {
        let expectedWeatherData = WeatherData(main: Main(temp: 20, humidity: 80, feels_like: 30, temp_min: -20, temp_max: 100), wind: Wind(speed: 5), weather: [Weather(description: "Cloudy", icon: "04d")], name: "San Francisco")
        mockWeatherService.mockWeatherData = expectedWeatherData
        
        viewModel.city = "San Francisco"
        viewModel.loadWeatherData()
        
        XCTAssertEqual(mockWeatherService.mockCity, "San%20Francisco")
        XCTAssertEqual(viewModel.weatherData?.main.temp, 20)
        XCTAssertEqual(viewModel.weatherData?.main.humidity, 80)
        XCTAssertEqual(viewModel.weatherData?.main.feels_like, 30)
        XCTAssertEqual(viewModel.weatherData?.main.temp_min, -20)
        XCTAssertEqual(viewModel.weatherData?.main.temp_max, 100)
        
        XCTAssertTrue(delegate.didUpdateDataCalled)
    }
    
    func testLoadWeatherData_Failure() {
        let expectedError = NSError(domain: "Test", code: 123, userInfo: nil)
        mockWeatherService.mockError = expectedError
        
        viewModel.city = "Unknown City"
        viewModel.loadWeatherData()
        
        XCTAssertEqual(mockWeatherService.mockCity, "Unknown%20City")
        XCTAssertNil(viewModel.weatherData)
        XCTAssertTrue(delegate.didFailWithErrorCalled)
    }
    
    func testLoadLastSearchCity() {
        let expectedLastSearchCity = "San Francisco"
        UserDefaults.standard.set(expectedLastSearchCity, forKey: lastSearchCityKey)
        
        viewModel.loadLastSearchCity()
        
        XCTAssertEqual(viewModel.city, expectedLastSearchCity)
    }
    
}

class MockWeatherService: WeatherServiceProtocol {
    
    var mockWeatherData: WeatherData?
    var mockError: Error?
    var mockCity: String?
    
    func getWeatherData(forCity city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        mockCity = city
        if let mockWeatherData = mockWeatherData {
            completion(.success(mockWeatherData))
        } else if let mockError = mockError {
            completion(.failure(mockError))
        }
    }
    
}

class MockWeatherViewModelDelegate: WeatherViewModelDelegate {
    
    var didUpdateDataCalled = false
    var didFailWithErrorCalled = false
    var error: Error?
    
    func weatherViewModelDidUpdateData(_ weatherViewModel: WeatherViewModel) {
        didUpdateDataCalled = true
    }
    
    func weatherViewModelDidFailWithError(_ weatherViewModel: WeatherViewModel, error: Error) {
        didFailWithErrorCalled = true
        self.error = error
    }
    
}
