//
//  WeatherMainInfoView.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 27/04/2025.
//

import SwiftUI

struct WeatherMainInfoView: View {
    let viewModel: WeatherViewModel
    let isPad: Bool
    let weatherIconMap: [String: String]
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            Text(viewModel.lastDateUpdated)
                .font(.system(size: isPad ? 44 : 34))
                .foregroundColor(.white)
            
            Text(viewModel.locationName)
                .font(.system(size: isPad ? 44 : 34, weight: .bold))
                .foregroundColor(.white)
            
            if let icon = viewModel.conditionIcons.first {
                Image(systemName: weatherIconMap[icon] ?? "sun.max.fill")
                    .font(.system(size: isPad ? 100 : 64))
                    .foregroundColor(.white)
            }
            
            Text(viewModel.temperature)
                .font(.system(size: isPad ? 80 : 56, weight: .semibold))
                .foregroundColor(.white)
            
            Text(viewModel.conditionDescription)
                .font(.system(size: isPad ? 28 : 20))
                .foregroundColor(.white.opacity(0.8))
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
