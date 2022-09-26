import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget? child;
  final bool includePadding;

  const GradientBackground(
      {Key? key, required this.child, this.includePadding = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: includePadding ? Spaces.getHoriPadding() : EdgeInsets.zero,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            ColorConstants.whiteColor,
            ColorConstants.whiteColor,
          ],
        ),
      ),
      child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: child),
    );
  }
}
