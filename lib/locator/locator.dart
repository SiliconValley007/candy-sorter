import 'dart:math';

import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<Random>(() => Random());
}
