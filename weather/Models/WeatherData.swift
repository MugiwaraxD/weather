//
//  WeatherData.swift
//  weather
//
//  Created by Jason Zheng on 3/3/23.
//

import Foundation

struct WeatherData: Decodable {
    let main: Main
    let wind: Wind
    let weather: [Weather]
    let name: String
}

struct Main: Decodable {
    let temp: Double
    let humidity: Int
    let feels_like:Double
    let temp_min:Double
    let temp_max:Double
}

struct Wind: Decodable {
    let speed: Double
}

struct Weather: Decodable {
    let description: String
    let icon: String
}
