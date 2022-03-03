import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nil/nil.dart';

import '../candy_cubit/candy_cubit.dart';
import '../models/candy.dart';
import 'candy_widget.dart';

class CandyArea extends StatelessWidget {
  const CandyArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => BlocBuilder<CandyCubit, CandyState>(
        buildWhen: (previous, current) =>
            previous.candiesLeft != current.candiesLeft ||
            previous.candiesSorted != current.candiesSorted,
        builder: (context, state) {
          return Stack(
            children: [
              for (Candy candy in state.candies)
                Positioned(
                  top: candy.top,
                  left: candy.left,
                  child: Draggable<Candy>(
                    data: candy,
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
