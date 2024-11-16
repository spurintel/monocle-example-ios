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
        let decryptionToken = "CHANGEME"
        
        // Configuration defaults to using all plugins.
        // If you would like to only allow certain plugins to run you can configure them with the enabledPlugins option
        //let config = MonocleConfig(token: token, enabledPlugins: [.dns, .deviceInfo, .location])
        
        
        // If you are utilizing user managed decryption you do not need to provide the decryption token.
        // However you will need to implement the decryption yourself.
        // This example app uses spur managed decryption to keep things simple.
        // let config = MonocleConfig(token: token)
        
        let config = MonocleConfig(token: token, decryptionToken: decryptionToken)
        Monocle.setup(config)
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
