import 'dart:async';

import 'package:flutter/material.dart';
import 'package:super_star/main.dart';

class SpinWheelBulb extends StatefulWidget {
  const SpinWheelBulb({super.key});

  @override
  SpinWheelBulbState createState() => SpinWheelBulbState();
}

class SpinWheelBulbState extends State<SpinWheelBulb> {
  Color _color = Colors.green;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startColorChange();
  }

  void _startColorChange() {
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        if (_color == Colors.green) {
          _color = Colors.red;
        } else if (_color == Colors.red) {
          _color = Colors.yellow;
        } else {
          _color = Colors.green;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: screenWidth*0.04,
        height: screenHeight*0.04,
        decoration: BoxDecoration(
          color: _color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black87,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _color,
              blurRadius: 4.0,
              spreadRadius: 4.0,
            ),
          ],
        ),

      ),
    );
  }
}







