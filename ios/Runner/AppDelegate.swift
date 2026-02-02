import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configure Firebase manually with options
    let firebaseOptions = FirebaseOptions(
      googleAppID: "1:105361803513:ios:bdce2661bf9671a1e73a28",
      gcmSenderID: "105361803513"
    )
    firebaseOptions.apiKey = "AIzaSyAr8a9Gtm_2wQaTXZvE-oODUVumMIJBQyk"
    firebaseOptions.projectID = "gosharpsharp-2b165"
    firebaseOptions.storageBucket = "gosharpsharp-2b165.firebasestorage.app"
    firebaseOptions.bundleID = "com.gosharpsharp.customer"
    
    FirebaseApp.configure(options: firebaseOptions)

    // Load Google Maps API key from Info.plist
    if let apiKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_MAPS_API_KEY") as? String {
      GMSServices.provideAPIKey(apiKey)
    }

    GeneratedPluginRegistrant.register(with: self)

    // Register for push notifications
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}