import 'package:flutter/material.dart';

class TempleShape extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final Widget child;

  const TempleShape({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    required this.borderColor,
    required this.borderWidth,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(width, height),
          painter: TemplePainter(
            color: color,
            borderColor: borderColor,
            borderWidth: borderWidth,
          ),
        ),
        Positioned(
          child: child,
        ),
      ],
    );
  }
}

class TemplePainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;

  TemplePainter({
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
      ..lineTo(0, size.height / 1)
      ..lineTo(0, size.height / 300)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}