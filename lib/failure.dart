/*
 * Filename : failure.dart
 * Author : Ashim Upadhaya
 */

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// [Failure] is returned when some error occurs during payment process.
class Failure extends Equatable {
  final String message;

  Failure({@required this.message});

  @override
  List<Object> get props => [message];
}
