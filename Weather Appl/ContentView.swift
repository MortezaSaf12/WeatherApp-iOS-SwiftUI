//
//  ContentView.swift
//  Weather App
//
//  Created by Morteza Safari on 2025-02-03.
//

import SwiftUI

struct ContentView: View {
    @State private var locationService = LocationManager()
    @State private var viewModel = WeatherViewModel()
    
    init() {
        let locationManager = LocationManager()
        _locationService = State(initialValue: locationManager)
        _viewModel = State(initialValue: WeatherViewModel(locationManager: locationManager))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Location Name
                if let address = locationService.address {
                    Text(address)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                } else {
                    ProgressView("Fetching location...")
                }
                
                Spacer()
                
                // Temperature and Condition
                if let weatherData = viewModel.weatherData {
                    Text("\(weatherData.current.temperature_2m, specifier: "%.0f")°C")
                        .font(.system(size: 72, weight: .medium))
                } else {
                    ProgressView("Loading weather...")
                }
                
                Spacer()
                
                // Forecast Button
                NavigationLink {
                    ForecastView()
                } label: {
                    Text("See 7-Day Forecast")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
            }
            .padding()
            .task {
                locationService.startUpdatingLocation()
                await viewModel.fetchWeatherData()
            }
            .refreshable {
                locationService.startUpdatingLocation()
                await viewModel.fetchWeatherData()
            }
        }
    }
}



struct ForecastView: View {
    var body: some View {
        VStack {
            Text("Weather Forecast")
                .font(.largeTitle)
                .padding()
        }
        .navigationTitle("Forecast")
    }
}

#Preview {
    ContentView()
}
