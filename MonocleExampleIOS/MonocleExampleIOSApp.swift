//
//  MonocleExampleIOSApp.swift
//  MonocleExampleIOS
//
//  Created by Josh Junqueira on 4/25/24.
//

import SwiftUI
import Monocle
import CoreLocation

@main
struct MonocleExampleIOSApp: App {
    let locationManager = CLLocationManager()
    
    init() {
        let token = "CHANGEME"
        let config = MonocleConfig(token: token)
        Monocle.setup(config)
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
