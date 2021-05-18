import UIKit
import Flutter
import ARKit
import flutter_downloader

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private var mainCoordinator: AppCoordinator?
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    guard ARWorldTrackingConfiguration.isSupported else {
        fatalError("""
            ARKit is not available on this device. For apps that require ARKit
            for core functionality, use the `arkit` key in the key in the
            `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
            the app from installing. (If the app can't be installed, this error
            can't be triggered in a production scenario.)
            In apps where AR is an additive feature, use `isSupported` to
            determine whether to show UI for launching AR experiences.
        """) // For details, see https://developer.apple.com/documentation/arkit
    }
    
    GeneratedPluginRegistrant.register(with: self)
    
    let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
    //
    let tstChannel = FlutterMethodChannel(name: "com.objectbeam.flios/navToLogin",
                                          binaryMessenger: flutterViewController.binaryMessenger)
    tstChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: FlutterResult) -> Void in
        guard call.method == "goToLogin" else {
            result(FlutterMethodNotImplemented)
            return
        }
        self.mainCoordinator?.start()
    })

    let navigationController = UINavigationController(rootViewController: flutterViewController)
    navigationController.isNavigationBarHidden = true
    window?.rootViewController = navigationController
    mainCoordinator = AppCoordinator(navigationController: navigationController)
    window?.makeKeyAndVisible()
    
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

private func registerPlugins(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
       FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}
