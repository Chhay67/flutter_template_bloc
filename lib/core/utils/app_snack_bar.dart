

import 'package:flutter/material.dart';


class AppSnackBar {
  static void showSuccess(BuildContext context, {required String message,Widget? trialing}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
              ?trialing,
            ],
          ),
          backgroundColor: Colors.greenAccent,
        ),
      );
  }

  static void showError(BuildContext context, {required String message,Widget? trialing}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
              ?trialing,
            ],
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
  }
}