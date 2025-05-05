import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/main.dart';
import 'dart:math' as math;

import 'package:super_star/timer_36/controller/timer_36_controller.dart';
import 'package:super_star/timer_36/view_model/timer_36_last_result_view_model.dart';
import 'package:super_star/timer_36/view_model/timer_36_win_a_view_model.dart';
import 'package:super_star/utils/routes/routes_name.dart';

import 'timer_wheel_spin.dart';

class TimerThirteenHistory extends StatefulWidget {
  final Timer36Controller rbc;
  const TimerThirteenHistory({
    super.key,
    required this.rbc,
  });

  @override
  State<TimerThirteenHistory> createState() => _TimerThirteenHistoryState();
}

class _TimerThirteenHistoryState extends State<TimerThirteenHistory>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 1500))
      ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timer36LastResultViewModel =
    Provider.of<Timer36LastResultViewModel>(context);
    final timer36WinAViewModel =
    Provider.of<Timer36WinAViewModel>(context);
    return Positioned(
        top: 0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (timer36LastResultViewModel.timer36LastResultList.isNotEmpty)
              Container(
                margin: EdgeInsets.only(
                    top: screenWidth * 0.01, left: screenWidth * 0.02),
                height: screenHeight * 0.36,
                width: screenWidth * 0.08,
                child: Column(
                  children: List.generate(
                      timer36LastResultViewModel.timer36LastResultList.length,
                          (index) {
                        final resData =
                            timer36LastResultViewModel.timer36LastResultList;
                        return Expanded(
                          child: Container(
                            padding: EdgeInsets.only(
                                right: screenWidth * 0.01,
                                left: screenWidth * 0.01),
                            alignment: resData[index].status == 0
                                ? Alignment.centerRight
                                : resData[index].status == 1
                                ? Alignment.centerLeft
                                : Alignment.center,
                            child: FittedBox(
                              child: Text(
                                resData[index].number.toString(),
                                style: TextStyle(
                                  color: resData[index].status == 0
                                      ? const Color(0xffbf472e)
                                      : resData[index].status == 1
                                      ? Colors.yellow
                                      : Colors.green,
                                  fontWeight: FontWeight.w900,
                                  // fontFamily: 'roboto_black'
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              )
            else
              Container(
                height: screenHeight * 0.36,
                width: screenWidth * 0.08,
                margin: EdgeInsets.only(
                    top: screenWidth * 0.01, left: screenWidth * 0.02),
                color: Colors.transparent,
              ),
            Container(
              margin: EdgeInsets.only(
                  top: screenWidth * 0.01, left: 6),
              height: screenHeight * 0.29,
              width: screenWidth * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.rbc.hideDesign == false)
                    Expanded(
                        child: Container(
                          alignment: Alignment.topCenter,
                          color: const Color(0xffee8c69),
                          margin: const EdgeInsets.only(top: 2, right: 6, left: 6),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                top: 0.0,
                                right: -screenWidth * 0.16,
                                child: WheelSpin(
                                  controller: widget.rbc,
                                  pathImage: Assets.timer36Wheel,
                                  withWheel: screenWidth * 0.51,
                                  pieces: 37,
                                ),
                              ),
                              Positioned(
                                  bottom: -8,
                                  child: Text(
                                    '◍',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.035,
                                        fontWeight: FontWeight.w900),
                                  ))
                            ],
                          ),
                        )),
                  Container(
                    height: screenWidth * 0.023,
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: screenWidth * 0.07,
                      margin: EdgeInsets.only(right: screenWidth * 0.01,top: 1,bottom: 1),
                      child: FittedBox(
                        child: Text(
                          widget.rbc.totalBetAmount.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: screenWidth * 0.026,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: screenWidth * 0.01),
                    child: widget.rbc.hideValue == false
                        ? FittedBox(
                      child: Text(
                        'You Won ${timer36WinAViewModel.winAmount??'0'}',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: screenWidth * 0.015,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                        : null,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: screenWidth * 0.02, left: screenWidth * 0.01),
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.16,
                  // color: Colors.red.withOpacity(0.4),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.game36Rules);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: screenWidth * 0.02,left: 15),
                    height: screenWidth * 0.02,
                    width: screenWidth * 0.12,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(Assets.timer36RulesBtn),
                            fit: BoxFit.fill)),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                  top: screenWidth * 0.015, left: screenWidth * 0.02),
              height: screenHeight * 0.09,
              width: screenWidth * 0.1,
              // color: Colors.red.withOpacity(0.4),
              child: FittedBox(
                  child: Text(
                    widget.rbc.hideValue == false
                        ? widget.rbc.showResult[widget.rbc.showData].toString()
                        : '',
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.w900,
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.043, top: screenHeight * 0.04),
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0005)
                  ..rotateX(-1.15)
                  ..rotateY(0.015),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: 0,
                      child: AnimatedBuilder(
                          animation: _controller,
                          builder: (_, child) {
                            return Transform.rotate(
                              angle: _controller.value * 170 * math.pi,
                              child: Container(
                                height: screenHeight * 0.55,
                                width: screenWidth * 0.29,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: WheelSpins(
                                  controller: widget.rbc,
                                  withWheel: screenWidth * 0.29,
                                  pieces: 37,
                                  pathImage: Assets.timer36Wheel,
                                ),
                              ),
                            );
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: screenWidth * 0.035),
                      child: Image.asset(Assets.timer36Thudi,
                          height: screenWidth * 0.065),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class ThirteenModel {
  final String result;
  final int status;
  ThirteenModel({
    required this.result,
    required this.status,
  });
}
