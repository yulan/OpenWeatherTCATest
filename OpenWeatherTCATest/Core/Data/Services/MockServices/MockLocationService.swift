//
//  MockLocationService.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 25/04/2025.
//

import CoreLocation
import ComposableArchitecture

struct MockLocationService: LocationRepositoryProtocol {
    var requestAuthorizationHandler: () -> Void = {}
    var getCurrentLocationHandler: () async throws -> CLLocation = {
        CLLocation(latitude: 48.8566, longitude: 2.3522) // Pantin coordinates
    }
    var getAuthorizationStatusHandler: () -> CLAuthorizationStatus = { .authorizedWhenInUse }
    var getAuthorizationStatusStreamHandler: () -> AsyncStream<CLAuthorizationStatus> = {
        AsyncStream { continuation in
            continuation.yield(.authorizedWhenInUse)
            continuation.finish()
        }
    }

    func requestAuthorization() {
        requestAuthorizationHandler()
    }

    func getCurrentLocation() async throws -> CLLocation {
        try await getCurrentLocationHandler()
    }

    func getAuthorizationStatus() -> CLAuthorizationStatus {
        getAuthorizationStatusHandler()
    }

    func getAuthorizationStatusStream() -> AsyncStream<CLAuthorizationStatus> {
        getAuthorizationStatusStreamHandler()
    }
}
