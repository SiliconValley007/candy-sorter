import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../candy_cubit/candy_cubit.dart';
import '../constants/constants.dart';
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
          current.candiesLeft == 0 || current.candiesSorted == 0,
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0.0,
                centerTitle: true,
                title: ElevatedButton(
                  onPressed: () => newGame(candyCubit, context),
                  child: const Text('New Game'),
                ),
                actions: [
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, settings),
                    icon: const Icon(Icons.settings),
                    color: Colors.black,
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    BlocBuilder<CandyCubit, CandyState>(
                      buildWhen: (previous, current) =>
                          previous.candiesLeft != current.candiesLeft ||
                          previous.candiesSorted != current.candiesSorted,
                      builder: (context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Candies left: ${state.candiesLeft}',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Candies sorted: ${state.candiesSorted}',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: const CandyArea(),
                    ),
                    const Expanded(
                      child: BowlArea(),
                    ),
                  ],
                ),
              ),
            ),
            if (state.candiesLeft == 0)
              GameWonOverlay(
                onButtonPressed: () => newGame(candyCubit, context),
              ),
          ],
        );
      },
    );
  }
}