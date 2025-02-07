//
//  WeatherData.swift
//  Weather Appl
//
//  Created by Morteza Safari on 2025-02-04.
//

import Foundation
import CoreLocation

//Defining structs matching the JSON struture of the API
struct WeatherResponse: Decodable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let current: Current
    let daily: Daily

    struct CurrentUnits: Decodable {
        let time: String
        let interval: String
        let temperature_2m: String
        let weather_code: String
    }
    
    static func weatherDescription(for code: Int) -> String {
        switch code {
        case 0: return "Sunny"
        case 1, 2: return "Partly Cloudy"
        case 3: return "Cloudy"
        case 45, 48: return "Foggy"
        case 51, 53, 55, 56, 57: return "Drizzle"
        case 61, 63, 65, 66, 67: return "Rain"
        case 71, 73, 75, 77: return "Snow"
        case 80, 81, 82: return "Rain Showers"
        case 85, 86: return "Snow Showers"
        case 95, 96, 99: return "Thunderstorm"
        default: return "Unknown"
        }
    }
    
    struct Current: Decodable {
        let time: String
        let interval: Int
        let temperature_2m: Double
        let weather_code: Int
        
        var weatherDescription: String {
            WeatherResponse.weatherDescription(for: weather_code)
        }
    }
    
    struct DailyUnits: Decodable {
        let time: String
        let weather_code: String
        let temperature_2m_max: String
        let temperature_2m_min: String
    }
    
    struct Daily: Decodable {
        let time: [String]
        let weather_code: [Int]
        let temperature_2m_max: [Double]
        let temperature_2m_min: [Double]
        
        func weatherDescription(for index: Int) -> String {
            guard weather_code.indices.contains(index) else { return "Unknown" }
            return WeatherResponse.weatherDescription(for: weather_code[index])
        }
    }
}
