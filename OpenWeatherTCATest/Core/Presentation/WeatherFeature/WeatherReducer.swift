//
//  WeatherReducer.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 21/04/2025.
//

import SwiftUI
import ComposableArchitecture
import CoreLocation

enum WeatherFetchError: Error {
    case api(Error)
    case unknown(Error)
}

@Reducer
struct WeatherReducer {
    @ObservableState
    struct State {
        var weather: Weather? = nil
        var isFetchingWeather: Bool = false
        var errorMessage: String?
        var showStories = false
        @Presents var alert: AlertState<Action.Alert>?
    }

    @CasePathable
    enum Action {
        case locationPermissionDenied(String)
        case needRequestAuthorization
        case fetchWeather(CLLocation)
        case weatherResponse(Result<Weather, WeatherFetchError>)
        case didReceiveError(String)
        case navigateToStories(Bool)
        case alert(PresentationAction<Alert>)

        @CasePathable
        enum Alert {
            case openSettingsTapped
            case cancelTapped
        }
    }

    @Dependency(\.weatherRepository) var weatherRepository
    @Dependency(\.openURL) var openURL

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .locationPermissionDenied(errorMessage):
                state.alert = AlertState {
                    //TextState("Location Access Denied")
                    TextState(errorMessage)
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
                state.errorMessage = errorMessage
                print("locationPermissionDenied errorMessage \(errorMessage)")
                return .none
                
            case .needRequestAuthorization:
                return .none
                
            case .alert(.presented(.openSettingsTapped)):
                return .run { _ in
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        await openURL(url)
                    }
                }
                
            case .alert(.presented(.cancelTapped)):
                state.alert = nil
                return .none

            case .alert:
                return .none
                
            case .fetchWeather(let location):
                state.isFetchingWeather = true
                state.errorMessage = nil
                return .run { send in
                    do {
                        let lat = location.coordinate.latitude
                        let lon = location.coordinate.longitude
                        let weatherDTO = try await weatherRepository.fetchWeather(for: lat, and: lon)
                        let weather = weatherDTO.toDomain()
                        await send(.weatherResponse(.success(weather)))
                    } catch let error as WeatherFetchError {
                        await send(.weatherResponse(.failure(error)))
                    }
                }

            case .weatherResponse(.success(let weather)):
                state.weather = weather
                state.isFetchingWeather = false
                return .none

            case .weatherResponse(.failure(let error)):
                state.isFetchingWeather = false
                state.errorMessage = "Failed to fetch weather: \(error.localizedDescription)"
                return .none
                
            case .didReceiveError(let message):
                state.errorMessage = message
                return .none
                
            case .navigateToStories(let show):
                state.showStories = show
                //print("city name: \(cityName)")
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - Equatable for WeatherReducer.State

extension WeatherReducer.State: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.weather == rhs.weather &&
        lhs.isFetchingWeather == rhs.isFetchingWeather &&
        lhs.errorMessage == rhs.errorMessage &&
        lhs.showStories == rhs.showStories //&&
        //lhs.alert == rhs.alert
    }
}

// MARK: - Equatable for WeatherReducer.Action

extension WeatherReducer.Action: Equatable {
    static func == (lhs: WeatherReducer.Action, rhs: WeatherReducer.Action) -> Bool {
        switch (lhs, rhs) {
        case let (.locationPermissionDenied(a), .locationPermissionDenied(b)):
            return a == b
            
        case let (.fetchWeather(a), .fetchWeather(b)):
            return a.coordinate.latitude == b.coordinate.latitude &&
                   a.coordinate.longitude == b.coordinate.longitude

        case let (.weatherResponse(.success(a)), .weatherResponse(.success(b))):
            return a == b

        case let (.weatherResponse(.failure(a)), .weatherResponse(.failure(b))):
            return a.localizedDescription == b.localizedDescription

        case let (.didReceiveError(a), .didReceiveError(b)):
            return a == b

        case let (.navigateToStories(a), .navigateToStories(b)):
            return a == b
            
//        case (.alert, .alert):
//            return true

        default:
            return false
        }
    }
}
