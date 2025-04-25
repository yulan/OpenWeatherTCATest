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
    }

    enum Action {
        case weather(WeatherReducer.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.weather, action: \.weather) {
            WeatherReducer()
        }
    }
}
