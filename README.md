# Weather App

A minimalist iOS weather application that provides current weather conditions and 7-day forecasts based on your location.

## Features

- **Real-time Location Tracking**: Automatically detects and updates based on your current location
- **Current Weather Display**: Shows temperature, weather conditions, and appropriate weather icons
- **7-Day Forecast**: Detailed daily forecasts with min/max temperatures
- **Elegant UI**: Clean gradient interface with SF Symbols weather icons
- **Pull-to-Refresh**: Update weather data with a simple swipe down

## Tech Stack

- **SwiftUI**: Modern declarative UI framework
- **Swift Observable Macro**: State management using @Observable
- **CoreLocation**: Location services and geocoding
- **Open-Meteo API**: Free weather data API
- **URLSession**: Async/await network requests

## Architecture

The app follows MVVM pattern with the following structure:

- `ContentView.swift` - Main weather view and forecast navigation
- `WeatherViewModel.swift` - Weather data fetching and business logic
- `LocationManager.swift` - Location services handling
- `WeatherData.swift` - Data models for API responses

## API

Uses [Open-Meteo Weather API](https://open-meteo.com/) which provides:
- Current weather conditions
- 7-day forecasts
- Temperature data (min/max)
- Weather codes for various conditions

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Location permissions (when in use)

## Setup

1. Clone the repository
2. Open `Weather Appl.xcodeproj` in Xcode
3. Build and run on simulator or device
4. Grant location permissions when prompted

## Permissions

The app requires "Location When In Use" permission to fetch weather data for your current location.

## Weather Codes

The app interprets WMO weather codes to display appropriate SF Symbols:
- Clear sky (0)
- Partly cloudy (1-3)
- Fog (45, 48)
- Drizzle (51-57)
- Rain (61-67)
- Snow (71-77)
- Thunderstorms (95-99)

## Author

Morteza Safari
