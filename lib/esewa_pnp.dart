/*
 * Filename : esewa_pnp.dart
 * Author : Ashim Upadhaya
 */
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:esewa_pnp/esewa.dart';
import 'package:flutter/services.dart';

/// **[EsewaPaymentException]** will be thrown if any kind of error/exception is caught
/// on native side.
///
/// Read the official doc to understand the nature and cause of possible exceptions.
///
/// https://developer.esewa.com.np/#/ios?id=error-cases-and-handling
///
/// https://developer.esewa.com.np/#/android?id=error-cases-and-handling
class ESewaPaymentException implements Exception {
  final String message;

  ESewaPaymentException({@required this.message});
}

/// **[ESewaResult]** holds the success response once the payment
/// is completeted successfully.
class ESewaResult {
  final String productId;
  final String productName;
  final String totalAmount;
  final String message;
  final String date;
  final String status;
  final String referenceId;

  ESewaResult._({
    @required this.productId,
    @required this.productName,
    @required this.totalAmount,
    @required this.message,
    @required this.date,
    @required this.status,
    @required this.referenceId,
  });

  factory ESewaResult.fromMap(Map<String, dynamic> response) {
    return ESewaResult._(
      productId: response["productId"],
      productName: response["productName"],
      totalAmount: response["totalAmount"],
      message: response["message"]["successMessage"],
      date: response["transactionDetails"]["date"],
      status: response["transactionDetails"]["status"],
      referenceId: response["transactionDetails"]["referenceId"],
    );
  }
}

class ESewaPnp {
  static const MethodChannel _channel = const MethodChannel('esewa_pnp');

  ESewaConfiguration _eSewaConfiguration;

  /// [ESewaPnp] constructor takes [ESewaConfiguration] as argument.
  ESewaPnp({@required ESewaConfiguration configuration}) {
    _eSewaConfiguration = configuration;
  }

  /// This method will take user to the eSewa payment activity and returns [Future<ESewaResult>] once user is back to
  /// app.
  ///
  /// It takes [ESewaPayment] as argument.
  Future<ESewaResult> initPayment({@required ESewaPayment payment}) async {
    Map<String, dynamic> arguments = {
      "config": _eSewaConfiguration.toMap(),
      "payment": payment.toMap()
    };

    final response = await _channel.invokeMethod('initPayment', arguments);
    Map<String, dynamic> responseMap = Map<String, dynamic>.from(response);
    if (!responseMap["isSuccess"]) {
      throw ESewaPaymentException(message: responseMap["message"]);
    } else {
      return ESewaResult.fromMap(json.decode(responseMap["message"]));
    }
  }
}
