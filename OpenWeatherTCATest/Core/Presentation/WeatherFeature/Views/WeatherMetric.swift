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
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            Text(value)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
    }
}
