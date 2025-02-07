//
//  WeatherViewModel.swift
//  Weather Appl
//
//  Created by Morteza Safari on 2025-02-04.
//

import Foundation
import CoreLocation

extension WeatherViewModel: LocationManagerDelegate {
    func locationDidUpdate(to location: CLLocation) {
        Task { @MainActor in
            await fetchWeatherData()
        }
    }
}

@Observable
class WeatherViewModel {
    private let baseUrl = "https://api.open-meteo.com/v1/forecast"
    private let defaultLatitude = 62.0
    private let defaultLongitude = 15.0
    
    private(set) var isLoading = false
    private(set) var weatherData: WeatherResponse?
    let locationManager: LocationManager

    init(locationManager: LocationManager = LocationManager()) {
        self.locationManager = locationManager
        self.locationManager.delegate = self // Set as delegate
    }

    private func makeUrl(latitude: Double, longitude: Double) -> String {
        "\(baseUrl)?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min"
    }

    func fetchWeatherData() async {
        let latitude = locationManager.location?.coordinate.latitude ?? defaultLatitude
        let longitude = locationManager.location?.coordinate.longitude ?? defaultLongitude
        
        let urlString = makeUrl(latitude: latitude, longitude: longitude)
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedData = try decoder.decode(WeatherResponse.self, from: data)
            weatherData = decodedData
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    // Add this symbol mapping function
    func symbolForWeatherCode(_ code: Int) -> String {
        switch code {
        case 0: return "sun.max"          // Sunny
        case 1, 2: return "cloud.sun"     // Partly Cloudy
        case 3: return "cloud"            // Cloudy
        case 45, 48: return "cloud.fog"   // Foggy
        case 51...57: return "cloud.drizzle" // Drizzle
        case 61...67: return "cloud.rain" // Rain
        case 71...77: return "snow"       // Snow
        case 80...82: return "cloud.rain" // Rain Showers
        case 85...86: return "cloud.snow" // Snow Showers
        case 95...99: return "cloud.bolt.rain" // Thunderstorm
        default: return "questionmark"
        }
    }
    
    
}
