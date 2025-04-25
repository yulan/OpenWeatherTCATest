//
//  LocationManagerDelegate.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 25/04/2025.
//

import CoreLocation

final class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    var locationContinuation: CheckedContinuation<CLLocation, Error>?
    private var statusContinuation: AsyncStream<CLAuthorizationStatus>.Continuation?

    func statusStream() -> AsyncStream<CLAuthorizationStatus> {
        AsyncStream { continuation in
            self.statusContinuation = continuation
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        statusContinuation?.yield(status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationContinuation?.resume(returning: location)
            locationContinuation = nil
            manager.stopUpdatingLocation()
        } else {
            locationContinuation?.resume(throwing: LocationManagerError.locationFetchFailed)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
}
