import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'candy_cubit/candy_cubit.dart';
import 'locator/locator.dart';
import 'router/app_router.dart';
import 'screens/screens.dart';

void main() {
  /// initialize the get_it service locator and register the services required by the app
  setup();
  runApp(const CandySorter());
}

class CandySorter extends StatelessWidget {
  const CandySorter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// provide the CandyCubit to the entire app as it will be needed everywhere
    return BlocProvider<CandyCubit>(
      /// will handle the CandyCubit initialization and dispose if of when not needed
      create: (_) => CandyCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Candy Sorter',
        /// setting the theme for the entire app (requires internet connection, therefore added internet permission to xml)
        theme: ThemeData(
          textTheme: GoogleFonts.pressStart2pTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        /// handles navigation for the app
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: const StartGameScreen(),
      ),
    );
  }
}
