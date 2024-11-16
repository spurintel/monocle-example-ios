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
        // Configuration defaults to using all plugins.
        // If you would like to only allow certain plugins to run you can configure them with the enabledPlugins option
        //let config = MonocleConfig(token: token, enabledPlugins: [.dns, .deviceInfo, .location])
        
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
