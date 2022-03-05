import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../locator/locator.dart';
import '../models/candy.dart';
import '../services/services.dart';

part 'candy_state.dart';

class CandyCubit extends Cubit<CandyState> {
  /// we pass the initial state to the super constructor
  CandyCubit() : super(const CandyState()) {
    /// this function will be called when CandyCubit is initialized for the first time, loading the user preferences from local storage
    setupUserPreferences();
  }

  /// list of candies, that will be emitted to fill the candyArea in the ui
  final List<Candy> _candies = [];

  /// this is where we use our service locator to get the single instance of Random class
  final Random _random = locator.get<Random>();

  /// similarly, we use our service locator to get the single instance of GameService
  final GameService _gameService = locator.get<GameService>();

  /// accessing the single instance of the Ticker class from the get_it service locator
  final Ticker _ticker = locator.get<Ticker>();

  /// nullable stream subscription to subscribe to the Ticker stream and emit a new state when a new value is returned by the stream
  StreamSubscription<int>? _streamSubscription;

  /// getters to access the private variables that i want exposed
  int get defaultNumberOfCandies => _defaultNumberOfCandies;
  int get numberOfCandies => _numberOfCandies;
  List<Color> get gameColors => _gameColors;

  /// variable to keep track of the number of times a new game is created
  int _fillCandiesCalled = 0;

  /// variable to store the number of candies selected by the user, and which were stored in local storage.
  int _defaultNumberOfCandies = 10;

  /// variable that will have a variable length, which will increase when the user makes a wrong choice
  int _numberOfCandies = 10;

  /// variable to store the game colors, retrieved from local storage
  List<Color> _gameColors = [];

  /// set the number of candies and game colors selected by the user, retrieved from the local storage
  void setupUserPreferences() async {
    _defaultNumberOfCandies = await _gameService.getNumberOfCandies();
    _gameColors = await _gameService.getListOfColors();
  }

  /// setter to update the number of candies with the value selected by the user, is called from the settings screen when the user presses the save button.
  set updateNumberOfCandies(int numberOfCandies) {
    /// setting the local value to the new number of candies
    _defaultNumberOfCandies = numberOfCandies;
    /// storing the selected number of candies to local storage using shared preferences, so that the choice is persisted
    _gameService.saveNumberOfCandies(numberOfCandies: numberOfCandies);
  }

  /// setter to update the game colors with the colors selected by the user, is called from the settings screen when the user presses the save button.
  set updateGameColors(List<Color> colors) {
    /// setting the local list to the new list of colors
    _gameColors = colors;
    /// storing the selected colors to local storage using shared preferences, so that the changes are persisted across app restarts
    _gameService.saveListOfColors(colors: colors);
  }

  /// this method is called whenever a new game is required
  /// the gameArea size is required so that all the candies generated here are within that area
  void fillCandies({required Size gameArea}) {
    /// clearing the old mutated list of candies
    _candies.clear();
    /// setting the mutated number of candies to the original number (chosen by the user)
    _numberOfCandies = _defaultNumberOfCandies;
    /// for loop to generate random candies(random colors, random position) and store them in the candy list
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
    /// emitting mutated state with new values to that the UI is built accordingly
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
    /// method to start the countdown timer as soon as a new game is started
    _startTimer(duration: _candies.length + 10);
  }

  /// method to subscribe to the Timer class stream and emit a new state with the new duration every second
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

  /// method to pause the timer and update the UI, showing the pause dialog
  void pauseTimer() {
    _streamSubscription?.pause();
    emit(state.copyWith(isPaused: true));
  }

  /// method to pause the timer and update the UI, removing the pause dialog
  void resumeTimer() {
    _streamSubscription?.resume();
    emit(state.copyWith(isPaused: false));
  }

  /// this method will be called when the user makes a wrong choice(i.e. puts the wrong colored candy in the wrong bowl), adding 2 new candies to the existing list of candies
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

  /// this method is called when the user puts the candy in the right colored bowl, increasing the sorted score.
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

  /// overriding the close method of cubit to dispose of the stream subscription
  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
