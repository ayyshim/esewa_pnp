/*
 * Filename : esewa_pnp.dart
 * Author : Ashim Upadhaya
 */
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:esewa_pnp/esewa.dart';
import 'package:esewa_pnp/failure.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import './result.dart';

class ESewaPnp {
  static const MethodChannel _channel = const MethodChannel('esewa_pnp');

  ESewaConfiguration _eSewaConfiguration;

  /// [ESewaPnp] constructor takes [ESewaConfiguration] as argument.
  ESewaPnp({@required ESewaConfiguration configuration}) {
    _eSewaConfiguration = configuration;
  }

  /// This method will take user to the eSewa payment activity and returns [Either<Failure, Result>] once user is back to
  /// app.
  ///
  /// It takes [ESewaPayment] as argument.
  Future<Either<Failure, Result>> initPayment(
      {@required ESewaPayment payment}) async {
    Map<String, dynamic> arguments = {
      "config": _eSewaConfiguration.toMap(),
      "payment": payment.toMap()
    };

    final response = await _channel.invokeMethod('initPayment', arguments);
    Map<String, dynamic> responseMap = Map<String, dynamic>.from(response);
    if (!responseMap["isSuccess"]) {
      return Left(Failure(message: responseMap["message"]));
    } else {
      return Right(Result.fromMap(json.decode(responseMap["message"])));
    }
  }
}
