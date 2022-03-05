import 'dart:math';

import 'package:get_it/get_it.dart';

import '../services/services.dart';

/// the service locator class, where we register all the services we need in our app, so that we can use it anywhere without having to create a new instance every time. Is called from the main() method inside main.dart

final locator = GetIt.instance;

void setup() {
  /// registerLazySingleton: registers the passed service only when it is called for the first time(Lazy), and creates and stores a single instance of the service class(Singleton)
  locator.registerLazySingleton<Random>(() => Random());
  locator.registerLazySingleton<Ticker>(() => const Ticker());
  locator.registerLazySingleton<GameService>(() => const GameService());
}
