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
}

struct Main: Decodable {
    let temp: Double
    let humidity: Int
    let feels_like:Int
    let temp_min:Int
    let temp_max:Int
}

struct Wind: Decodable {
    let speed: Double
}

struct Weather: Decodable {
    let description: String
    let icon: String
}
