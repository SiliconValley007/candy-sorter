import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../candy_cubit/candy_cubit.dart';
import '../models/candy.dart';
import 'bowl.dart';
import 'snack_bar.dart';

class BowlArea extends HookWidget {
  const BowlArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CandyCubit candyCubit = context.read<CandyCubit>();
    final AnimationController controller =
        useAnimationController(duration: const Duration(milliseconds: 500));
    final Animation<double> offsetAnimation =
        Tween<double>(begin: 0.0, end: 24.0)
            .chain(CurveTween(curve: Curves.elasticIn))
            .animate(controller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            }
          });
    return BlocBuilder<CandyCubit, CandyState>(
      buildWhen: (previous, current) =>
          previous.fillCandiesCalled != current.fillCandiesCalled,
      builder: (context, state) {
        final List<Color> _shuffledColors = candyCubit.gameColors;
        _shuffledColors.shuffle();
        return Wrap(
          alignment: WrapAlignment.spaceEvenly,
          runAlignment: WrapAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < _shuffledColors.length; i++)
              AnimatedBuilder(
                  animation: offsetAnimation,
                  builder: (context, snapshot) {
                    return Transform.translate(
                      offset: Offset(offsetAnimation.value, 0),
                      child: DragTarget<Candy>(
                        builder: (context, candidateData, rejectedData) => Bowl(
                          color: _shuffledColors[i],
                        ),
                        onWillAccept: (candy) {
                          //return candy?.color == candyCubit.gameColors[i];
                          return candy != null;
                        },
                        onAccept: (candy) {
                          if (candy.color == _shuffledColors[i]) {
                            candyCubit.removeCandy(candy);
                          } else {
                            controller.forward(from: 0.0);
                            showSnackBar(
                              context,
                              text: '!!! Wrong bowl !!!',
                            );
                            candyCubit.onWrongChoice(
                              gameArea: Size(
                                MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height / 2,
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }),
          ],
        );
      },
    );
  }
}
