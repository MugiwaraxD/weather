//
//  WeatherService.swift
//  weather
//
//  Created by Jason Zheng on 3/3/23.
//

import Foundation
import CoreLocation

protocol WeatherServiceProtocol {
    func getWeatherData(forCity city: String, completion: @escaping (Result<WeatherData, Error>) -> Void)
    func getWeatherData(forCoordinate coordinate: CLLocationCoordinate2D, completion: @escaping (Result<WeatherData, Error>) -> Void)
}

class WeatherService: WeatherServiceProtocol {
    
    private let userDefaults = UserDefaults.standard
    
    func getWeatherData(forCity city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String  else {
            print("Unable to read key")
            return completion(.failure(WeatherServiceError.invalidURL))
        }
        let BASE_URL = "https://api.openweathermap.org/data/2.5/weather?q="
        let urlString = "\(BASE_URL)\(city)&units=imperial&appid=\(apiKey)"
        fetchWeatherData(withURLString: urlString, completion: completion)
    }
    
    func getWeatherData(forCoordinate coordinate: CLLocationCoordinate2D, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            print("Unable to read key")
            return completion(.failure(WeatherServiceError.invalidURL))
        }
        let BASE_URL = "https://api.openweathermap.org/data/2.5/weather?"
        let lat = String(format: "%.2f", coordinate.latitude)
        let lon = String(format: "%.2f", coordinate.longitude)
        let urlString = "\(BASE_URL)lat=\(lat)&lon=\(lon)&units=imperial&appid=\(apiKey)"
        fetchWeatherData(withURLString: urlString, completion: completion)
    }
    
    private func fetchWeatherData(withURLString urlString: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let task = session.dataTask(with: url, completionHandler: { data, response, error in
                DispatchQueue.main.async { [weak self] in
                    guard let weakSelf = self else { return }
                    if error != nil || data == nil {
                        print("Error retrieving weather data: \(error?.localizedDescription ?? "unknown error")")
                        completion(.failure(error ?? WeatherServiceError.unknownError))
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        let weatherData = try decoder.decode(WeatherData.self, from: data!)
                        weakSelf.saveLastSearchCity(weatherData.name)
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
    case invalidKeyRead
}
