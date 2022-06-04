import 'package:flutter/material.dart';

class EMUtils {
  static String? textValidator(String? value) {
    return value == null || value.isEmpty
        ? "Esse campo não pode estar vazio."
        : null;
  }

  static void mostrarSnackbar(
      BuildContext context, String snackbarText, Color? snackbarColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackbarText),
        backgroundColor: snackbarColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 3000),
      ),
    );
  }
}
