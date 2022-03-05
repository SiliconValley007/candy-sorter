import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nil/nil.dart';

import '../candy_cubit/candy_cubit.dart';
import '../models/candy.dart';
import 'candy_widget.dart';

/// area where the Draggable candies are displayed
class CandyArea extends StatelessWidget {
  const CandyArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// not especially needed here
    return LayoutBuilder(
      /// will be rebuilt when the candies list inside CandyCubit is changed
      builder: (context, constraints) => BlocBuilder<CandyCubit, CandyState>(
        buildWhen: (previous, current) =>
            previous.candiesLeft != current.candiesLeft ||
            previous.candiesSorted != current.candiesSorted ||
            previous.candies.length != current.candies.length ||
            previous.fillCandiesCalled != current.fillCandiesCalled,
        builder: (context, state) {
          /// stack to display the different candies in random locations
          return Stack(
            children: [
              for (Candy candy in state.candies)
                Positioned(
                  top: candy.top,
                  left: candy.left,
                  /// Draggable widget is recognized by DragTarget, and the data it carries(in this case the candy data), is used by the DragTarget
                  child: Draggable<Candy>(
                    data: candy,
                    /// display nothing when candy is accepted by the DragTarget
                    child: state.candies.contains(candy)
                        ? CandyWidget(
                            candy: candy,
                          )
                        : nil,
                    feedback: CandyWidget(candy: candy),
                    childWhenDragging: const SizedBox.shrink(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
