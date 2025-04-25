//
//  WeatherRepository.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 24/04/2025.
//

import Foundation

protocol WeatherRepositoryProtocol {
    func fetchWeather(for lat: Double, and lon: Double) async throws -> WeatherResponseDTO
}
