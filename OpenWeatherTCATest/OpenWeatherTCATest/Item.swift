//
//  Item.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 24/04/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
