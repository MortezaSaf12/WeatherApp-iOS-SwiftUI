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
    
    // Start continuous location updates
    func startUpdatingLocation() {
        if locationManager.authorizationStatus == .notDetermined {
            print("Requesting location authorization...")
            locationManager.requestWhenInUseAuthorization()
        } else if locationManager.authorizationStatus != .denied {
            print("Starting continuous location updates...")
            locationManager.startUpdatingLocation() // Continuous updates
        } else {
            print("Location services denied by the user.")
        }
    }
    
    /*
    func requestLocation() {
        if locationManager.authorizationStatus == .notDetermined {
            print("Requesting location authorization...")
            locationManager.requestWhenInUseAuthorization()
        } else if locationManager.authorizationStatus != .denied {
            print("Requesting single location update...")
            locationManager.requestLocation()
        } else {
            print("Location services denied by the user.")
        }
    }
    */
    
    private func reverseGeocodeLocation(_ location: CLLocation) {
        Task {
            do {
                let placemarks = try await geocoder.reverseGeocodeLocation(location)
                if let placemark = placemarks.last {
                    address = "\(placemark.locality ?? "Unknown"), \(placemark.country ?? "Unknown")"
                    print("Reverse geocoded address: \(address ?? "Unknown")")
                }
            } catch {
                print("Failed to reverse geocode location: \(error.localizedDescription)")
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        print("Location authorization status changed to: \(status.rawValue)")
        
        if status != .denied {
            print("Authorization granted or undetermined. Starting location updates...")
            startUpdatingLocation()
        } else {
            print("Location services denied by the user.")
        }
    }
    
    weak var delegate: LocationManagerDelegate?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("No location data received in didUpdateLocations.")
            return
        }
        
        print("Updated Location: Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
        
        self.location = location
        reverseGeocodeLocation(location)
        delegate?.locationDidUpdate(to: location) // Notify delegate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let clError = error as? CLError
        switch clError?.code {
        case .locationUnknown:
            print("Location is currently unknown. Retrying...")
            // Optionally, retry fetching the location after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.locationManager.startUpdatingLocation()
            }
        default:
            print("Failed to find user's location: \(error.localizedDescription)")
        }
    }
}

protocol LocationManagerDelegate: AnyObject {
    func locationDidUpdate(to location: CLLocation)
}
