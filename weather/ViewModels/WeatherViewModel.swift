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

let lastSearchCityKey = "lastSearchCity"

class WeatherViewModel {
    
    weak var delegate: WeatherViewModelDelegate?
    
    private let weatherService: WeatherServiceProtocol
    private let userDefaults = UserDefaults.standard
    
    var city: String = "" {
        didSet {
            loadWeatherData()
        }
    }
    
    private(set) var weatherData: WeatherData?
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func loadWeatherData() {
        let allowedCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-._~"))
        let encodedCity:String
        if isStringEncoded(city) {
            encodedCity = city
        }
        else {
            encodedCity = city.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? city
        }
        
        weatherService.getWeatherData(forCity: encodedCity) { [weak self] result in
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
    
    func loadLastSearchCity() {
        if let lastSearchCity = getLastSearchCity() {
            self.city = decodeString(lastSearchCity) ?? ""
        }
    }
    
    private func isStringEncoded(_ string:String)->Bool {
        if let decodedString = string.removingPercentEncoding {
            if decodedString == string {
                return false
            } else {
                return true
            }
        }
        return false
    }
    
    private func decodeString(_ encodedString: String) -> String? {
        return encodedString.removingPercentEncoding
    }
    
    private func getLastSearchCity() -> String? {
        return userDefaults.string(forKey: lastSearchCityKey)
    }
}
