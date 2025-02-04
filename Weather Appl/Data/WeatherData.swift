//
//  WeatherData.swift
//  Weather Appl
//
//  Created by Morteza Safari on 2025-02-04.
//

import Foundation

//Defining structs matching the JSON struture of the API
struct WeatherResponse: Decodable {
    let latitude: Double
    let longitude: Double
    let generationtime_ms: Double
    let utc_offset_seconds: Int
    let timezone: String
    let timezone_abbreviation: String
    let elevation: Double
    let current_units: CurrentUnits
    let current: Current
    let daily_units: DailyUnits
    let daily: Daily

    struct CurrentUnits: Decodable {
        let time: String
        let interval: String
        let temperature_2m: String
        let weather_code: String
    }

    struct Current: Decodable {
        let time: String
        let interval: Int
        let temperature_2m: Double
        let weather_code: Int
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
    }
}

// Decodable structs: Allows us to decode the JSON response from the API into Swift objects.
