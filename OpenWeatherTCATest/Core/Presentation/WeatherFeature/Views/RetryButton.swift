//
//  RetryButton.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 27/04/2025.
//

import SwiftUI

struct RetryButton: View {
    let title: String
    let backgroundColor: Color
    let isPad: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .font(
                    .system(
                        size: isPad ? 28 : 18,
                        weight: .semibold
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}
