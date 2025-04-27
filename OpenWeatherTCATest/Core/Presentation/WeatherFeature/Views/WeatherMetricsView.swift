//
//  WeatherMetricsView.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 27/04/2025.
//

import SwiftUI

struct WeatherMetricsView: View {
    let viewModel: WeatherViewModel
    let isPad: Bool
    let columns: [GridItem]

    var body: some View {
        VStack(spacing: 16) {
            if isPad {
                Spacer()
            }
            
            LazyVGrid(columns: columns, spacing: 16) {
                WeatherMetric(title: "FEELS LIKE", value: viewModel.feelsLikeTemperature, isPad: isPad)
                WeatherMetric(title: "MIN", value: viewModel.minTemperature, isPad: isPad)
                WeatherMetric(title: "MAX", value: viewModel.maxTemperature, isPad: isPad)
                WeatherMetric(title: "PRESSURE", value: viewModel.pressure, isPad: isPad)
                WeatherMetric(title: "HUMIDITY", value: viewModel.humidity, isPad: isPad)
                WeatherMetric(title: "WIND", value: "\(viewModel.windSpeed) \(viewModel.windDirection)", isPad: isPad)
                WeatherMetric(title: "CLOUDS", value: viewModel.cloudiness, isPad: isPad)
                WeatherMetric(title: "COUNTRY", value: viewModel.country, isPad: isPad)
            }

            HStack(spacing: 16) {
                Label(viewModel.sunriseTime, systemImage: "sunrise")
                Label(viewModel.sunsetTime, systemImage: "sunset")
            }
            .font(.system(size: isPad ? 28 : 18, weight: .semibold))
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
