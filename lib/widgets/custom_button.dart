import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
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
    this.padding = const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
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
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
            fontFamily: 'ABeeZee',
          ),
        ),
      ),
    );
  }
}
