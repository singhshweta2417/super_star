import 'package:flutter/material.dart';

class DiamondShape extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Color borderColor;
  final double borderWidth;

  const DiamondShape({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: DiamondPainter(
        color: color,
        borderColor: borderColor,
        borderWidth: borderWidth,
      ),
    );
  }
}

class DiamondPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;

  DiamondPainter({
    required this.color,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    Paint borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    Path path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height / 2)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}