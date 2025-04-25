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
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
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
                                        //.frame(width: barWidth, height: 4)
                                        
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
                        .padding(.horizontal)
                        //.padding(.top, 12)
                        .zIndex(1)
                        
                        Spacer()
                    }
//                    .ignoresSafeArea()
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
    
    private func getSafeAreaInsets() -> UIEdgeInsets? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        return windowScene.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets
    }
}
