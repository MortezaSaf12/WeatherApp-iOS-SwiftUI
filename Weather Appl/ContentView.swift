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
                if let address = locationService.address {
                    Text(address)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                } else {
                    ProgressView("Fetching location...")
                }
                
                Spacer()
                
                if let weatherData = viewModel.weatherData {
                    VStack(spacing: 8) {
                        Image(systemName: viewModel.symbolForWeatherCode(weatherData.current.weather_code))
                            .font(.system(size: 48))
                            .symbolRenderingMode(.multicolor)
                        
                        Text("\(weatherData.current.temperature_2m, specifier: "%.0f")°C")
                            .font(.system(size: 72, weight: .medium))
                        
                        Text(weatherData.current.weatherDescription)
                            .font(.title3)
                            .foregroundColor(Color(.systemGray))
                    }
                } else {
                    ProgressView("Loading weather...")
                }
                
                Spacer()
                
                NavigationLink {
                    ForecastView(viewModel: viewModel)
                } label: {
                    Text("See 7-Day Forecast")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(#colorLiteral(red: 0.8392156863, green: 0.8823529412, blue: 0.9764705882, alpha: 1)))
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(#colorLiteral(red: 0.9254901961, green: 0.9568627451, blue: 0.9921568627, alpha: 1)),
                        Color(#colorLiteral(red: 0.8392156863, green: 0.8823529412, blue: 0.9764705882, alpha: 1))
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            
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
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = WeatherViewModel()

    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if let address = viewModel.locationManager.address {
                Text(address)
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            
            ScrollView {
                VStack(spacing: 20) {
                    if let daily = viewModel.weatherData?.daily {
                        ForEach(0..<7, id: \.self) { index in
                            HStack {
                                HStack {
                                    Text(formatDate(daily.time[index]))
                                        .font(.system(size: 15, weight: .semibold))
                                        .frame(width: 80, alignment: .leading)
                                    //Symbols
                                    Image(systemName: viewModel.symbolForWeatherCode(daily.weather_code[index]))
                                        .symbolRenderingMode(.multicolor)
                                }
                                
                                Spacer()
                                
                                // Temperature Display
                                HStack(spacing: 16) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "thermometer.sun")
                                        Text("\(daily.temperature_2m_max[index], specifier: "%.0f")°")
                                    }
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "thermometer.snowflake")
                                        Text("\(daily.temperature_2m_min[index], specifier: "%.0f")°")
                                    }
                                }
                                .font(.system(size: 16, weight: .medium))
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9)))
                                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
                            )
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            .padding(.horizontal, 16)
                        }
                    } else {
                        ProgressView("Loading forecast...")
                            .frame(maxHeight: .infinity)
                    }
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Button {
                dismiss()
            } label: {
                Text("Main Screen")
                    .frame(width: 200)
                    .padding()
                    .background(Color(#colorLiteral(red: 0.8392156863, green: 0.8823529412, blue: 0.9764705882, alpha: 1)))
                    .foregroundColor(.black)
                    .clipShape(Capsule())
                    .shadow(color: Color.blue.opacity(0.2), radius: 8, x: 0, y: 4)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Forecast")
                    .font(.headline)
            }
        }
        .navigationBarBackButtonHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(#colorLiteral(red: 0.9254901961, green: 0.9568627451, blue: 0.9921568627, alpha: 1)),
                    Color(#colorLiteral(red: 0.8392156863, green: 0.8823529412, blue: 0.9764705882, alpha: 1))
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
    
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
