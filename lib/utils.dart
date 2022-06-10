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

  static String formatarData(DateTime data) {
    String dia =
        data.day < 10 ? "0" + data.day.toString() : data.day.toString();
    String mes =
        data.month < 10 ? "0" + data.month.toString() : data.month.toString();
    // String hora =
    //     data.hour < 10 ? "0" + data.hour.toString() : data.hour.toString();
    // String min = data.minute < 10
    //     ? "0" + data.minute.toString()
    //     : data.minute.toString();

    return dia + "/" + mes + "/" + data.year.toString(); //+
    // " " +
    // hora +
    // ":" +
    // min;
  }
}
