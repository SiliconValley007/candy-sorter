import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ColoredSvg extends StatelessWidget {
  const ColoredSvg({
    Key? key,
    required this.path,
    this.color = Colors.black,
    this.width,
    this.height,
  }) : super(key: key);

  final Color color;
  final String path;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context).loadString(path),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        final svg = snapshot.data!.replaceAll(
          'fill="#000000"',
          'fill="$_colorAsRgba"',
        );
        return SvgPicture.string(
          svg,
          width: width,
          height: height,
        );
      },
    );
  }

  String get _colorAsRgba {
    return 'rgba(${color.red}, ${color.green}, ${color.blue}, ${color.alpha / 255})';
  }
}
