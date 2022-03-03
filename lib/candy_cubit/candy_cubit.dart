import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:candy_sorter/locator/locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../models/candy.dart';
import '../services/ticker.dart';

part 'candy_state.dart';

class CandyCubit extends Cubit<CandyState> {
  CandyCubit() : super(const CandyState(duration: _duration));

  final List<Candy> _candies = [];
  final Random _random = locator.get<Random>();
  static const int _duration = 60;

  final Ticker _ticker = const Ticker();
  StreamSubscription<int>? _streamSubscription;

  int get numberOfCandies => _numberOfCandies;
  List<Color> get gameColors => _gameColors;

  int _numberOfCandies = 10;
  final List<Color> _gameColors = [
    Colors.red,
    Colors.green,
    Colors.blueGrey,
    Colors.cyan,
    Colors.orange,
  ];

  set updateNumberOfCandies(int numberOfCandies) {
    _numberOfCandies = numberOfCandies;
  }

  void fillCandies({required Size gameArea}) {
    _candies.clear();
    _numberOfCandies = 10;
    for (int i = 0; i < _numberOfCandies; i++) {
      int nextIndex = _random.nextInt(_gameColors.length);
      _candies.add(
        Candy(
          color: _gameColors[nextIndex],
          top: _random.nextInt(gameArea.height.toInt() - 120).toDouble(),
          left: _random.nextInt(gameArea.width.toInt() - 100).toDouble(),
        ),
      );
    }
    emit(
      state.copyWith(
        candies: _candies,
        candiesLeft: _candies.length,
        candiesSorted: _numberOfCandies - _candies.length,
      ),
    );
    _startTimer(duration: _duration);
  }

  void _startTimer({required int duration}) {
    _streamSubscription?.cancel();
    _streamSubscription = _ticker.tick(ticks: duration).listen(
          (duration) => emit(
            state.copyWith(duration: duration),
          ),
        );
  }

  void onWrongChoice({required Size gameArea}) {
    _numberOfCandies += 2;
    for (int i = 0; i < 2; i++) {
      int nextIndex = _random.nextInt(_gameColors.length);
      _candies.add(
        Candy(
          color: _gameColors[nextIndex],
          top: _random.nextInt(gameArea.height.toInt() - 120).toDouble(),
          left: _random.nextInt(gameArea.width.toInt() - 100).toDouble(),
        ),
      );
    }
    emit(
      state.copyWith(
        candies: _candies,
        candiesLeft: _candies.length,
        candiesSorted: _numberOfCandies - _candies.length,
      ),
    );
  }

  void removeCandy(Candy candy) {
    _candies.remove(candy);
    emit(
      state.copyWith(
        candies: _candies,
        candiesLeft: _candies.length,
        candiesSorted: _numberOfCandies - _candies.length,
      ),
    );
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
