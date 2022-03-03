part of 'candy_cubit.dart';

class CandyState extends Equatable {
  const CandyState({
    this.candiesLeft = 0,
    this.candiesSorted = 0,
    this.candies = const [],
  });

  final int candiesLeft;
  final int candiesSorted;
  final List<Candy> candies;

  @override
  List<Object> get props => [candies, candiesLeft, candiesSorted];

  CandyState copyWith({
    int? candiesLeft,
    int? candiesSorted,
    List<Candy>? candies,
  }) {
    return CandyState(
      candiesLeft: candiesLeft ?? this.candiesLeft,
      candiesSorted: candiesSorted ?? this.candiesSorted,
      candies: candies ?? this.candies,
    );
  }
}
