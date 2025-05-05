import 'package:flutter/material.dart';

class CText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? weight;
  final Color? color;
  final EdgeInsetsGeometry? pad;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final Color? bgColor;
  final void Function()? onTap;
  final BorderRadiusGeometry? borderRadius;
  final double radius;
  final Alignment alignment;
  final TextAlign? textAlign;
  const CText(
    this.text, {
    super.key,
    this.size,
    this.weight,
    this.color,
    this.pad,
    this.margin,
    this.width,
    this.bgColor,
    this.onTap,
    this.borderRadius,
    this.radius = 2,
    this.alignment = Alignment.centerLeft,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: textAlign,
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color ?? Colors.black,
      ),
    );
  }
}
