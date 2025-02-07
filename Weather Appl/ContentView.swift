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
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    
                    if let location = viewModel.locationManager.location {
                        Text("Current Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                    } else {
                        Text("No location available")
                    }
                    
                    if let address = locationService.address {
                        Text("Address: \(address)")
                    }
                    
                    NavigationLink("Go to Forecast", destination: ForecastView())
                        .padding()
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
                .navigationTitle("Home Screen")
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
