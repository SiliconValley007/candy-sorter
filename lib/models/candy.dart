import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Candy extends Equatable {
  const Candy({
    required this.color,
    this.top = 0,
    this.left = 0,
  });

  final Color color;
  final double top;
  final double left;

  @override
  List<Object?> get props => [color, top, left];
}
