import 'dart:ui';

import 'package:candy_sorter/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GameLostOverlay extends StatelessWidget {
  const GameLostOverlay({Key? key, required this.onButtonPressed})
      : super(key: key);

  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Container(
      height: _size.height,
      width: _size.width,
      color: Colors.black.withOpacity(0.8),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 3,
          sigmaY: 3,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              gameOverAnimation,
            ),
            ElevatedButton(
              onPressed: onButtonPressed,
              child: const Text('New Game'),
            ),
          ],
        ),
      ),
    );
  }
}
