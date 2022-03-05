import 'package:flutter/material.dart';

/// custom snackbar, displayed when the user chooses a wrong bowl or selects a color that already has been occupied
void showSnackBar(
  BuildContext context, {
  required String text,
  Duration duration = const Duration(milliseconds: 500),
}) {
  final snackBar = SnackBar(
    duration: duration,
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.5),
        border: Border.all(color: Colors.red, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            spreadRadius: 2.0,
            blurRadius: 8.0,
            offset: Offset(2, 4),
          )
        ],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(Icons.cancel, color: Colors.red),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
