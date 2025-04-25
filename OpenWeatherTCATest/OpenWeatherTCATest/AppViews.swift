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
    
    var body: some View {
        WeatherView(
            store: store.scope(
                state: \.weather,
                action: \.weather
            )
        )
    }
}

