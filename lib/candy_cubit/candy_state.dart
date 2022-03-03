part of 'candy_cubit.dart';

class CandyState extends Equatable {
  const CandyState({
    this.candiesLeft = 0,
    this.candiesSorted = 0,
    this.duration = 0,
    this.candies = const [],
  });

  final int candiesLeft;
  final int candiesSorted;
  final int duration;
  final List<Candy> candies;

  @override
  List<Object> get props => [
        candies,
        candiesLeft,
        duration,
        candiesSorted,
      ];

  CandyState copyWith({
    int? candiesLeft,
    int? candiesSorted,
    int? duration,
    List<Candy>? candies,
  }) {
    return CandyState(
      candiesLeft: candiesLeft ?? this.candiesLeft,
      candiesSorted: candiesSorted ?? this.candiesSorted,
      duration: duration ?? this.duration,
      candies: candies ?? this.candies,
    );
  }
}
