import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../candy_cubit/candy_cubit.dart';
import '../widgets/widgets.dart';

class SettingsScreen extends HookWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const SettingsScreen());

  void checkUpdateColor({
    required BuildContext context,
    required Color checkColor,
    required CandyCubit candyCubit,
    required ValueNotifier<Color> colorValue,
  }) {
    if (candyCubit.gameColors.contains(checkColor)) {
      Navigator.pop(context);
      showSnackBar(
        context,
        text: 'Already chosen',
        duration: const Duration(seconds: 1),
      );
    } else {
      colorValue.value = checkColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final CandyCubit candyCubit = context.read<CandyCubit>();
    final countController =
        useTextEditingController(text: candyCubit.numberOfCandies.toString());
    final color1 = useState<Color>(candyCubit.gameColors[0]);
    final color2 = useState<Color>(candyCubit.gameColors[1]);
    final color3 = useState<Color>(candyCubit.gameColors[2]);
    final color4 = useState<Color>(candyCubit.gameColors[3]);
    final color5 = useState<Color>(candyCubit.gameColors[4]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Row(
              children: [
                const Text('Candy count: '),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.end,
                    controller: countController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            _PickColor(
              text: 'Color 1',
              color: color1.value,
              onColorChanged: (color) => checkUpdateColor(
                context: context,
                checkColor: Color(color.value),
                candyCubit: candyCubit,
                colorValue: color1,
              ),
              onPressedSelect: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12.0),
            _PickColor(
              text: 'Color 2',
              color: color2.value,
              onColorChanged: (color) => checkUpdateColor(
                context: context,
                checkColor: Color(color.value),
                candyCubit: candyCubit,
                colorValue: color2,
              ),
              onPressedSelect: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12.0),
            _PickColor(
              text: 'Color 3',
              color: color3.value,
              onColorChanged: (color) => checkUpdateColor(
                context: context,
                checkColor: Color(color.value),
                candyCubit: candyCubit,
                colorValue: color3,
              ),
              onPressedSelect: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12.0),
            _PickColor(
              text: 'Color 4',
              color: color4.value,
              onColorChanged: (color) => checkUpdateColor(
                context: context,
                checkColor: Color(color.value),
                candyCubit: candyCubit,
                colorValue: color4,
              ),
              onPressedSelect: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12.0),
            _PickColor(
              text: 'Color 5',
              color: color5.value,
              onColorChanged: (color) => checkUpdateColor(
                context: context,
                checkColor: Color(color.value),
                candyCubit: candyCubit,
                colorValue: color5,
              ),
              onPressedSelect: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 24.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  candyCubit.updateNumberOfCandies =
                      int.parse(countController.text);
                  candyCubit.updateGameColors = [
                    color1.value,
                    color2.value,
                    color3.value,
                    color4.value,
                    color5.value,
                  ];
                  Navigator.pop(context, true);
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickColor extends StatelessWidget {
  const _PickColor({
    Key? key,
    required this.text,
    required this.color,
    required this.onColorChanged,
    required this.onPressedSelect,
  }) : super(key: key);

  final String text;
  final Color color;
  final void Function(Color) onColorChanged;
  final void Function() onPressedSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
        ),
        GestureDetector(
          onTap: () => pickColor(
              context: context,
              pickerColor: color,
              onColorChanged: onColorChanged,
              onPressedSelect: onPressedSelect),
          child: CircleAvatar(
            backgroundColor: color,
          ),
        ),
      ],
    );
  }
}