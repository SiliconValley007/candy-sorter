import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../candy_cubit/candy_cubit.dart';
import '../constants/constants.dart';

Future<bool?> showPauseGameDialog(
    {required BuildContext context, required CandyCubit candyCubit}) {
  return showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 500),
    /// custom transition builder to customize the push and pop animation of the dialog
    transitionBuilder: (context, animation1, animation2, child) {
      final curvedValue =
          Curves.easeInOutBack.transform(animation1.value) - 1.0;
      return Transform(
        transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
        child: child,
      );
    },
    /// widget will blur the background
    pageBuilder: (context, animation1, animation2) => BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 3,
        sigmaY: 3,
      ),
      child: Dialog(
        backgroundColor: Colors.pinkAccent.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(
            color: Colors.pinkAccent,
            width: 3,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Text(
                    'Game Paused',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, settingsScreen)
                          .then((value) {
                            /// true will be returned from the settingsScreen when user has changed the game properties
                        if (value == true) {
                          candyCubit.fillCandies(
                            gameArea: Size(
                              MediaQuery.of(context).size.width,
                              MediaQuery.of(context).size.height / 2,
                            ),
                          );
                          /// close the dialog
                          Navigator.pop(context, true);
                        }
                      });
                    },
                    icon: const Icon(Icons.settings),
                    color: Colors.white,
                  ),
                ],
              ),
              Lottie.asset(gamePausedAnimation),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      /// resume the game timer and close the dialog
                      candyCubit.resumeTimer();
                      Navigator.pop(context, true);
                    },
                    child: const Text('Resume Game'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      /// create a new game and close the dialog
                      candyCubit.fillCandies(
                        gameArea: Size(
                          MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height / 2,
                        ),
                      );
                      Navigator.pop(context, true);
                    },
                    child: const Text('New Game'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
