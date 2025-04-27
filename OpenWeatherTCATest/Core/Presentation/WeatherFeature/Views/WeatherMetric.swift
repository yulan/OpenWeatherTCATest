//
//  WeatherMetric.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 25/04/2025.
//

import SwiftUI

struct WeatherMetric: View {
    let title: String
    let value: String
    let isPad: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: isPad ? 28 : 18, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))
            Text(value)
                .font(.system(size: isPad ? 28 : 18, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
    }
}
