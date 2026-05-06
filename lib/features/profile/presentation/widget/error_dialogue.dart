import 'package:day_tick/core/utils/app_colours.dart';
import 'package:flutter/material.dart';

void showErrorDialog(String msg, context) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        backgroundColor: const Color(0xff151d30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.red.withOpacity(.3)),
        ),
        title: const Text(
          "Invalid Input",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          msg,
          style: TextStyle(color: Colors.white.withOpacity(.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: kgreencolor)),
          ),
        ],
      );
    },
  );
}
