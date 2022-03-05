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
    /// since we are using the HookWidget, we initialize everything inside the build method as states by the flutter_hooks documentation
    final CandyCubit candyCubit = context.read<CandyCubit>();

    /// using useValueNotifier() instead of useState() to increase performance and decrease unnecessary rebuilds
    /// useState() rebuilds the entire build method, useValueNotifier() rebuilds only the widget listening to it
    final candyCount = useValueNotifier<int>(candyCubit.defaultNumberOfCandies);
    final color1 = useValueNotifier<Color>(candyCubit.gameColors[0]);
    final color2 = useValueNotifier<Color>(candyCubit.gameColors[1]);
    final color3 = useValueNotifier<Color>(candyCubit.gameColors[2]);
    final color4 = useValueNotifier<Color>(candyCubit.gameColors[3]);
    final color5 = useValueNotifier<Color>(candyCubit.gameColors[4]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
      ),

      /// to detect taps on the entire screen
      body: GestureDetector(
        /// unfocus all TextField widgets upon tapping anywhere on the screen
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),

          /// using ListView instead of normal column, because normal column will give render Overflow error when keyboard is opened, ListView makes the page scrollable when the keyboard is opened.
          child: ListView(
            /// remove this if you want the page to be scrollable
            physics: const NeverScrollableScrollPhysics(),
            children: [
              /// widget to display the existing candy count and also the candy count when the slider is moved
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Candy count: '),
                  ValueListenableBuilder<int>(
                    valueListenable: candyCount,
                    builder: (context, count, child) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text('$count'),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12.0),

              /// slider widget to let the user select a candy count between the range of 10 and 150
              ValueListenableBuilder<int>(
                  valueListenable: candyCount,
                  builder: (context, count, child) {
                    return Slider(
                      min: 10,
                      max: 150,

                      /// set the initial value to the default candy count
                      value: count.toDouble(),

                      /// sets the slider value to candyCount value notifier when the slider is moved, also rebuilding candy count displaying text widget
                      onChanged: (value) => candyCount.value = value.toInt(),
                    );
                  }),
              const SizedBox(height: 24.0),

              /// widgets to display the current colors and also provide a way to update the colors
              _PickColor(
                text: 'Color 1',
                colorListenable: color1,
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
                colorListenable: color2,
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
                colorListenable: color3,
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
                colorListenable: color4,
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
                colorListenable: color5,
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

                /// button to save the changes made in the settings and start a new game
                child: ElevatedButton(
                  onPressed: () {
                    if (candyCount.value != candyCubit.defaultNumberOfCandies) {
                      candyCubit.updateNumberOfCandies = candyCount.value;
                    }
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
      ),
    );
  }
}

/// private widget (because only used in this file)
class _PickColor extends StatelessWidget {
  const _PickColor({
    Key? key,
    required this.text,
    required this.colorListenable,
    required this.onColorChanged,
    required this.onPressedSelect,
  }) : super(key: key);

  final String text;
  final ValueNotifier<Color> colorListenable;
  final void Function(Color) onColorChanged;
  final void Function() onPressedSelect;

  @override
  Widget build(BuildContext context) {
    /// will be rebuilt when the provided valueListenable value changes
    return ValueListenableBuilder<Color>(
      valueListenable: colorListenable,
      builder: (context, count, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
            ),
            GestureDetector(
              onTap: () => pickColor(
                  context: context,
                  pickerColor: colorListenable.value,
                  onColorChanged: onColorChanged,
                  onPressedSelect: onPressedSelect),
              child: CircleAvatar(
                backgroundColor: colorListenable.value,
              ),
            ),
          ],
        );
      },
    );
  }
}
