import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'candy_cubit/candy_cubit.dart';
import 'locator/locator.dart';
import 'router/app_router.dart';
import 'screens/screens.dart';

void main() {
  setup();
  runApp(const CandySorter());
}

class CandySorter extends StatelessWidget {
  const CandySorter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CandyCubit>(
      create: (_) => CandyCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Candy Sorter',
        theme: ThemeData(
          textTheme: GoogleFonts.pressStart2pTextTheme(),
        ),
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: const StartGameScreen(),
      ),
    );
  }
}
