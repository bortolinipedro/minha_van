import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color textColor;
  final double fontSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
    this.width,
    this.height = 63,
    this.borderRadius = 38.0,
    this.padding,
    Color? textColor,
    this.fontSize = 18,
  }) : textColor = textColor ?? Colors.white;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: padding ?? EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize, 
              color: textColor, 
              fontFamily: 'ABeeZee',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}