import 'package:flutter/material.dart';

void showSnackBar(BuildContext context) {
  final snackBar = SnackBar(
    duration: const Duration(milliseconds: 500),
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
        children: const [
          Icon(Icons.cancel, color: Colors.red),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              '!!! Wrong bowl !!!',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
