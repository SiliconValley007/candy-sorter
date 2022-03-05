import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// custom model class to hold our individual candy data. The equatable package is used here to override hashcode so that dart checks if two Candy objects are equal based on the values it is carrying.
class Candy extends Equatable {
  const Candy({
    required this.color,
    this.top = 0,
    this.left = 0,
  });

  final Color color;
  final double top;
  final double left;

  /// the values we pass here are the ones that will be used when checking for equality
  @override
  List<Object?> get props => [color, top, left];
}
