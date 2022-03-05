import 'package:candy_sorter/constants/constants.dart';

import 'widgets.dart';
import 'package:flutter/material.dart';

/// widget to display the bowl.svg with the corresponding color
class Bowl extends StatelessWidget {
  const Bowl({
    Key? key,
    this.color = Colors.black,
    this.width = 130,
  }) : super(key: key);

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      /// custom widget which returns the svg provided with the provided color
      child: ColoredSvg(
        path: bowlSvg,
        color: color,
        width: width,
      ),
    );
  }
}
