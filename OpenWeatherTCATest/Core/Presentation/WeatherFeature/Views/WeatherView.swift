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
    @StateObject private var orientationManager = DeviceOrientationManager()
    
    private let weatherIconMap: [String: String] = [
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
    private let isPad = UIDevice.isPad
    
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
                            
                            Spacer(minLength: 50)
                            
                            if orientationManager.isLandscape {
                                HStack(alignment: .center, spacing: 32) {
                                    WeatherMainInfoView(
                                        viewModel: viewModel,
                                        isPad: isPad,
                                        weatherIconMap: weatherIconMap
                                    )
                                    WeatherMetricsView(
                                        viewModel: viewModel,
                                        isPad: isPad,
                                        columns: columns
                                    )
                                }
                            } else {
                                VStack(spacing: 24) {
                                    WeatherMainInfoView(
                                        viewModel: viewModel,
                                        isPad: isPad,
                                        weatherIconMap: weatherIconMap
                                    )
                                    WeatherMetricsView(
                                        viewModel: viewModel,
                                        isPad: isPad,
                                        columns: columns
                                    )
                                }
                            }
                                
                            Spacer(minLength: 20)
                            
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
                                    .font(.system(size: isPad ? 28 : 18, weight: .semibold))
                            }
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
                } else if let errorType = viewStore.errorType  {
                    VStack(spacing: 16) {
                        Text(errorType.localizedDescription)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        
                        retryButton(
                            for: errorType,
                            viewStore: viewStore,
                            isPad: isPad
                        )
                    }
                } else {
                    VStack {
                        WeatherSkeletonView(columns: columns)
                    }
                }
            }
            .alert(
                $store.scope(
                    state: \.alert,
                    action: \.alert
                )
            )
        }
    }
    
    private func retryButton(
        for errorType: WeatherError,
        viewStore: ViewStoreOf<WeatherReducer>,
        isPad: Bool
    ) -> some View {
        switch errorType {
        case .api, .networkFailure, .unknown:
            return RetryButton(
                title: "Retry",
                backgroundColor: .blue, isPad: isPad
            ) {
                viewStore.send(.retryLastFetchWeather)
            }
            
        case .permissionDenied:
            return RetryButton(
                title: "Grant Permissions",
                backgroundColor: .blue, isPad: isPad
            ) {
                viewStore.send(.retryRequestAuthorization)
            }
        }
    }
}
