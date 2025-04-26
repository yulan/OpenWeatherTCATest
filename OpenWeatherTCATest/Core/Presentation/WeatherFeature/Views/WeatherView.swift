//
//  WeatherView.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 21/04/2025.
//

import SwiftUI
import ComposableArchitecture

struct WeatherView: View {
    @Bindable var store: StoreOf<WeatherReducer>
    
    let weatherIconMap: [String: String] = [
        "01d": "sun.max.fill",
        "02d": "cloud.sun.fill",
        "03d": "cloud.fill",
        "04d": "smoke.fill",
        "09d": "cloud.drizzle.fill",
        "10d": "cloud.rain.fill",
        "11d": "cloud.bolt.rain.fill",
        "13d": "snow",
        "50d": "cloud.fog.fill"
    ]
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        WithViewStore(store, observe: \.self) { viewStore in
            NavigationStack {
                if let weather = viewStore.weather {
                    let viewModel = WeatherViewModel(weather: weather)
                    ZStack {
                        LinearGradient(
                            colors: [
                                Color.skyTop,
                                Color.skyBottom
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .ignoresSafeArea()
                        ScrollView {
                            VStack(spacing: 24) {
                                // Top section
                                VStack(spacing: 12) {
                                    
                                    Text(viewModel.locationName)
                                        .font(.largeTitle)
                                        .bold()
                                        .foregroundColor(.white)
                                    
                                    if let icon = viewModel.conditionIcons.first {
                                        Image(systemName: weatherIconMap[icon] ?? "sun.max.fill")
                                            .font(.system(size: 64))
                                            .foregroundColor(.white)
                                    }
                                    
                                    Text(viewModel.temperature)
                                        .font(.system(size: 56, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Text(viewModel.conditionDescription)
                                        .font(.title3)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                // Metrics grid
                                LazyVGrid(columns: columns, spacing: 16) {
                                    WeatherMetric(title: "FEELS LIKE", value: viewModel.feelsLikeTemperature)
                                    WeatherMetric(title: "MIN", value: viewModel.minTemperature)
                                    WeatherMetric(title: "MAX", value: viewModel.maxTemperature)
                                    WeatherMetric(title: "PRESSURE", value: viewModel.pressure)
                                    WeatherMetric(title: "HUMIDITY", value: viewModel.humidity)
                                    WeatherMetric(title: "WIND", value: "\(viewModel.windSpeed) \(viewModel.windDirection)")
                                    WeatherMetric(title: "CLOUDS", value: viewModel.cloudiness)
                                }
                                
                                // Footer info
                                HStack(spacing: 16) {
                                    Text(viewModel.country)
                                    Label(viewModel.sunriseTime, systemImage: "sunrise")
                                    Label(viewModel.sunsetTime, systemImage: "sunset")
                                }
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                
                                // Stories button
                                Button(action: {
                                    viewStore.send(.navigateToStories(true))
                                }) {
                                    Text("View Stories")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(12)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                        }
                    }
                    .navigationDestination(
                        isPresented: viewStore.binding(
                            get: \.showStories,
                            send: WeatherReducer.Action.navigateToStories(true)
                        )
                    ) {
                        StoriesView(store: Store(
                            initialState: StoriesReducer.State(city: viewStore.weather?.name ?? "Paris"),
                            reducer: { StoriesReducer() }
                        ))
                        .navigationBarHidden(true)
                        .onDisappear {
                            viewStore.send(.navigateToStories(false))
                        }
                    }
                } else if let errorMessage = viewStore.errorMessage {
                    Text(errorMessage)
                }
                else {
                    ProgressView()
                }
            }
        }
    }
}
