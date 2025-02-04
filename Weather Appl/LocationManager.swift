//
//  ManageLocation.swift
//  Weather App
//
//  Created by Morteza Safari on 2025-02-03.
//

import Foundation
import CoreLocation
import Observation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    var location: CLLocation?
    var address: String?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if locationManager.authorizationStatus != .denied {
            locationManager.requestLocation()
        }
    }

    private func reverseGeocodeLocation(_ location: CLLocation) {
        Task {
            let placemarks = try? await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks?.last {
                address = "\(placemark.locality ?? "Unknown"), \(placemark.country ?? "Unknown")"
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus != .denied {
            requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        if let location = location {
            reverseGeocodeLocation(location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
