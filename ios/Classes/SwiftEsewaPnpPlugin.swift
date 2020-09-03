import Flutter
import UIKit
import EsewaSDK

public class SwiftEsewaPnpPlugin: NSObject, FlutterPlugin, EsewaSDKPaymentDelegate {
   
    var result: FlutterResult?
    
    var sdk: EsewaSDK?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "esewa_pnp", binaryMessenger: registrar.messenger())
    let instance = SwiftEsewaPnpPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    self.result = result
    if call.method == "initPayment" {
        initPay(args: call.arguments)
    } else {
        result(FlutterMethodNotImplemented)
    }
  }
    
    func initPay(args: Any?) {
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        
        // getting values from arguments
        let argsMap = args as! NSDictionary
        
        let configs = argsMap.value(forKey: "config") as! NSDictionary
        let clientID = configs.value(forKey: "clientID") as! String
        let secretKey = configs.value(forKey: "secretKey") as! String
        let env = (configs.value(forKey: "env") as! String) == "live" ? EsewaSDKEnvironment.production : EsewaSDKEnvironment.development
        
        let payment = argsMap.value(forKey: "payment") as! NSDictionary
        let amount = String(payment.value(forKey: "amount") as! Int)
        let productName = payment.value(forKey: "productName") as! String
        let productID = payment.value(forKey: "productID") as! String
        let callBackURL = payment.value(forKey: "callBackURL") as! String
        
        sdk = EsewaSDK(inViewController: controller, environment: env, delegate: self)
        sdk?.initiatePayment(merchantId: clientID, merchantSecret: secretKey, productName: productName, productAmount: amount, productId: productID, callbackUrl: callBackURL)
    }
    
    public func onEsewaSDKPaymentSuccess(info: [String : Any]) {
        let response: NSDictionary = [
            "isSuccess": true,
            "message": info
        ]
        self.result?(response)
    }
       
    public func onEsewaSDKPaymentError(errorDescription: String) {
        let response: NSDictionary = [
            "isSuccess": false,
            "message": errorDescription
        ]
        self.result?(response)
    }
       
       
}
