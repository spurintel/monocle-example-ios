#  Monocle iOS Example App

This repository provides an example iOS app demonstrating basic implementation of the [Monocle SDK for iOS](https://github.com/spurintel/monocle-sdk-ios).

In your production implementation, you would probably have this assessment automatically run in the background and POST the assessment to a backend service.  Exactly how you process the results depends on your use case and risk tolerance, but some typical workflows are shown in the [Monocle docs](https://docs.spur.us/monocle?id=about).

e.g. You may want to block residential sneaker proxies outright, but redirect other VPN users to just require MFA at login.

## Get a Monocle Site Token
1. Go to the [Monocle management](https://app.spur.us/monocle) page and create a new deployment.  
   You can either create a Spur Managed or a User Managed deployment, depending on how you want to handle the Monocle assessment.  
   A more complete description is available in the [Monocle Docs](https://docs.spur.us/monocle?id=quick-start). 
2. Copy the **site token** from the new deployment

## Open the Monocle example app in Xcode
1. Open Xcode and select `Clone Git Repository`
2. Enter repository URL: `https://github.com/spurintel/monocle-example-ios.git` and click Clone.
3. Open the `MonocleExampleIOSApp.swift` file and paste your site token in place of the value `CHANGEME`.
   ```swift
   let token = "CHANGEME"
   ```
   > It is OK to include the **site token** in the app, because it is neither secret nor user dependent.  DO NOT include the **API token** or **Deployment key** in any user facing application or interface.  These should only used to decrypt the Monocle assessment so you can make a decision on whether to allow access or not.
## Build and run
1. Choose one of the iOS simulators under `Product > Destination`  
   This will also run on a physical iOS device if connected properly. See the [Apple Developer docs](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device) for more details.
2. Build and run the example under `Product > Run`
3. The app should launch and present a Start Assessment button, which will load Monocle and run the assessment of the user's proxy/VPN usage.   

## Interpret the assessment
   In general, you would POST the Monocle assessment from the app to your backend and decrypt it.  
   Examples using the API (if Spur Managed) and sample code (if User Managed) in a variety of languages are included in the [Monocle Backend Integration docs](https://docs.spur.us/monocle?id=backend-integration).

## FAQ

### Can't I just use the native Swift network state APIs to determine if the device is on a VPN?

   You can and possibly should use native APIs as well, but there are several situations where this information is inaccurate.  These APIs also generally require additional system permissions the user has to approve, and are increasingly restrictive in recent iOS versions.  The native APIs also will not tell you which proxy/VPN service is in use or provide additional enrichment to make more subtle access decisions.  

### Missing Dependencies
   The [Monocle SDK package](https://github.com/spurintel/monocle-sdk-ios) should automatically pull from GitHub before it builds.  If it does not for some reason, manually check the dependency status.

   1. In Xcode, select the project MonocleExampleIOS file in the Project Navigator to open the project settings.  
      You should see the Swift package dependency for Monocle on the left under Package Dependencies.
   3. Right-click on the Monocle package and click `Update Package` to pull the latest version of the package from GitHub.

### Error: No such module 'UIKit'
   If you see this error message, you probably have selected an invalid build destination that is not iOS based.  Choose one of the iOS simulators under `Product > Destination` and try again.

### Error: Assessment Status Failed
   If you see this message, you probably have an invalid token or it was not included correctly in the source.  Make sure you are using the Site Token not the API Token for decryption from the [Monocle management](https://app.spur.us/monocle) page.

   This error could also arise if something is preventing communication with the Spur services.  e.g. network issues, DNS, antivirus, firewall

### Manually clone the example
1. Open Terminal on your Mac.
2. Navigate to the directory where you want to clone the project.
   ```sh
   cd /path/to/use/
   ```
3. Clone the repository using git clone command followed by the repository URL.
   ```sh
   git clone https://github.com/spurintel/monocle-example-ios.git
   ```
4. Open Finder and locate the `MonocleExampleIOS.xcodeproj` file in the new `monocle-example-ios` directory.
5. Double-click the file to open the project in Xcode.

### Does Monocle support Android?
   Yes. See [Monocle SDK for Android](https://github.com/spurintel/monocle-sdk-android)

### What about Flutter or ReactNative or other frameworks?
   Monocle is lightweight and should work on any platform that can execute Javascript in the client and make standard HTTPS GETs/POSTs, but it is untested at this time.  Please let us know if you try it.