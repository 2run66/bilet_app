import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // Register liquid glass tab bar with SwiftUI .glassEffect() (iOS 26 native)
    if #available(iOS 15.0, *) {
      if let registrar = self.registrar(forPlugin: "SwiftUILiquidGlassTabBar") {
        let tabFactory = SwiftUILiquidGlassTabBarFactory(messenger: registrar.messenger())
        registrar.register(tabFactory, withId: "liquid_glass_tabbar")
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
