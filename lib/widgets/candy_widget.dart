import 'package:candy_sorter/constants/constants.dart';
import 'package:flutter/material.dart';

import '../models/candy.dart';
import 'widgets.dart';

class CandyWidget extends StatelessWidget {
  const CandyWidget({
    Key? key,
    required this.candy,
    this.width = 30,
  }) : super(key: key);

  final Candy candy;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ColoredSvg(
      path: candySvg,
      color: candy.color,
      width: width,
    );
  }
}
