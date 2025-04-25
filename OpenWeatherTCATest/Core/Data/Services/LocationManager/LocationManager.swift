//
//  LocationManager.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 24/04/2025.
//

import CoreLocation
import ComposableArchitecture

enum LocationManagerError: Error, Equatable {
    case locationServicesDisabled
    case authorizationDenied
    case locationFetchFailed
    case unknown
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager: CLLocationManager
    private let delegate: LocationManagerDelegate

    init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
        self.delegate = LocationManagerDelegate()
        super.init()
        self.manager.delegate = delegate
        self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }

    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return manager.authorizationStatus
    }

    func getAuthorizationStatusStream() -> AsyncStream<CLAuthorizationStatus> {
        return delegate.statusStream()
    }

    func getCurrentLocation() async throws -> CLLocation {
        guard CLLocationManager.locationServicesEnabled() else {
            throw LocationManagerError.locationServicesDisabled
        }

        let status = manager.authorizationStatus
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            throw LocationManagerError.authorizationDenied
        }

        manager.startUpdatingLocation()

        return try await withCheckedThrowingContinuation { continuation in
            delegate.locationContinuation = continuation
        }
    }
}
