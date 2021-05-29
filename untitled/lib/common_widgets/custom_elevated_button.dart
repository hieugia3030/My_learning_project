import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    this.borderRadius : 2.0,
    this.child,
    this.color,
    this.onPressed,
    this.height : 50.0,
  }) : assert(borderRadius != null),
       assert(height != null);

  final Widget child;
  final Color color;
  final double borderRadius;
  final VoidCallback onPressed;
  final double height ;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        child: child,
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
        ),
        onPressed: onPressed,
      ),
      height: 50.0,
    );
  }
}
