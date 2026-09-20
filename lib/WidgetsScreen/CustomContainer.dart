import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  // Size
  final double? height;
  final double? width;

  // Spacing & alignment
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;

  // Decoration related
  final Color? color;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final Gradient? gradient;

  // Child
  final Widget? child;

  const CustomContainer({
    super.key,
    required this.height,
    required this.width,
    this.padding,
    this.margin,
    this.alignment,
    required this.color,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.gradient,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius:
            borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
        boxShadow: boxShadow,
        border: border,
      ),
      child: child,
    );
  }
}
