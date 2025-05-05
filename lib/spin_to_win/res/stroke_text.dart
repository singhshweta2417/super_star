import 'package:flutter/material.dart';

class StrokeText extends StatelessWidget {
  final String text;
  final double strokeWidth;
  final Color textColor;
  final Color strokeColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextScaler? textScaler;
  final TextOverflow? overflow;
  final int? maxLines;

  const StrokeText({
    super.key,
    required this.text,
    this.strokeWidth = 2,
    this.strokeColor = Colors.black,
    this.textColor = Colors.white,
    this.fontSize,
    this.textStyle,
    this.textAlign,
    this.textDirection,
    this.textScaler,
    this.overflow,
    this.maxLines,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ).merge(textStyle),
          textAlign: textAlign,
          textDirection: textDirection,
          textScaler: textScaler,
          overflow: overflow,
          maxLines: maxLines,
        ),
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ).merge(
            textStyle,
          ),
          textDirection: textDirection,
          textScaler: textScaler,
          overflow: overflow,
          maxLines: maxLines,
        ),
      ],
    );
  }
}
