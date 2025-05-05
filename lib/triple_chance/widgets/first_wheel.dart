import 'dart:math';

import 'package:flutter/material.dart';

import '../controller/triple_chance_controller.dart';

class FirstWheelSpin extends StatefulWidget {
  final TripleChanceController controller;
  final String pathImage;
  final double withWheel;
  final int pieces;
  final double offset;
  final bool isShowTextTest;
  final int speed;
  const FirstWheelSpin(
      {super.key,
      required this.controller,
      required this.pathImage,
      required this.withWheel,
      this.offset = 0,
      required this.pieces,
      this.isShowTextTest = false,
      this.speed = 1100,
       });

  @override
  State<FirstWheelSpin> createState() => _FirstWheelSpinState();
}

class _FirstWheelSpinState extends State<FirstWheelSpin>
    with TickerProviderStateMixin {

  final Tween<double> turnsTween = Tween<double>(
    begin: 1,
    end: 0,
  );

  late final AnimationController _controllerStart;
  late final AnimationController _controllerFinish;
  late final AnimationController _controllerMiddle;

  late final Animation<double> _animationFinish;
  late final Animation<double> _animationStart;
  late final Animation<double> _animationMiddle;

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

    // Assign callbacks properly here
    widget.controller.firstStartWheel = startWheel;
    widget.controller.firstStopWheel = stopWheel;

    pieces = widget.pieces;

    _controllerStart = AnimationController(
      duration: Duration(milliseconds: widget.speed),
      vsync: this,
    );
    _controllerFinish = AnimationController(
      duration: Duration(milliseconds: widget.speed * 2),
      vsync: this,
    );
    _controllerMiddle = AnimationController(
      duration: Duration(milliseconds: widget.speed),
      vsync: this,
    );

    _animationFinish = CurvedAnimation(parent: _controllerFinish, curve: Curves.linear);
    _animationStart = CurvedAnimation(parent: _controllerStart, curve: Curves.linear);
    _animationMiddle = CurvedAnimation(parent: _controllerMiddle, curve: Curves.linear);

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

  @override
  void dispose() {
    _controllerStart.dispose();
    _controllerFinish.dispose();
    _controllerMiddle.dispose();
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

  void nhanKetQua(int index) {
    isNhanKetQua = true;
    indexResult = index;
  }

  void reset() {
    setState(() {
      isStart = false;
      statusWheel = 0;
      angle = 0;
      isNhanKetQua = false;
    });
    _controllerStart.reset();
    _controllerMiddle.reset();
    _controllerFinish.reset();
  }

  Animation<double> getAnimation() {
    if (statusWheel == 0) return _animationStart;
    if (statusWheel == 1) return _animationMiddle;
    return _animationFinish;
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

