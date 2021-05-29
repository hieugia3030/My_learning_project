import 'package:flutter/material.dart';
import 'package:untitled/common_widgets/custom_elevated_button.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton({
    @required String text,
    @required String assetName,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  }) : assert( text != null),
       assert( assetName != null),
        super(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Image.asset(
            'images/$assetName.png',
          width: 40.0,
          height: 40.0,
        ),
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 15.0,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset('images/google-logo.png'),
        ),
      ],
    ),
    color: color,
    onPressed: onPressed,
  );
}