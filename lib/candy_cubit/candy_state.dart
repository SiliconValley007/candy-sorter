part of 'candy_cubit.dart';

class CandyState extends Equatable {
  const CandyState({
    this.candiesLeft = 0,
    this.candiesSorted = 0,
    this.duration = 0,
    this.isPaused = false,
    this.isGameLost = false,
    this.isGameWon = false,
    this.candies = const [],
  });

  final int candiesLeft;
  final int candiesSorted;
  final int duration;
  final bool isGameWon;
  final bool isGameLost;
  final bool isPaused;
  final List<Candy> candies;

  @override
  List<Object> get props => [
        candies,
        candiesLeft,
        isPaused,
        isGameWon,
        isGameLost,
        duration,
        candiesSorted,
      ];

  CandyState copyWith({
    int? candiesLeft,
    int? candiesSorted,
    int? duration,
    bool? isPaused,
    bool? isGameWon,
    bool? isGameLost,
    List<Candy>? candies,
  }) {
    return CandyState(
      candiesLeft: candiesLeft ?? this.candiesLeft,
      candiesSorted: candiesSorted ?? this.candiesSorted,
      duration: duration ?? this.duration,
      isPaused: isPaused ?? this.isPaused,
      isGameWon: isGameWon ?? this.isGameWon,
      isGameLost: isGameLost ?? this.isGameLost,
      candies: candies ?? this.candies,
    );
  }
}
