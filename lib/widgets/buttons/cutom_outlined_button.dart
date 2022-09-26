import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomOutlinedButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final VoidCallback onPressed;

  const CustomOutlinedButton({
    Key? key,
    this.width = double.infinity,
    this.height = -1,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height == -1 ? 6.8.h : height,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
