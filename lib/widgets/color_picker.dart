import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


/// show the color picker dialog, in the setting screen, when changing the game colors
void pickColor({
    required BuildContext context,
    required Color pickerColor,
    required void Function(Color) onColorChanged,
    required void Function() onPressedSelect,
  }) {
    /// show pop up dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick color'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlockPicker(
              pickerColor: pickerColor,
              onColorChanged: onColorChanged,
            ),
            ElevatedButton(
              onPressed: onPressedSelect,
              child: const Text('Select'),
            ),
          ],
        ),
      ),
    );
  }