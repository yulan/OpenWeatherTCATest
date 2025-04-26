//
//  AppViews.swift
//  WeatherTCAApp
//
//  Created by Lan YU on 21/04/2025.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct AppView: View {
    let store: StoreOf<AppReducer>
        @State private var showSplashScreen = true // 控制是否显示启动画面

        var body: some View {
            Group {
                if showSplashScreen {
                    SplashScreen(showSplashScreen: $showSplashScreen) // 传递绑定
                } else {
                    WeatherView(
                        store: store.scope(
                            state: \.weather,
                            action: \.weather
                        )
                    )
                    .onAppear {
                        store.send(.location(.requestAuthorization))
                    }
                }
            }
        }
}

