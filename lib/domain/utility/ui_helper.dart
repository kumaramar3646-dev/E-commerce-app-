import 'package:flutter/material.dart';

class AppDecoration{

  static InputDecoration mDecoration({
    required String label,
    required String hint,
    IconData? mIcon,
    bool isPass = false,
    bool isPasswordVisible = false,
    void Function()? onObscureTap,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: isPass
          ? InkWell(
        onTap: onObscureTap,
        child: Icon(
          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        ),
      )
          : null,
      prefixIcon: mIcon != null ? Icon(mIcon) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(21)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(21),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(21),
      ),
    );
  }

}