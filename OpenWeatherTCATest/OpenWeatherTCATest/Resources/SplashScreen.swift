//
//  SplashScreen.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 25/04/2025.
//

import SwiftUI

struct SplashScreen: View {
    @Binding var showSplashScreen: Bool
    @State private var logoScale = 0.8
    @State private var logoOpacity = 0.5
    
    private let animationDuration: Double = 3

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
                        
            VStack {
                Spacer()
                
                Image(systemName: "cloud.sun.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.orange)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: animationDuration - 1)) {
                            self.logoScale = 1.0
                            self.logoOpacity = 1.0
                        }
                    }
                
                Text("Open Weather")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .padding(.top, 16)
                
                Spacer()
                
                Text("Powered by OpenWeather")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 24)
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) 
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                withAnimation {
                    showSplashScreen = false
                }
            }
        }
    }
}
