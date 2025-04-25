//
//  LocationService.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 25/04/2025.
//

import CoreLocation
import ComposableArchitecture

enum LocationServiceError: Error, Equatable {
    case authorizationDenied
    case unableToFetchLocation
    case unknown
}

final class LocationService: LocationRepositoryProtocol {
    private let manager: CLLocationManager
    private let delegate: LocationManagerDelegate

    init() {
        self.manager = CLLocationManager()
        self.delegate = LocationManagerDelegate()
        self.manager.delegate = self.delegate
        self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
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

    func getAuthorizationStatus() -> CLAuthorizationStatus {
        manager.authorizationStatus
    }

    func getAuthorizationStatusStream() -> AsyncStream<CLAuthorizationStatus> {
        delegate.statusStream()
    }
}

extension DependencyValues {
    var locationRepository: LocationRepositoryProtocol {
        get { self[LocationRepositoryKey.self] }
        set { self[LocationRepositoryKey.self] = newValue }
    }
}

private enum LocationRepositoryKey: DependencyKey {
    static let liveValue: LocationRepositoryProtocol = LocationService()
    static let testValue: LocationRepositoryProtocol = MockLocationService()
}
