import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nil/nil.dart';

import '../candy_cubit/candy_cubit.dart';
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
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                          BlocBuilder<CandyCubit, CandyState>(
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
                                    color: state.duration > 10
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              );
                            },
                          ),
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
