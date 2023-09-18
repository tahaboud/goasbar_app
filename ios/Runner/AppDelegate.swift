import UIKit
import Flutter
import GoogleMaps
#import <OPPWAMobile/OPPWAMobile.h>

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
          guard call.method == "savecard" else {
                 result(FlutterMethodNotImplemented)
                 return
          }

          let args = call.arguments as? Dictionary<String,Any>
          self.checkoutId = (args!["checkoutid"] as? String)!
          self.brand = (args!["brand"] as? String)!
          self.number = (args!["number"] as? String)!
          self.holder = (args!["holder"] as? String)!
          self.expiryMonth = (args!["expiryMonth"] as? String)!
          self.expiryYear = (args!["expiryYear"] as? String)!
          self.cvv = (args!["cvv"] as? String)!

          let params = try? OPPCardPaymentParams(checkoutID: checkoutId, paymentBrand: brand, holder: holder, number: number, expiryMonth: expiryMonth, expiryYear: expiryYear, cvv: cvv)
          params.shopperResultURL = "goasbar://result"

          let transaction = OPPTransaction(paymentParams: params)
          provider.submitTransaction(transaction) { (transaction, error) in
              guard let transaction = transaction else {
                  // Handle invalid transaction, check error
                  return
              }

              if transaction.type == .asynchronous {
                   // Open transaction.redirectURL in Safari browser to complete the transaction
              } else if transaction.type == .synchronous {
                  // Send request to your server to obtain transaction status
              } else {
                  // Handle the error
              }
          }

    })
    GMSServices.provideAPIKey("AIzaSyB_tfRdTmBWSQflRl4YYsdBzLYjUswIVwY")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}