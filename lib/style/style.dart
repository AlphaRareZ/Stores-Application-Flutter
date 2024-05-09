import 'package:flutter/material.dart';

InputDecoration buildInputDecoration({
  required String labelText,
  required IconData prefixIcon,
  Color labelColor = Colors.blueGrey,
  Color enabledBorderColor = Colors.blueGrey,
  Color focusedBorderColor = Colors.blue,
  Color errorBorderColor = Colors.red,
}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(color: labelColor),
    prefixIcon: Icon(prefixIcon, color: labelColor),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: enabledBorderColor.withOpacity(0.4)),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: focusedBorderColor),
      borderRadius: BorderRadius.circular(10),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: errorBorderColor),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: errorBorderColor),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
