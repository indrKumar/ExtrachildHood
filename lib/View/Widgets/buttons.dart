import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? width;
  final double? height;
  final Border? border;


  LoginButton({
    this.onTap,
    this.color,
    this.child,
    this.border,
    this.gradient,
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        child: Container(
          width: width,
          height: height,
          padding: padding,
          margin: margin,

          decoration: BoxDecoration(
              border: border,
              borderRadius: borderRadius,
              gradient: gradient,
              color: color),
          child: child,
        ),
      ),
    );
  }
}
