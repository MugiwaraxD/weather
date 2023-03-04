//
//  WeatherViewModel.swift
//  weather
//
//  Created by Jason Zheng on 3/3/23.
//

import Foundation

protocol WeatherViewModelDelegate: AnyObject {
    func weatherViewModelDidUpdateData(_ weatherViewModel: WeatherViewModel)
    func weatherViewModelDidFailWithError(_ weatherViewModel: WeatherViewModel, error: Error)
}

class WeatherViewModel {
    
    weak var delegate: WeatherViewModelDelegate?
    
    private let weatherService: WeatherServiceProtocol
    private let userDefaults = UserDefaults.standard
    private let lastSearchCityKey = "lastSearchCity"
    
    var city: String = "" {
        didSet {
            loadWeatherData()
        }
    }
    
    private(set) var weatherData: WeatherData?
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    private func loadWeatherData() {
        weatherService.getWeatherData(forCity: city) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weatherData):
                self.weatherData = weatherData
                self.delegate?.weatherViewModelDidUpdateData(self)
            case .failure(let error):
                self.delegate?.weatherViewModelDidFailWithError(self, error: error)
            }
        }
    }
    
    func getLastSearchCity() -> String? {
        return userDefaults.string(forKey: lastSearchCityKey)
    }
    
    private func saveLastSearchCity(_ city: String) {
        userDefaults.set(city, forKey: lastSearchCityKey)
    }
}
