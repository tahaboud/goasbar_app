import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var checkoutId:String = "";
  var brand:String = "";
  var number:String = "";
  var holder:String = "";
  var expiryMonth:String = "";
  var expiryYear:String = "";
  var cvv:String = "";

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "Hyperpay.demo.fultter/channel",
                                                  binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          

    })
    GMSServices.provideAPIKey("AIzaSyB_tfRdTmBWSQflRl4YYsdBzLYjUswIVwY")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
