import 'dart:developer';
import 'dart:ui';

import 'package:candy_sorter/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:nil/nil.dart';

import '../candy_cubit/candy_cubit.dart';
import '../widgets/game_lost_overlay.dart';
import '../widgets/widgets.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const GameScreen());

  void newGame(CandyCubit candyCubit, BuildContext context) {
    candyCubit.fillCandies(
      gameArea: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 2),
    );
  }

  Future<bool?> showPauseGameDialog(
      {required BuildContext context, required CandyCubit candyCubit}) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 500),
      transitionBuilder: (context, animation1, animation2, child) {
        final curvedValue =
            Curves.easeInOutBack.transform(animation1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: child,
        );
      },
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
                          if (value == true) {
                            candyCubit.fillCandies(
                              gameArea: Size(
                                MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height / 2,
                              ),
                            );
                            Navigator.pop(context, true);
                          }
                        });
                      },
                      icon: const Icon(Icons.settings),
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
                        candyCubit.resumeTimer();
                        Navigator.pop(context, true);
                      },
                      child: const Text('Resume Game'),
                    ),
                    ElevatedButton(
                      onPressed: () {
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

  @override
  Widget build(BuildContext context) {
    final CandyCubit candyCubit = context.read<CandyCubit>();
    return BlocBuilder<CandyCubit, CandyState>(
      buildWhen: (previous, current) =>
          (previous.isGameLost != current.isGameLost) ||
          (previous.isGameWon != current.isGameWon) ||
          (previous.isPaused != current.isPaused),
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Colors.black,
                elevation: 0.0,
                centerTitle: true,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<CandyCubit, CandyState>(
                    buildWhen: (previous, current) =>
                        previous.duration != current.duration,
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Text(
                          '${state.duration}',
                          key: ValueKey<int>(state.duration),
                          style: TextStyle(
                            color:
                                state.duration > 10 ? Colors.green : Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leading: BlocBuilder<CandyCubit, CandyState>(
                  buildWhen: (previous, current) =>
                      previous.candiesLeft != current.candiesLeft,
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Left\n${state.candiesLeft}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
                actions: [
                  BlocBuilder<CandyCubit, CandyState>(
                    buildWhen: (previous, current) =>
                        previous.candiesSorted != current.candiesSorted,
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Sorted\n${state.candiesSorted}',
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: const CandyArea(),
                    ),
                    const Expanded(
                      child: BowlArea(),
                    ),
                  ],
                ),
              ),
              floatingActionButton: state.isPaused
                  ? nil
                  : FloatingActionButton(
                      mini: true,
                      onPressed: () {
                        if (!state.isPaused) {
                          candyCubit.pauseTimer();
                        }
                        showPauseGameDialog(
                          context: context,
                          candyCubit: candyCubit,
                        ).then(
                          (value) {
                            if (value == null) {
                              candyCubit.resumeTimer();
                            }
                          },
                        );
                        /*if (state.isPaused) {
                    candyCubit.resumeTimer();
                  } else {
                    candyCubit.pauseTimer();
                  }*/
                      },
                      child: const Icon(
                        Icons.pause,
                      ),
                    ),
            ),
            if (state.isGameWon)
              GameWonOverlay(
                onButtonPressed: () => newGame(candyCubit, context),
              ),
            if (state.isGameLost)
              GameLostOverlay(
                onButtonPressed: () => newGame(candyCubit, context),
              ),
          ],
        );
      },
    );
  }
}
