import UIKit
import Flutter
import ARKit
import flutter_downloader

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var methodChannel: FlutterMethodChannel?
    private var eventChannel: FlutterEventChannel?
    
    private let linkStreamHandler = LinkStreamHandler()
    
  private var mainCoordinator: AppCoordinator?
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller = window.rootViewController as! FlutterViewController
    methodChannel = FlutterMethodChannel(name: "poc.deeplink.flutter.dev/channel", binaryMessenger: controller.binaryMessenger)
    eventChannel = FlutterEventChannel(name: "poc.deeplink.flutter.dev/events", binaryMessenger: controller.binaryMessenger)

    
    methodChannel?.setMethodCallHandler({ (call: FlutterMethodCall, result: FlutterResult) in
      guard call.method == "initialLink" else {
        result(FlutterMethodNotImplemented)
        return
      }
    })
    
    
    let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
    
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
    
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
    
    GeneratedPluginRegistrant.register(with: self)
    
    let navigationController = UINavigationController(rootViewController: flutterViewController)
    navigationController.isNavigationBarHidden = true
    window?.rootViewController = navigationController
    mainCoordinator = AppCoordinator(navigationController: navigationController)
    window?.makeKeyAndVisible()
    
    eventChannel?.setStreamHandler(linkStreamHandler)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      eventChannel?.setStreamHandler(linkStreamHandler)
      return linkStreamHandler.handleLink(url.absoluteString)
    }
}

private func registerPlugins(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
       FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}

class LinkStreamHandler:NSObject, FlutterStreamHandler {
  
  var eventSink: FlutterEventSink?
  
  // links will be added to this queue until the sink is ready to process them
  var queuedLinks = [String]()
  
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    queuedLinks.forEach({ events($0) })
    queuedLinks.removeAll()
    return nil
  }
  
  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    return nil
  }
  
  func handleLink(_ link: String) -> Bool {
    guard let eventSink = eventSink else {
      queuedLinks.append(link)
      return false
    }
    eventSink(link)
    return true
  }
}
