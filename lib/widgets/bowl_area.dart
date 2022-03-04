import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../candy_cubit/candy_cubit.dart';
import '../models/candy.dart';
import 'bowl.dart';
import 'snack_bar.dart';

class BowlArea extends StatelessWidget {
  const BowlArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CandyCubit candyCubit = context.read<CandyCubit>();
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
              DragTarget<Candy>(
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
          ],
        );
      },
    );
  }
}
