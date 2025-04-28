//
//  WeatherReducerTests.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 28/04/2025.
//

import XCTest
import ComposableArchitecture
import CoreLocation
@testable import OpenWeatherTCATest
import Testing

final class WeatherReducerTests: XCTestCase {
    func testFetchWeatherSuccess() async throws {
        let mockRepository = MockWeatherService(result: .success(MockWeatherService.weatherDTO))
        let expectedWeather = MockWeatherService.weatherDTO.toDomain()
        
        let store = await TestStore(
            initialState: WeatherReducer.State(),
            reducer: { WeatherReducer()
            }) {
                $0.weatherRepository = mockRepository
            }
        
        await store.send(.fetchWeather(CLLocation(latitude: 48.893732, longitude: 2.406402))) {
            $0.isFetchingWeather = true
            $0.errorType = nil
            $0.lastLocation = CLLocation(latitude: 48.893732, longitude: 2.406402)
        }
        
        await store.receive(.weatherResponse(.success(expectedWeather))) {
            $0.weather = expectedWeather
            $0.isFetchingWeather = false
            $0.errorType = nil
        }
    }
    
    func testFetchWeatherFailure() async throws {
        let mockRepository = MockWeatherService(result: .failure(.networkFailure))
        
        let store = await TestStore(
            initialState: WeatherReducer.State(),
            reducer: { WeatherReducer()
            }) {
                $0.weatherRepository = mockRepository
            }
        
        await store.send(.fetchWeather(CLLocation(latitude: 48.893732, longitude: 2.406402))) {
            $0.isFetchingWeather = true
            $0.errorType = nil
            $0.lastLocation = CLLocation(latitude: 48.893732, longitude: 2.406402)
        }
        
        await store.receive(.weatherResponse(.failure(.networkFailure))) {
            $0.isFetchingWeather = false
            $0.errorType = .networkFailure
        }
    }
    
    func testRetryLastFetchWeatherSuccess() async throws {
        let mockRepository = MockWeatherService(result: .success(MockWeatherService.weatherDTO))
        let expectedWeather = MockWeatherService.weatherDTO.toDomain()
        
        var initialState = WeatherReducer.State()
        initialState.lastLocation = CLLocation(latitude: 48.893732, longitude: 2.406402)
        initialState.errorType = .networkFailure
        
        let store = await TestStore(
            initialState: initialState,
            reducer: { WeatherReducer()
            }) {
                $0.weatherRepository = mockRepository
            }
        
        await store.send(.retryLastFetchWeather) {
            $0.isFetchingWeather = true
        }
        
        await store.receive(.weatherResponse(.success(expectedWeather))) {
            $0.weather = expectedWeather
            $0.isFetchingWeather = false
            $0.errorType = nil
        }
    }
    
    func testRetryLastFetchWeatherFailure() async throws {
        let mockRepository = MockWeatherService(result: .failure(.networkFailure))
        
        var initialState = WeatherReducer.State()
        initialState.lastLocation = CLLocation(latitude: 48.893732, longitude: 2.406402)
        initialState.errorType = .networkFailure
        
        let store = await TestStore(
            initialState: initialState,
            reducer: { WeatherReducer()
            }) {
                $0.weatherRepository = mockRepository
            }
        
        await store.send(.retryLastFetchWeather) {
            $0.isFetchingWeather = true
        }
        
        await store.receive(.weatherResponse(.failure(.networkFailure))) {
            $0.isFetchingWeather = false
            $0.errorType = .networkFailure
        }
    }
    
    func testLocationPermissionDeniedAlert() async throws {
        let store = await TestStore(
            initialState: WeatherReducer.State(),
            reducer: { WeatherReducer()
            })
        
        await store.send(.locationPermissionDenied("Location permissions are required.")) {
            $0.alert = AlertState {
                TextState("Location permissions are required.")
            } actions: {
                ButtonState(role: .cancel, action: .cancelTapped) {
                    TextState("Cancel")
                }
                ButtonState(action: .openSettingsTapped) {
                    TextState("Open Settings")
                }
            } message: {
                TextState("Please enable location permissions in Settings to use weather features.")
            }
            $0.errorType = .permissionDenied
        }
    }
}
