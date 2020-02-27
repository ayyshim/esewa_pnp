/*
 * Filename : result.dart
 * Author : Ashim Upadhaya
 */

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// [Result] holds the success response once the payment
/// is completeted successfully.
class Result extends Equatable {
  final String productId;
  final String productName;
  final String totalAmount;
  final String message;
  final String date;
  final String status;
  final String referenceId;

  Result._({
    @required this.productId,
    @required this.productName,
    @required this.totalAmount,
    @required this.message,
    @required this.date,
    @required this.status,
    @required this.referenceId,
  });

  factory Result.fromMap(Map<String, dynamic> response) {
    return Result._(
      productId: response["productId"],
      productName: response["productName"],
      totalAmount: response["totalAmount"],
      message: response["message"]["successMessage"],
      date: response["transactionDetails"]["date"],
      status: response["transactionDetails"]["status"],
      referenceId: response["transactionDetails"]["referenceId"],
    );
  }

  @override
  List<Object> get props =>
      [productId, productName, totalAmount, message, date, status, referenceId];
}
