//
//  LocationRepository.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 24/04/2025.
//

import CoreLocation

protocol LocationRepositoryProtocol {
    func requestAuthorization()
    func getCurrentLocation() async throws -> CLLocation
    func getAuthorizationStatus() -> CLAuthorizationStatus
    func getAuthorizationStatusStream() -> AsyncStream<CLAuthorizationStatus>
}
