//
//  UIDeviceExtension.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 27/04/2025.
//

import UIKit

extension UIDevice {
    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isPadLandscape: Bool {
        UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isLandscape
    }
}
