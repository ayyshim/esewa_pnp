/*
 * Filename : esewa.dart
 * Author : Ashim Upadhaya
 */

// import 'package:flutter/foundation.dart';

/// [ESewaConfiguration] class holds the config value of merchant id and environment.
class ESewaConfiguration {
  static const ENVIRONMENT_TEST = "test";
  static const ENVIRONMENT_LIVE = "live";

  // arguments
  final String clientID;
  final String secretKey;
  final String environment;

  /// [ESewaConfiguration] constructor takes 3 requireds arguments
  ///
  /// **clientID**  :  Client ID of the client/merchant
  ///
  /// **secretKey** : Secret key of the client/merchant
  ///
  /// **environment** : Environment integrating for i.e. LIVE (prod) or DEVELOPMENT (test).
  // Constructor
  ESewaConfiguration({
    required this.clientID,
    required this.secretKey,
    required this.environment,
  }) : assert(
            environment == ENVIRONMENT_LIVE || environment == ENVIRONMENT_TEST);

  Map<String, dynamic> toMap() {
    return {
      "clientID": clientID,
      "secretKey": secretKey,
      "env": environment,
    };
  }
}

/// [ESewaPayment] Create the payment information with payloads passed in it
class ESewaPayment {
  // arguments
  double productPrice;
  String productName;
  String productID;
  String callBackURL;

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
  ESewaPayment({
    required this.productPrice,
    required this.productName,
    required this.productID,
    required this.callBackURL,
  }) : assert(productPrice > 10);

  Map<String, dynamic> toMap() {
    return {
      "amount": productPrice,
      "productName": productName,
      "productID": productID,
      "callBackURL": callBackURL
    };
  }
}
