import 'package:flutter/material.dart';
import 'package:untitled/common_widgets/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
}) : assert( text != null),
        super(
    child: Text(
      text,
      style: TextStyle(
      color: textColor,
        fontSize: 15.0,
      ),
    ),
    color: color,
    onPressed: onPressed,
  );
}