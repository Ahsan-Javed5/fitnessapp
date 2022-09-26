import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let fileSaveChannel = FlutterMethodChannel(name: "image_gallery_saver",
                                                   binaryMessenger: controller.binaryMessenger)
        
        fileSaveChannel
            .setMethodCallHandler({ [weak self](call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                switch call.method {
                case "saveFileToGallery":
                    result("response from native")
                default:
                    result(FlutterMethodNotImplemented)
                }
            })
        GeneratedPluginRegistrant.register(with: self)
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}


private func registerPlugins(registry: FlutterPluginRegistry) {
    
}

