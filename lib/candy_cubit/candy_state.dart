part of 'candy_cubit.dart';

class CandyState extends Equatable {
  const CandyState({
    this.candiesLeft = 0,
    this.candiesSorted = 0,
    this.duration = 0,
    this.fillCandiesCalled = 0,
    this.isPaused = false,
    this.isGameLost = false,
    this.isGameWon = false,
    this.candies = const [],
  });

  /// variable to store the number of candies left
  final int candiesLeft;
  /// variable to store the number of candies sorted
  final int candiesSorted;
  /// variable to store the seconds left
  final int duration;
  /// variable to store the number of times a new game is started, so that i can rebuild specific parts of the ui
  final int fillCandiesCalled;
  /// variable to update the ui when the game is won
  final bool isGameWon;
  /// variable to update the ui when the timer reaches zero and the game is lost
  final bool isGameLost;
  /// variable to update the ui when timer is paused
  final bool isPaused;
  /// list to store the candies to be displayed when the game is running
  final List<Candy> candies;

  /// the values that are supplied here are the one that will be used when dart checks for equality (bloc only rebuilds the ui if the previous state and the current state is different)
  @override
  List<Object> get props => [
        candies,
        candiesLeft,
        fillCandiesCalled,
        isPaused,
        isGameWon,
        isGameLost,
        duration,
        candiesSorted,
      ];

  /// since CandyState is immutable, we need a way to mutate it's values, so as it change and emit new values and trigger a ui rebuild
  CandyState copyWith({
    int? candiesLeft,
    int? candiesSorted,
    int? fillCandiesCalled,
    int? duration,
    bool? isPaused,
    bool? isGameWon,
    bool? isGameLost,
    List<Candy>? candies,
  }) {
    return CandyState(
      candiesLeft: candiesLeft ?? this.candiesLeft,
      candiesSorted: candiesSorted ?? this.candiesSorted,
      fillCandiesCalled: fillCandiesCalled ?? this.fillCandiesCalled,
      duration: duration ?? this.duration,
      isPaused: isPaused ?? this.isPaused,
      isGameWon: isGameWon ?? this.isGameWon,
      isGameLost: isGameLost ?? this.isGameLost,
      candies: candies ?? this.candies,
    );
  }
}
