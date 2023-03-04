//
//  WeatherService.swift
//  weather
//
//  Created by Jason Zheng on 3/3/23.
//

import Foundation

protocol WeatherServiceProtocol {
    func getWeatherData(forCity city: String, completion: @escaping (Result<WeatherData, Error>) -> Void)
}

class WeatherService: WeatherServiceProtocol {
    
    private let userDefaults = UserDefaults.standard
    
    func getWeatherData(forCity city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let API_KEY = "725e296ea6d45836d8ade811352dcbe0"
        let BASE_URL = "https://api.openweathermap.org/data/2.5/weather?q="
        let urlString = "\(BASE_URL)\(city)&units=imperial&appid=\(API_KEY)"
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let task = session.dataTask(with: url, completionHandler: { data, response, error in
                DispatchQueue.main.async {
                    if error != nil || data == nil {
                        print("Error retrieving weather data: \(error?.localizedDescription ?? "unknown error")")
                        completion(.failure(error ?? WeatherServiceError.unknownError))
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        let weatherData = try decoder.decode(WeatherData.self, from: data!)
                        self.saveLastSearchCity(city)
                        completion(.success(weatherData))
                    } catch {
                        print("Error decoding weather data: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
                
            })
            task.resume()
        } else {
            print("Invalid URL")
            completion(.failure(WeatherServiceError.invalidURL))
        }
    }
    
    private func saveLastSearchCity(_ city: String) {
        userDefaults.set(city, forKey: lastSearchCityKey)
    }
}

enum WeatherServiceError: Error {
    case unknownError
    case invalidURL
}
