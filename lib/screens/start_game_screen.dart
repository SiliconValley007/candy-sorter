import 'dart:math';

import 'package:candy_sorter/locator/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../candy_cubit/candy_cubit.dart';
import '../constants/constants.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class StartGameScreen extends HookWidget {
  const StartGameScreen({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const StartGameScreen());

  @override
  Widget build(BuildContext context) {
    final Random _random = locator.get<Random>();
    final _animationController =
        useAnimationController(duration: const Duration(milliseconds: 500))
          ..repeat(reverse: true);
    final Animation<Offset> _animation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.05, 0.08))
            .animate(_animationController);
    final CandyCubit candyCubit = context.read<CandyCubit>();
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: _size.height,
            width: _size.width,
            child: Stack(
              children: [
                for (int i = 0; i < 100; i++)
                  //int nextIndex = _random.nextInt(_gameColors.length);
                  Positioned(
                    top: _random.nextInt(_size.height.toInt()).toDouble(),
                    left: _random.nextInt(_size.width.toInt()).toDouble(),
                    child: SlideTransition(
                      position: _animation,
                      child: CandyWidget(
                        candy: Candy(
                            color: candyCubit.gameColors[
                                _random.nextInt(candyCubit.gameColors.length)]),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                candyCubit.fillCandies(
                  gameArea: Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height / 2,
                  ),
                );
                Navigator.of(context).pushReplacementNamed(
                  gameScreen,
                );
              },
              child: const Text('Start Game'),
            ),
          ),
        ],
      ),
    );
  }
}
