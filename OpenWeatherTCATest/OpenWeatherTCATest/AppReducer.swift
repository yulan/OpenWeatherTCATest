//
//  AppReducer.swift
//  WeatherTCAApp
//
//  Created by Lan YU on 21/04/2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppReducer {
    struct State {
        var weather = WeatherReducer.State()
        var locationState = LocationReducer.State()
    }

    enum Action {
        case weather(WeatherReducer.Action)
        case location(LocationReducer.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.locationState, action: \.location) {
            LocationReducer()
        }
        Scope(state: \.weather, action: \.weather) {
            WeatherReducer()
        }
        Reduce { _, action in
            switch action {
            case .location(.locationPermissionDenied(let errorMessage)):
                return .send(.weather(.locationPermissionDenied(errorMessage)))
                
            case .location(.currentLocationResponse(.success(let location))):
                return .send(.weather(.fetchWeather(location)))
                
            case .weather(.needRequestAuthorization):
                return .send(.location(.requestAuthorization))
                
            default:
                return .none
            }
        }
    }
}
