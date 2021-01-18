/*
 * Filename : esewa_pnp.dart
 * Author : Ashim Upadhaya
 */
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'esewa.dart';
import 'dart:io' show Platform;

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
      productId: response["productID"] ?? response["productId"],
      productName: response["productName"],
      totalAmount: response["totalAmount"],
      message: response["message"]["successMessage"],
      date: response["transactionDetails"]["date"],
      status: response["transactionDetails"]["status"],
      referenceId: response["transactionDetails"]["referenceId"],
    );
  }

  @override
  String toString() => '''
    ESewaResult {
      productId: $productId,
      productName: $productName,
      totalAmount: $totalAmount,
      message: $message,
      date: $date,
      status: $status,
      referenceId: $referenceId,
    }
  ''';
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
      if (Platform.isAndroid) {
        return ESewaResult.fromMap(json.decode(responseMap["message"]));
      } else {
        Map<String, dynamic> resp =
            Map<String, dynamic>.from(responseMap["message"]);
        return ESewaResult.fromMap(resp);
      }
    }
  }
}

/// **[ESewaPaymentButton]** is a customizable eSewa payment button.
// ignore: must_be_immutable
class ESewaPaymentButton extends StatelessWidget {
  /// Pass the object of **[ESewaPnp]**.
  final ESewaPnp esewa;

  /// Payable amount in **[int]**.
  final int amount;

  /// Product ID
  final String productId;

  /// Product Name
  final String productName;

  /// Callback URL
  final String callBackURL;

  /// This method will trigger if the payment is successfull.
  final Function(ESewaResult result) onSuccess;

  /// This method will trigger if the payment is not successfull.
  final Function(ESewaPaymentException exception) onFailure;

  /// Customize button label if you don't want default label to be shown.
  /// You will get amount and esewaLogo widget.
  final Widget Function(int amount, Widget esewaLogo) labelBuilder;

  final double elevation;
  final double focusElevation;
  final double highlightElevation;
  final double hoverElevation;
  final double height;
  final double width;
  final Color color;

  Widget _esewaLogo;
  Color _textColor;
  Widget _label;

  ESewaPaymentButton(
    this.esewa, {
    Key key,
    @required this.amount,
    @required this.productId,
    @required this.productName,
    @required this.callBackURL,
    @required this.onSuccess,
    @required this.onFailure,
    this.labelBuilder,
    this.elevation = 4,
    this.height,
    this.width,
    this.color,
    this.focusElevation,
    this.highlightElevation,
    this.hoverElevation,
  }) {
    this._esewaLogo = color != null
        ? (color.computeLuminance() > 0.5
            ? Image.asset(
                "assets/esewa/logo_dark.png",
                height: 24,
                width: 54,
              )
            : Image.asset(
                "assets/esewa/logo.png",
                height: 24,
                width: 54,
              ))
        : Image.asset(
            "assets/esewa/logo.png",
            height: 24,
            width: 54,
          );

    this._textColor = color != null
        ? (color.computeLuminance() < 0.5
            ? Color(0xFFFFFFFF)
            : Color(0xFF000000))
        : Color(0xFFFFFFFF);

    this._label = this.labelBuilder != null
        ? this.labelBuilder(
            this.amount,
            _esewaLogo,
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Pay now with ",
              ),
              _esewaLogo,
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      child: RaisedButton(
        focusElevation: this.focusElevation,
        highlightElevation: this.highlightElevation,
        hoverElevation: this.hoverElevation,
        elevation: this.elevation,
        onPressed: () async {
          ESewaPayment _payment = ESewaPayment(
            amount: this.amount,
            productName: this.productName,
            productID: this.productId,
            callBackURL: this.callBackURL,
          );

          try {
            final _res = await this.esewa.initPayment(payment: _payment);
            this.onSuccess(_res);
          } on ESewaPaymentException catch (ex) {
            this.onFailure(ex);
          }
        },
        child: this._label,
        textColor: _textColor,
        color: color ?? Color(0xFF000000),
      ),
    );
  }
}
