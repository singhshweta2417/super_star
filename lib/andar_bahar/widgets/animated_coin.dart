import 'dart:math';

import 'package:flutter/material.dart';
import 'package:super_star/andar_bahar/widgets/coin_spring_animation.dart';

class AnimatedCoin extends StatefulWidget {
  final int type;

  const AnimatedCoin({super.key, required this.type});
  @override
  AnimatedCoinState createState() => AnimatedCoinState();
}

class AnimatedCoinState extends State<AnimatedCoin>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = widget.type == 1
        ? Tween<Offset>(
      begin: const Offset(10, 50),
      end: _randomOffset(100, 150),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    )
        : Tween<Offset>(
      begin: const Offset(10, 50),
      end: _randomOffset(100, 150),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();
  }

  doublePj(double start, double end) {
    Random random = Random();

    return start + random.nextDouble() * (end - start);
  }

  Offset _randomOffset(double start, double end) {
    double randomPositionX = doublePj(50, 200);
    double randomPositionY = doublePj(50, 100);
    return Offset(randomPositionX, randomPositionY);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _animation.value,
          child: const CoinSpringAnimation(),
        );
      },
    );
  }
}