import 'package:flutter/material.dart';
import 'custom_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton{
  FormSubmitButton({
  @required String text,
  @required VoidCallback onPressed,
  }) : assert (text!= null),
        super
      (
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
      onPressed: onPressed,
      borderRadius: 4.0,
      height: 44.0,
      color: Colors.indigo,
    );
}
