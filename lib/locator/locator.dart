import 'dart:math';

import 'package:get_it/get_it.dart';

import '../services/services.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<Random>(() => Random());
  locator.registerLazySingleton<Ticker>(() => const Ticker());
  locator.registerLazySingleton<GameService>(() => const GameService());
}
