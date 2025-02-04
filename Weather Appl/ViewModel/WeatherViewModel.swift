//
//  WeatherViewModel.swift
//  Weather Appl
//
//  Created by Morteza Safari on 2025-02-04.
//

import Foundation

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
    }

    private func makeUrl(latitude: Double, longitude: Double) -> String {
        "\(baseUrl)?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=Europe%2FBerlin"
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
}
