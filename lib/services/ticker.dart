/// ticker class used for the timer
class Ticker {
  /// constant constructor
  const Ticker();

  /// method to periodically return a new value every second
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}
