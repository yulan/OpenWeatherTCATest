//
//  DeviceOrientationReducer.swift
//  OpenWeatherTCATest
//
//  Created by Lan YU on 27/04/2025.
//

import SwiftUI
import Combine

class DeviceOrientationManager: ObservableObject {
    @Published var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    
    private var cancellable: AnyCancellable?
    
    init() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    
        cancellable = NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .sink { [weak self] _ in
                guard let self = self else { return }
                let orientation = UIDevice.current.orientation
                self.isLandscape = orientation.isLandscape
            }
    }
    
    deinit {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        cancellable?.cancel()
    }
}
