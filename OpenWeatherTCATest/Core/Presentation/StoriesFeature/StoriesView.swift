//
//  StoriesView.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 25/04/2025.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct StoriesView: View {
    let store: StoreOf<StoriesReducer>
    @State private var timer: Timer?
    @StateObject private var orientationManager = DeviceOrientationManager()
    @Environment(\.dismiss) private var dismiss
    private let isPad = UIDevice.isPad
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            
            ZStack {
                if viewStore.isLoading {
                    ProgressView("Loading...")
                } else if viewStore.stories.indices.contains(viewStore.currentIndex) {
                    let story = viewStore.stories[viewStore.currentIndex]
                    
                    AsyncImage(url: story.imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable().scaledToFill()
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: screenWidth, maxHeight: screenHeight)
                    .ignoresSafeArea()
                    
                    VStack {
                        // progress bar
                        let screenWidth = UIScreen.main.bounds.width
                        let count = viewStore.stories.count
                        let spacing: CGFloat = 4
                        let barWidth = (screenWidth - CGFloat(count - 1) * spacing - 24) / CGFloat(count)
                        
                        HStack(spacing: 4) {
                            ForEach(viewStore.stories.indices, id: \.self) { index in
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .fill(Color.white.opacity(0.3))
                                        
                                        if index == viewStore.currentIndex {
                                            Capsule()
                                                .fill(Color.white)
                                                .frame(
                                                    width: barWidth * CGFloat(viewStore.progress)
                                                )
                                                .animation(
                                                    .linear(duration: 0.1),
                                                    value: viewStore.progress
                                                )
                                        } else if index < viewStore.currentIndex {
                                            Capsule().fill(Color.white)
                                        }
                                    }
                                }
                                .frame(height: 4)
                            }
                        }
                        .frame(height: 4)
                        .padding(.top, orientationManager.isLandscape ? 24 : 0)
                        .padding(.horizontal)
                        .zIndex(1)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Color.clear
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onEnded { value in
                                        if value.translation.width > 50 {
                                            viewStore.send(.previous)
                                        } else if value.translation.width < -50 {
                                            viewStore.send(.next)
                                        }
                                    }
                            )
                    }
                    // Close Button
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 16)
                                    .padding(.top, 10)
                            }
                        }
                        Spacer()
                    }
                }
                else {
                    let errorMessage: String = viewStore.errorMessage ?? ""
                    VStack {
                        Text("‼️ \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                        Button("Dismiss") {
                            viewStore.send(.dismissError)
                            dismiss()
                        }
                    }
                }
            }
            .onAppear {
                viewStore.send(.fetch)
                startProgressTimer(viewStore: viewStore)
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    // MARK: - Timer with Progress Updates
    private func startProgressTimer(viewStore: ViewStoreOf<StoriesReducer>) {
        let duration: Double = 3
        let interval: Double = 0.05
        var progress: Double = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: true
        ) { t in
            progress += interval / duration
            if progress >= 1.0 {
                progress = 0
                viewStore.send(.next)
            }
            viewStore.send(.updateProgress(progress))
        }
    }
}
