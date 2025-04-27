//
//  WeatherSkeletonView.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 27/04/2025.
//

import SwiftUI

struct WeatherSkeletonView: View {
    let columns: [GridItem]

    var body: some View {
        VStack(spacing: 16) {
            SkeletonView()
                .frame(width: 150, height: 24)

            SkeletonView()
                .frame(width: 100, height: 100)

            SkeletonView()
                .frame(width: 200, height: 50)

            SkeletonView()
                .frame(width: 300, height: 20)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0..<6, id: \.self) { _ in
                    SkeletonView()
                        .frame(height: 80)
                }
            }
        }
        .padding()
    }
}

