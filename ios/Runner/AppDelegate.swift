import UIKit
import Flutter
import GoogleMaps
import Firebase
import flutter_background_service_ios

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR-API-KEY")
    FirebaseApp.configure()
    SwiftFlutterBackgroundServicePlugin.taskIdentifier = "dev.dashlingo.okepoint-dev"

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}



