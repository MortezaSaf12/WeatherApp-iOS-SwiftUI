//
//  ContentView.swift
//  Weather App
//
//  Created by Morteza Safari on 2025-02-03.
//

import SwiftUI

struct ContentView: View {
    @State private var locationService = LocationManager()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            if let location = locationService.location {
                Text("Current Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            } else {
                Text("No location available")
            }
            
            if let address = locationService.address {
                Text("Address: \(address)")
            }
        }
        .padding()
        .onAppear {
            locationService.requestLocation()
        }
        .refreshable {
            locationService.requestLocation()
        }
    }
}

#Preview {
    ContentView()
}
