import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nil/nil.dart';

import '../candy_cubit/candy_cubit.dart';
import '../widgets/widgets.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  /// used by the app router
  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const GameScreen());

  void newGame(CandyCubit candyCubit, BuildContext context) {
    candyCubit.fillCandies(
      gameArea: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// accessing the CandyCubit from the context (provided to us by the BlocProvider)
    final CandyCubit candyCubit = context.read<CandyCubit>();
    return BlocBuilder<CandyCubit, CandyState>(
      /// this BlocBuilder will only rebuild if any of the following conditions is true (given to limit unnecessary rebuilds)
      buildWhen: (previous, current) =>
          (previous.isGameLost != current.isGameLost) ||
          (previous.isGameWon != current.isGameWon) ||
          (previous.isPaused != current.isPaused),
      builder: (context, state) {
        /// stack used to show game won or game lost overlay on top of game screen
        return Stack(
          children: [
            /// game screen
            Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    /// top row to display number of candies left, number of candies sorted and the time remaining
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// will be rebuilt when the number of candies left changes
                          BlocBuilder<CandyCubit, CandyState>(
                            buildWhen: (previous, current) =>
                                previous.candiesLeft != current.candiesLeft,
                            builder: (context, state) {
                              return Text(
                                'Left\n${state.candiesLeft}',
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                          /// will rebuild the widget each second to show the seconds remaining
                          BlocBuilder<CandyCubit, CandyState>(
                            buildWhen: (previous, current) =>
                                previous.duration != current.duration,
                            builder: (context, state) {
                              /// to smoothly animate the change between the previous number and the current number
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                /// override the default fade transition of animated switcher with scale transition
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
                                    color: state.duration > 10
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              );
                            },
                          ),
                          /// will be rebuilt when the number of candies sorted changes
                          BlocBuilder<CandyCubit, CandyState>(
                            buildWhen: (previous, current) =>
                                previous.candiesSorted != current.candiesSorted,
                            builder: (context, state) {
                              return Text(
                                'Sorted\n${state.candiesSorted}',
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    /// the part of the screen where the candies are displayed
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: const CandyArea(),
                    ),
                    /// the part of the screen where the bowls are displayed
                    const Expanded(
                      child: BowlArea(),
                    ),
                  ],
                ),
              ),
              /// will only be displayed when the game is not paused
              floatingActionButton: state.isPaused
                  ? nil
                  : FloatingActionButton(
                      mini: true,
                      onPressed: () {
                        if (!state.isPaused) {
                          candyCubit.pauseTimer();
                        }
                        /// the pink dialog displayed on game pause
                        showPauseGameDialog(
                          context: context,
                          candyCubit: candyCubit,
                        ).then( /// will be executed when the dialog is closed
                          (value) {
                            if (value == null) {
                              candyCubit.resumeTimer();
                            }
                          },
                        );
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
