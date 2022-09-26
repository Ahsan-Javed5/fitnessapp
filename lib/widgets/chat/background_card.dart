import 'package:flutter/material.dart';

class BackgroundCard extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  final bool hasShadow;
  final double borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Widget child;

  const BackgroundCard({
    Key? key,
    this.width,
    this.height,
    this.color,
    this.hasShadow = true,
    this.borderRadius = 8.0,
    required this.padding,
    this.margin,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      height: height ?? MediaQuery.of(context).size.height * 0.25,
      padding: padding ?? EdgeInsets.zero,
      margin: margin ?? EdgeInsets.zero,
      child: child,
      decoration: BoxDecoration(
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5.0, // has the effect of softening the shadow
                  spreadRadius: 1, // has the effect of extending the shadow
                  offset: const Offset(
                    0, // horizontal, move right 10
                    0, // vertical, move down 10
                  ),
                ),
              ]
            : [],
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
