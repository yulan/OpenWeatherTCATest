//
//  OpenWeatherTCATestApp.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 24/04/2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct OpenWeatherTCATestApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(
                    initialState: AppReducer.State(),
                    reducer: {
                        AppReducer()
                    }
                )
            )
        }
    }
}
