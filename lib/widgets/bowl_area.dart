import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../candy_cubit/candy_cubit.dart';
import '../models/candy.dart';
import 'bowl.dart';
import 'snack_bar.dart';

/// widget where the 5 bowls are displayed. Using a hook widget to reduce boilerplate
class BowlArea extends HookWidget {
  const BowlArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CandyCubit candyCubit = context.read<CandyCubit>();

    /// animation controller that will be used to vibrate the bowls when the user makes a wrong choice
    final AnimationController controller =
        useAnimationController(duration: const Duration(milliseconds: 500));

    /// animation tween to determine how and how much the bowls will vibrate
    final Animation<double> offsetAnimation =
        Tween<double>(begin: 0.0, end: 24.0)
            .chain(CurveTween(curve: Curves.elasticIn))
            .animate(controller)
          ..addStatusListener((status) {
            /// so that the bowls come back their original position, from where they started vibrating
            if (status == AnimationStatus.completed) {
              controller.reverse();
            }
          });

    /// will be rebuilt when a new game is created
    return BlocBuilder<CandyCubit, CandyState>(
      buildWhen: (previous, current) =>
          previous.fillCandiesCalled != current.fillCandiesCalled,
      builder: (context, state) {
        /// duplicating the original game colors list, so that the original list is not modified
        final List<Color> _shuffledColors = candyCubit.gameColors;

        /// shuffle the colors of the bowl when a new game is created ( we shuffle the copied list )
        _shuffledColors.shuffle();
        return Wrap(
          alignment: WrapAlignment.spaceEvenly,
          runAlignment: WrapAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < _shuffledColors.length; i++)

              /// rebuilds the ui when an animation happens, so that we don't have to call setState
              AnimatedBuilder(
                animation: offsetAnimation,
                builder: (context, snapshot) {
                  /// we use this widget to move the bowls horizontally, creating a vibrating animation
                  return Transform.translate(
                    offset: Offset(offsetAnimation.value, 0),

                    /// DragTarget is used so that we can detect when a Draggable widget is hovering over it, or a Draggable widget is dropped into it. Will only accept a Draggable of the type "Candy"
                    child: DragTarget<Candy>(
                      builder: (context, candidateData, rejectedData) => Bowl(
                        color: _shuffledColors[i],
                      ),

                      /// will only accept the Draggable widget if it contains data
                      onWillAccept: (candy) {
                        //return candy?.color == candyCubit.gameColors[i];
                        return candy != null;
                      },

                      /// method is triggered when the DragTarget accepts a draggable, passing us the data carried by the Draggable.
                      onAccept: (candy) {
                        /// if check to see if the user dragged candy, dropped into the container is correct ot not(if the candy color and the bowl color is same, it is correct, otherwise incorrect)
                        if (candy.color == _shuffledColors[i]) {
                          /// correct
                          candyCubit.removeCandy(candy);
                        } else {
                          /// incorrect
                          /// initiate the vibrating animation
                          controller.forward(from: 0.0);

                          /// show snackbar when wrong choice is selected
                          showSnackBar(
                            context,
                            text: '!!! Wrong bowl !!!',
                          );

                          /// increasing the candy count by 2
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
                },
              ),
          ],
        );
      },
    );
  }
}
