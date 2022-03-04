import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../locator/locator.dart';
import '../models/candy.dart';
import '../services/services.dart';

part 'candy_state.dart';

class CandyCubit extends Cubit<CandyState> {
  CandyCubit() : super(const CandyState()) {
    setupUserPreferences();
  }

  final List<Candy> _candies = [];
  final Random _random = locator.get<Random>();

  final GameService _gameService = locator.get<GameService>();

  final Ticker _ticker = locator.get<Ticker>();
  StreamSubscription<int>? _streamSubscription;

  int get numberOfCandies => _numberOfCandies;
  List<Color> get gameColors => _gameColors;

  int _fillCandiesCalled = 0;

  int _defaultNumberOfCandies = 10;

  int _numberOfCandies = 10;
  List<Color> _gameColors = [
    Colors.red,
    Colors.green,
    Colors.blueGrey,
    Colors.cyan,
    Colors.orange,
  ];

  void setupUserPreferences() async {
    _defaultNumberOfCandies = await _gameService.getNumberOfCandies();
    _gameColors = await _gameService.getListOfColors();
  }

  set updateNumberOfCandies(int numberOfCandies) {
    _defaultNumberOfCandies = numberOfCandies;
    _gameService.saveNumberOfCandies(numberOfCandies: numberOfCandies);
  }

  set updateGameColors(List<Color> colors) {
    _gameColors = colors;
    _gameService.saveListOfColors(colors: colors);
  }

  void fillCandies({required Size gameArea}) {
    _candies.clear();
    _numberOfCandies = _defaultNumberOfCandies;
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
        fillCandiesCalled: _fillCandiesCalled += 1,
        candiesSorted: _numberOfCandies - _candies.length,
        isPaused: false,
        isGameLost: false,
        isGameWon: false,
        duration: _candies.length + 10,
      ),
    );
    _startTimer(duration: _candies.length + 10);
  }

  void _startTimer({required int duration}) {
    _streamSubscription?.cancel();
    _streamSubscription = _ticker.tick(ticks: duration).listen(
          (duration) => emit(
            state.copyWith(
                duration: duration,
                isGameLost: duration == 0 && _candies.isNotEmpty),
          ),
        );
  }

  void pauseTimer() {
    _streamSubscription?.pause();
    emit(state.copyWith(isPaused: true));
  }

  void resumeTimer() {
    _streamSubscription?.resume();
    emit(state.copyWith(isPaused: false));
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
        isGameWon: _candies.isEmpty,
      ),
    );
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
