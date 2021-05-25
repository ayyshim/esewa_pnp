/*
 * Filename : esewa.dart
 * Author : Ashim Upadhaya
 */

/// [ESewaConfiguration] class holds the config value of merchant id and environment.
class ESewaConfiguration {
  static const ENVIRONMENT_TEST = "test";
  static const ENVIRONMENT_LIVE = "live";

  // arguments
  String? _clientID;
  String? _secretKey;
  String? _env;

  /// [ESewaConfiguration] constructor takes 3 requireds arguments
  ///
  /// **clientID**  :  Client ID of the client/merchant
  ///
  /// **secretKey** : Secret key of the client/merchant
  ///
  /// **environment** : Environment integrating for i.e. LIVE (prod) or DEVELOPMENT (test).
  // Constructor
  ESewaConfiguration(
      {required String clientID,
      required String secretKey,
      required String environment}) {
    if (environment == ENVIRONMENT_LIVE || environment == ENVIRONMENT_TEST) {
      this._clientID = clientID;
      this._secretKey = secretKey;
      this._env = environment;
    } else {
      throw Exception('''
        Environment of EsewaConfiguration must set to value either ENVIRONMENT_TEST or ENVIRONMENT_LIVE
      ''');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "clientID": this._clientID,
      "secretKey": this._secretKey,
      "env": this._env
    };
  }
}

/// [ESewaPayment] Create the payment information with payloads passed in it
class ESewaPayment {
  // arguments
  double? _productPrice;
  String? _productName;
  String? _productID;
  String? _callBackURL;

  /// [ESewaPayment] constructor takes 4 required arguments in order to complete payment process.
  ///
  /// **amount** : Price of Product or Service
  ///
  /// **productName** : Name of Product or Service
  ///
  /// **productID** : Set a unique Id for your particular product or services
  ///
  /// **callBackURL** : API exposed at merchant/client`server where eSewa sends a copy of proof of payment after successful payment
  // constructor
  ESewaPayment(
      {required double amount,
      required String productName,
      required String productID,
      required String callBackURL}) {
    if (amount <= 0) {
      throw new Exception("Paying amount can not be negative figure or zero.");
    }

    this._productPrice = amount;
    this._productID = productID;
    this._productName = productName;
    this._callBackURL = callBackURL;
  }

  Map<String, dynamic> toMap() {
    return {
      "amount": _productPrice,
      "productName": _productName,
      "productID": _productID,
      "callBackURL": _callBackURL
    };
  }
}
