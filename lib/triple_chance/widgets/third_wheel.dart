import 'dart:math';

import 'package:flutter/material.dart';

import '../controller/triple_chance_controller.dart';

class ThirdWheelSpin extends StatefulWidget {
  final TripleChanceController controller;
  final String pathImage;
  final double withWheel;
  final int pieces;
  final double offset;
  final bool isShowTextTest;
  final int speed;
  const ThirdWheelSpin({
    super.key,
    required this.controller,
    required this.pathImage,
    required this.withWheel,
    this.offset = 0,
    required this.pieces,
    this.isShowTextTest = false,
    this.speed = 1100,
  });

  @override
  State<ThirdWheelSpin> createState() => _BlueWheelSpinState();
}

class _BlueWheelSpinState extends State<ThirdWheelSpin>
    with TickerProviderStateMixin {
  final Tween<double> turnsTween = Tween<double>(begin: 1, end: 0);
  late final AnimationController _controllerStart = AnimationController(
    duration: Duration(milliseconds: widget.speed),
    vsync: this,
  );
  late final AnimationController _controllerFinish = AnimationController(
    duration: Duration(milliseconds: widget.speed * 2),
    vsync: this,
  );

  late final AnimationController _controllerMiddle = AnimationController(
    duration: Duration(milliseconds: widget.speed),
    vsync: this,
  );

  late final Animation<double> _animationFinish = CurvedAnimation(
    parent: _controllerFinish,
    curve: Curves.linear,
  );
  late final Animation<double> _animationStart = CurvedAnimation(
    parent: _controllerStart,
    curve: Curves.linear,
  );

  late final Animation<double> _animationMiddle = CurvedAnimation(
    parent: _controllerMiddle,
    curve: Curves.linear,
  );

  int statusWheel = 0;

  bool isNhanKetQua = false;
  int indexResult = 0;
  double angle = 0;
  int pieces = 0;

  List<String> items = [];
  bool isStart = false;
  @override
  void initState() {
    super.initState();
    widget.controller.thirdStartWheel = startWheel;
    widget.controller.thirdStopWheel = stopWheel;
    pieces = widget.pieces;

    _controllerStart.addStatusListener((status) {
      if (!isStart) return;
      if (status == AnimationStatus.completed) {
        if (!isNhanKetQua) {
          _controllerStart.reset();
          _controllerStart.forward();
        } else {
          setState(() {
            statusWheel = 1;
            _controllerStart.stop();

            _controllerMiddle.forward();
          });
        }
      }
    });
    _controllerMiddle.addListener(() {
      if (!isStart) return;
      double radius = indexResult / pieces + widget.offset;
      if (_controllerMiddle.value >= radius) {
        setState(() {
          statusWheel = 2;
          angle = radius * 2 * pi;
          _controllerMiddle.stop();
          _controllerFinish.forward();
        });
      }
    });
  }

  reset() {
    setState(() {});
    isStart = false;
    statusWheel = 0;
    angle = 0;
    _controllerMiddle.reset();
    _controllerFinish.reset();
    _controllerStart.reset();

    isNhanKetQua = false;
  }

  void nhanKetQua(int index) {
    isNhanKetQua = true;
    indexResult = index;
  }

  Animation<double> getAnimation() {
    if (statusWheel == 0) return _animationStart;
    if (statusWheel == 1) return _animationMiddle;
    return _animationFinish;
  }

  @override
  void dispose() {
    if (_controllerStart.isAnimating) _controllerStart.dispose();
    if (_controllerFinish.isAnimating) _controllerFinish.dispose();
    if (_controllerMiddle.isAnimating) _controllerMiddle.dispose();
    super.dispose();
  }

  void startWheel() {
    reset();
    isStart = true;
    _controllerStart.forward();
  }

  void stopWheel(int index) {
    nhanKetQua(index);
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: getAnimation(),
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: widget.withWheel,
          height: widget.withWheel,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.pathImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
