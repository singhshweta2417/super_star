import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/main.dart';
import 'package:super_star/timer_36/controller/timer_36_controller.dart';
import 'package:super_star/timer_36/widgets/diamond_shape.dart';
import 'package:super_star/timer_36/widgets/temple_shape.dart';

class Timer36Board extends StatefulWidget {
  const Timer36Board({super.key});

  @override
  State<Timer36Board> createState() => _Timer36BoardState();
}

class _Timer36BoardState extends State<Timer36Board> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Timer36Controller>(builder: (context, rbc, child) {
      return Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(
                left: screenWidth * 0.04, top: screenHeight * 0.03),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        _build2To1Button(rbc, 37, 4, 1, () {
                          rbc.activeSingleBet(37, rbc.betValue, context);
                        }),
                        _build2To1Button(rbc, 38, 1, 1, () {
                          rbc.activeSingleBet(38, rbc.betValue, context);
                        }),
                        _build2To1Button(rbc, 39, 1, 4, () {
                          rbc.activeSingleBet(39, rbc.betValue, context);
                        }),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            circleWidget(
                                rbc, 34, Assets.timer36Red, Colors.white, () {
                              rbc.activeSingleBet(34, rbc.betValue, context);
                            }, top: 3, bottom: 2),
                            circleWidget(
                                rbc, 31, Assets.timer36Black, Colors.white, () {
                              rbc.activeSingleBet(31, rbc.betValue, context);
                            }, top: 3, bottom: 2),
                            circleWidget(
                                rbc, 28, Assets.timer36Black, Colors.white, () {
                              rbc.activeSingleBet(28, rbc.betValue, context);
                            }, top: 3, bottom: 2),
                            circleWidget(
                                rbc, 25, Assets.timer36Red, Colors.white, () {
                              rbc.activeSingleBet(25, rbc.betValue, context);
                            }, top: 3, bottom: 2),
                            circleWidget(
                                rbc, 22, Assets.timer36Black, Colors.white, () {
                              rbc.activeSingleBet(22, rbc.betValue, context);
                            }, top: 3, bottom: 2),
                            circleWidget(
                                rbc, 19, Assets.timer36Red, Colors.white, () {
                              rbc.activeSingleBet(19, rbc.betValue, context);
                            }, top: 3, bottom: 2),
                            circleWidget(
                                rbc, 16, Assets.timer36Red, Colors.white, () {
                              rbc.activeSingleBet(16, rbc.betValue, context);
                            }, top: 3, bottom: 2),
                            circleWidget(
                                rbc, 13, Assets.timer36Black, Colors.white, () {
                              rbc.activeSingleBet(13, rbc.betValue, context);
                            }, top: 3, bottom: 2),
                            circleWidget(
                                rbc, 10, Assets.timer36Black, Colors.white, () {
                              rbc.activeSingleBet(10, rbc.betValue, context);
                            }, top: 3, bottom: 2),
                            circleWidget(
                                rbc, 7, Assets.timer36Red, Colors.white, () {
                              rbc.activeSingleBet(7, rbc.betValue, context);
                            }, top: 3, bottom: 2),
                            circleWidget(
                                rbc, 4, Assets.timer36Black, Colors.white, () {
                              rbc.activeSingleBet(4, rbc.betValue, context);
                            }, top: 3, bottom: 2),
                            circleWidget(
                                rbc, 1, Assets.timer36Red, Colors.white, () {
                              rbc.activeSingleBet(1, rbc.betValue, context);
                            }, top: 3, bottom: 2),
                          ],
                        ),
                        Row(
                          children: [
                            circleWidget(
                                rbc, 35, Assets.timer36Black, Colors.white, () {
                              rbc.activeSingleBet(35, rbc.betValue, context);
                            }),
                            circleWidget(
                                rbc, 32, Assets.timer36Red, Colors.white, () {
                              rbc.activeSingleBet(32, rbc.betValue, context);
                            }),
                            circleWidget(
                                rbc, 29, Assets.timer36Black, Colors.white, () {
                              rbc.activeSingleBet(29, rbc.betValue, context);
                            }),
                            circleWidget(
                                rbc, 26, Assets.timer36Black, Colors.white, () {
                              rbc.activeSingleBet(26, rbc.betValue, context);
                            }),
                            circleWidget(
                                rbc, 23, Assets.timer36Red, Colors.white, () {
                              rbc.activeSingleBet(23, rbc.betValue, context);
                            }),
                            circleWidget(
                                rbc, 20, Assets.timer36Black, Colors.white, () {
                              rbc.activeSingleBet(20, rbc.betValue, context);
                            }),
                            circleWidget(
                                rbc, 17, Assets.timer36Black, Colors.white, () {
                              rbc.activeSingleBet(17, rbc.betValue, context);
                            }),
                            circleWidget(
                                rbc, 14, Assets.timer36Red, Colors.white, () {
                              rbc.activeSingleBet(14, rbc.betValue, context);
                            }),
                            circleWidget(
                                rbc, 11, Assets.timer36Black, Colors.white, () {
                              rbc.activeSingleBet(11, rbc.betValue, context);
                            }),
                            circleWidget(
                                rbc, 8, Assets.timer36Black, Colors.white, () {
                              rbc.activeSingleBet(8, rbc.betValue, context);
                            }),
                            circleWidget(
                                rbc, 5, Assets.timer36Red, Colors.white, () {
                              rbc.activeSingleBet(5, rbc.betValue, context);
                            }),
                            circleWidget(
                                rbc, 2, Assets.timer36Black, Colors.white, () {
                              rbc.activeSingleBet(2, rbc.betValue, context);
                            }),
                          ],
                        ),
                        Row(
                          children: [
                            circleWidget(
                                rbc, 36, Assets.timer36Red, Colors.white, () {
                              rbc.activeSingleBet(36, rbc.betValue, context);
                            }, top: 2, bottom: 3),
                            circleWidget(
                                rbc, 33, Assets.timer36Black, Colors.white, () {
                              rbc.activeSingleBet(33, rbc.betValue, context);
                            }, top: 2, bottom: 3),
                            circleWidget(
                                rbc, 30, Assets.timer36Red, Colors.white, () {
                              rbc.activeSingleBet(30, rbc.betValue, context);
                            }, top: 2, bottom: 3),
                            circleWidget(
                                rbc, 27, Assets.timer36Red, Colors.white, () {
                              rbc.activeSingleBet(27, rbc.betValue, context);
                            }, top: 2, bottom: 3),
                            circleWidget(
                                rbc, 24, Assets.timer36Black, Colors.white, () {
                              rbc.activeSingleBet(24, rbc.betValue, context);
                            }, top: 2, bottom: 3),
                            circleWidget(
                                rbc, 21, Assets.timer36Red, Colors.white, () {
                              rbc.activeSingleBet(21, rbc.betValue, context);
                            }, top: 2, bottom: 3),
                            circleWidget(
                                rbc, 18, Assets.timer36Red, Colors.white, () {
                              rbc.activeSingleBet(18, rbc.betValue, context);
                            }, top: 2, bottom: 3),
                            circleWidget(
                                rbc, 15, Assets.timer36Black, Colors.white, () {
                              rbc.activeSingleBet(15, rbc.betValue, context);
                            }, top: 2, bottom: 3),
                            circleWidget(
                                rbc, 12, Assets.timer36Red, Colors.white, () {
                              rbc.activeSingleBet(12, rbc.betValue, context);
                            }, top: 2, bottom: 3),
                            circleWidget(
                                rbc, 9, Assets.timer36Red, Colors.white, () {
                              rbc.activeSingleBet(9, rbc.betValue, context);
                            }, top: 2, bottom: 3),
                            circleWidget(
                                rbc, 6, Assets.timer36Black, Colors.white, () {
                              rbc.activeSingleBet(6, rbc.betValue, context);
                            }, top: 2, bottom: 3),
                            circleWidget(
                                rbc, 3, Assets.timer36Red, Colors.white, () {
                              rbc.activeSingleBet(3, rbc.betValue, context);
                            }, top: 2, bottom: 3),
                          ],
                        ),
                      ],
                    ),
                    TempleShape(
                      width: screenWidth * 0.055,
                      height: screenHeight * 0.49,
                      color: Colors.transparent,
                      borderColor: Colors.white,
                      borderWidth: 4,
                      child: circleWidget(
                          rbc, 0, Assets.timer36Green, Colors.transparent, () {
                        rbc.activeSingleBet(0, rbc.betValue, context);
                      }),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenWidth * 0.06,
                      width: screenWidth * 0.06,
                    ),
                    _buildTwelveButton(rbc, 42, "3rd 12", () {
                      rbc.activeSingleBet(42, rbc.betValue, context);
                    }, right: 1, left: 3),
                    _buildTwelveButton(rbc, 41, "2nd 12", () {
                      rbc.activeSingleBet(41, rbc.betValue, context);
                    }, right: 1, left: 1),
                    _buildTwelveButton(rbc, 40, "1st 12", () {
                      rbc.activeSingleBet(40, rbc.betValue, context);
                    }, right: 3, left: 1),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenWidth * 0.06,
                      width: screenWidth * 0.06,
                    ),
                    _buildBetButton(rbc, 43, "19 to 36", () {
                      rbc.activeSingleBet(43, rbc.betValue, context);
                    }, right: 1, left: 3),
                    _buildBetButton(rbc, 44, "ODD", () {
                      rbc.activeSingleBet(44, rbc.betValue, context);
                    }, right: 1, left: 1),
                    _buildColorButton(rbc, 45, const Color(0xffe30000), () {
                      rbc.activeSingleBet(45, rbc.betValue, context);
                    }),
                    _buildColorButton(rbc, 46, Colors.black, () {
                      rbc.activeSingleBet(46, rbc.betValue, context);
                    }),
                    _buildBetButton(rbc, 47, "EVEN", () {
                      rbc.activeSingleBet(47, rbc.betValue, context);
                    }, right: 1, left: 1),
                    _buildBetButton(rbc, 48, "1 to 18", () {
                      rbc.activeSingleBet(48, rbc.betValue, context);
                    }, right: 3, left: 1),
                  ],
                ),
                SizedBox(height: screenWidth * 0.005),
                Padding(
                  padding: EdgeInsets.only(right: screenWidth * 0.23),
                  child: Container(
                    height: screenWidth * 0.055,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        border: Border(
                            top: BorderSide(width: 3.5, color: Colors.white),
                            right: BorderSide(width: 3.5, color: Colors.white),
                            left: BorderSide(width: 3.5, color: Colors.white),
                            bottom: BorderSide.none)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(rbc.coinList.length, (index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              rbc.betValue = rbc.coinList[index].value;
                              rbc.resetOne = false;
                            });
                          },
                          child: Container(
                            width: screenWidth * 0.04,
                            height: screenWidth * 0.04,
                            margin: EdgeInsets.only(
                                right: rbc.coinList[index] != rbc.coinList.last
                                    ? 10.0
                                    : 0.0),
                            alignment: Alignment.center,
                            child: Transform(
                              transform: Matrix4.identity()
                                ..setEntry(
                                    3, 2, 0.001) // Adjust the perspective value
                                ..rotateX(0.01 * 140.270)
                                ..rotateY(0.01 * 100.186),
                              alignment: FractionalOffset.center,
                              child: Container(
                                width: screenWidth * 0.035,
                                height: screenWidth * 0.035,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      rbc.betValue == rbc.coinList[index].value
                                          ? Border.all(
                                              color: Colors.yellow, width: 2.0)
                                          : null,
                                  image: DecorationImage(
                                      image:
                                          AssetImage(rbc.coinList[index].image),
                                      fit: BoxFit.fill),
                                ),
                                child: SizedBox(
                                  width: screenWidth * 0.02,
                                  height: screenWidth * 0.02,
                                  child: FittedBox(
                                    child: Text(rbc.coinList[index].viewValue,
                                        style: const TextStyle(
                                            fontFamily: 'lora_variable',
                                            fontWeight: FontWeight.w900)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                )
              ],
            ),
          ),
          //34,31
          coinPositionHo(rbc, 101,
              top: screenWidth * 0.04, left: screenWidth * 0.14),
          //31,28
          coinPositionHo(rbc, 102,
              top: screenWidth * 0.04, left: screenWidth * 0.19),
          //28,25
          coinPositionHo(rbc, 103,
              top: screenWidth * 0.04, left: screenWidth * 0.24),
          //25,22
          coinPositionHo(rbc, 104,
              top: screenWidth * 0.04, left: screenWidth * 0.29),
          //22,19
          coinPositionHo(rbc, 105,
              top: screenWidth * 0.04, left: screenWidth * 0.34),
          //19,16
          coinPositionHo(rbc, 106,
              top: screenWidth * 0.04, left: screenWidth * 0.39),
          //16,13
          coinPositionHo(rbc, 107,
              top: screenWidth * 0.04, left: screenWidth * 0.44),
          //13,10
          coinPositionHo(rbc, 108,
              top: screenWidth * 0.04, left: screenWidth * 0.49),
          //10,7
          coinPositionHo(rbc, 109,
              top: screenWidth * 0.04, left: screenWidth * 0.54),
          //7,4
          coinPositionHo(rbc, 110,
              top: screenWidth * 0.04, left: screenWidth * 0.59),
          //4,1
          coinPositionHo(rbc, 111,
              top: screenWidth * 0.04, left: screenWidth * 0.64),
          //1,0
          coinPositionHo(rbc, 112,
              top: screenWidth * 0.04, left: screenWidth * 0.69),
          //34,35
          coinPositionVe(rbc, 113,
              top: screenHeight * 0.165, left: screenWidth * 0.111),
          //34,35,31,32
          coinPositionVe(rbc, 114,
              top: screenHeight * 0.165,
              left: screenWidth * 0.14,
              isQuadPosition: true),
          //31,32
          coinPositionVe(rbc, 115,
              top: screenHeight * 0.165, left: screenWidth * 0.165),
          //31,32,28,29
          coinPositionVe(rbc, 116,
              top: screenHeight * 0.165,
              left: screenWidth * 0.19,
              isQuadPosition: true),
          //28,29
          coinPositionVe(rbc, 117,
              top: screenWidth * 0.082, left: screenWidth * 0.215),
          //28,29,25,26
          coinPositionVe(rbc, 118,
              top: screenHeight * 0.165,
              left: screenWidth * 0.24,
              isQuadPosition: true),
          //25,26
          coinPositionVe(rbc, 119,
              top: screenHeight * 0.165, left: screenWidth * 0.265),
          //25,26,22,23
          coinPositionVe(rbc, 120,
              top: screenHeight * 0.165,
              left: screenWidth * 0.29,
              isQuadPosition: true),
          //22,23
          coinPositionVe(rbc, 121,
              top: screenWidth * 0.082, left: screenWidth * 0.315),
          //22,23,19,20
          coinPositionVe(rbc, 122,
              top: screenHeight * 0.165,
              left: screenWidth * 0.34,
              isQuadPosition: true),
          //19,20
          coinPositionVe(rbc, 123,
              top: screenHeight * 0.165, left: screenWidth * 0.365),
          //19,20,16,17
          coinPositionVe(rbc, 124,
              top: screenHeight * 0.165,
              left: screenWidth * 0.39,
              isQuadPosition: true),
          //16,17
          coinPositionVe(rbc, 125,
              top: screenHeight * 0.165, left: screenWidth * 0.415),
          //16,17,13,14
          coinPositionVe(rbc, 126,
              top: screenHeight * 0.165,
              left: screenWidth * 0.44,
              isQuadPosition: true),
          //13,14
          coinPositionVe(rbc, 127,
              top: screenHeight * 0.165, left: screenWidth * 0.465),
          //13,14,10,11
          coinPositionVe(rbc, 128,
              top: screenHeight * 0.165,
              left: screenWidth * 0.49,
              isQuadPosition: true),
          //10,11
          coinPositionVe(rbc, 129,
              top: screenHeight * 0.165, left: screenWidth * 0.515),
          //10,11,7,8
          coinPositionVe(rbc, 130,
              top: screenHeight * 0.165,
              left: screenWidth * 0.54,
              isQuadPosition: true),
          //7,8
          coinPositionVe(rbc, 131,
              top: screenHeight * 0.165, left: screenWidth * 0.565),
          //7,8,4,5
          coinPositionVe(rbc, 132,
              top: screenHeight * 0.165,
              left: screenWidth * 0.59,
              isQuadPosition: true),
          //4,5
          coinPositionVe(rbc, 133,
              top: screenHeight * 0.165, left: screenWidth * 0.615),
          //4,5,1,2
          coinPositionVe(rbc, 134,
              top: screenHeight * 0.165,
              left: screenWidth * 0.64,
              isQuadPosition: true),
          //1,2
          coinPositionVe(rbc, 135,
              top: screenHeight * 0.165, left: screenWidth * 0.665),
          //35,32
          coinPositionHo(rbc, 136,
              top: screenWidth * 0.11, left: screenWidth * 0.14),
          //32,29
          coinPositionHo(rbc, 137,
              top: screenWidth * 0.11, left: screenWidth * 0.19),
          //29,26
          coinPositionHo(rbc, 138,
              top: screenWidth * 0.11, left: screenWidth * 0.24),
          //26,23
          coinPositionHo(rbc, 139,
              top: screenWidth * 0.11, left: screenWidth * 0.29),
          //23,20
          coinPositionHo(rbc, 140,
              top: screenWidth * 0.11, left: screenWidth * 0.34),
          //20,17
          coinPositionHo(rbc, 141,
              top: screenWidth * 0.11, left: screenWidth * 0.39),
          //17,14
          coinPositionHo(rbc, 142,
              top: screenWidth * 0.11, left: screenWidth * 0.44),
          //14,11
          coinPositionHo(rbc, 143,
              top: screenWidth * 0.11, left: screenWidth * 0.49),
          //11,8
          coinPositionHo(rbc, 144,
              top: screenWidth * 0.11, left: screenWidth * 0.54),
          //8,5
          coinPositionHo(rbc, 145,
              top: screenWidth * 0.11, left: screenWidth * 0.59),
          //5,2
          coinPositionHo(rbc, 146,
              top: screenWidth * 0.11, left: screenWidth * 0.64),
          //2,0
          coinPositionHo(rbc, 147,
              top: screenWidth * 0.11, left: screenWidth * 0.69),
          //35,36
          coinPositionVe(rbc, 148,
              top: screenHeight * 0.335, left: screenWidth * 0.112),
          //35,36,32,33
          coinPositionVe(rbc, 149,
              top: screenHeight * 0.335,
              left: screenWidth * 0.14,
              isQuadPosition: true),
          //32,33
          coinPositionVe(rbc, 150,
              top: screenHeight * 0.335, left: screenWidth * 0.165),
          //32,33,29,30
          coinPositionVe(rbc, 151,
              top: screenHeight * 0.335,
              left: screenWidth * 0.19,
              isQuadPosition: true),
          //29,30
          coinPositionVe(rbc, 152,
              top: screenHeight * 0.335, left: screenWidth * 0.215),
          //29,30,26,27
          coinPositionVe(rbc, 153,
              top: screenHeight * 0.335,
              left: screenWidth * 0.24,
              isQuadPosition: true),
          //26,27
          coinPositionVe(rbc, 154,
              top: screenHeight * 0.335, left: screenWidth * 0.265),
          //26,27,23,24
          coinPositionVe(rbc, 155,
              top: screenHeight * 0.335,
              left: screenWidth * 0.29,
              isQuadPosition: true),
          //23,24
          coinPositionVe(rbc, 156,
              top: screenHeight * 0.335, left: screenWidth * 0.315),
          //23,24,20,21
          coinPositionVe(rbc, 157,
              top: screenHeight * 0.335,
              left: screenWidth * 0.34,
              isQuadPosition: true),
          //20,21
          coinPositionVe(rbc, 158,
              top: screenHeight * 0.335, left: screenWidth * 0.365),
          //20,21,17,18
          coinPositionVe(rbc, 159,
              top: screenHeight * 0.335,
              left: screenWidth * 0.39,
              isQuadPosition: true),
          //17,18
          coinPositionVe(rbc, 160,
              top: screenHeight * 0.335, left: screenWidth * 0.415),
          //17,18,14,15
          coinPositionVe(rbc, 161,
              top: screenHeight * 0.335,
              left: screenWidth * 0.44,
              isQuadPosition: true),
          //14,15
          coinPositionVe(rbc, 162,
              top: screenHeight * 0.335, left: screenWidth * 0.465),
          //14,15,11,12
          coinPositionVe(rbc, 163,
              top: screenHeight * 0.335,
              left: screenWidth * 0.49,
              isQuadPosition: true),
          //11,12
          coinPositionVe(rbc, 164,
              top: screenWidth * 0.165, left: screenWidth * 0.515),
          //11,12,8,9
          coinPositionVe(rbc, 165,
              top: screenHeight * 0.335,
              left: screenWidth * 0.54,
              isQuadPosition: true),
          //8,9
          coinPositionVe(rbc, 166,
              top: screenWidth * 0.165, left: screenWidth * 0.565),
          //8,9,5,6
          coinPositionVe(rbc, 167,
              top: screenHeight * 0.335,
              left: screenWidth * 0.59,
              isQuadPosition: true),
          //5,6
          coinPositionVe(rbc, 168,
              top: screenWidth * 0.165, left: screenWidth * 0.615),
          //5,6,2,3
          coinPositionVe(rbc, 169,
              top: screenHeight * 0.335,
              left: screenWidth * 0.64,
              isQuadPosition: true),
          //2,3
          coinPositionVe(rbc, 170,
              top: screenHeight * 0.335, left: screenWidth * 0.665),
          //36,33
          coinPositionHo(rbc, 171,
              top: screenWidth * 0.19, left: screenWidth * 0.14),
          //33,30
          coinPositionHo(rbc, 172,
              top: screenWidth * 0.19, left: screenWidth * 0.19),
          //30,27
          coinPositionHo(rbc, 173,
              top: screenWidth * 0.19, left: screenWidth * 0.24),
          //27,24
          coinPositionHo(rbc, 174,
              top: screenWidth * 0.19, left: screenWidth * 0.29),
          //24,21
          coinPositionHo(rbc, 175,
              top: screenWidth * 0.19, left: screenWidth * 0.34),
          //21,18
          coinPositionHo(rbc, 176,
              top: screenWidth * 0.19, left: screenWidth * 0.39),
          //18,15
          coinPositionHo(rbc, 177,
              top: screenWidth * 0.19, left: screenWidth * 0.44),
          //15,12
          coinPositionHo(rbc, 178,
              top: screenWidth * 0.19, left: screenWidth * 0.49),
          //12,9
          coinPositionHo(rbc, 179,
              top: screenWidth * 0.19, left: screenWidth * 0.54),
          //9,6
          coinPositionHo(rbc, 180,
              top: screenWidth * 0.19, left: screenWidth * 0.59),
          //6,3
          coinPositionHo(rbc, 181,
              top: screenWidth * 0.19, left: screenWidth * 0.64),
          //3,0
          coinPositionHo(rbc, 182,
              top: screenWidth * 0.19, left: screenWidth * 0.69),
          //34,35,36
          coinPositionVe(rbc, 183,
              top: screenHeight * 0.49, left: screenWidth * 0.114),
          //34,35,36,31,32,33
          coinPositionVe(rbc, 184,
              top: screenHeight * 0.49, left: screenWidth * 0.14),
          //31,32,33
          coinPositionVe(rbc, 185,
              top: screenHeight * 0.49, left: screenWidth * 0.165),
          //31,32,33,28,29,30
          coinPositionVe(rbc, 186,
              top: screenHeight * 0.49, left: screenWidth * 0.19),
          //28,29,30
          coinPositionVe(rbc, 187,
              top: screenHeight * 0.49, left: screenWidth * 0.215),
          //28,29,30,25,26,27
          coinPositionVe(rbc, 188,
              top: screenHeight * 0.49, left: screenWidth * 0.24),
          //25,26,27
          coinPositionVe(rbc, 189,
              top: screenHeight * 0.49, left: screenWidth * 0.265),
          //25,26,27,22,23,24
          coinPositionVe(rbc, 190,
              top: screenHeight * 0.49, left: screenWidth * 0.29),
          //22,23,24
          coinPositionVe(rbc, 191,
              top: screenHeight * 0.49, left: screenWidth * 0.315),
          //22,23,24,19,20,21
          coinPositionVe(rbc, 192,
              top: screenHeight * 0.49, left: screenWidth * 0.34),
          //19,20,21
          coinPositionVe(rbc, 193,
              top: screenHeight * 0.49, left: screenWidth * 0.365),
          //19,20,21,16,17,18
          coinPositionVe(rbc, 194,
              top: screenHeight * 0.49, left: screenWidth * 0.39),
          //16,17,18
          coinPositionVe(rbc, 195,
              top: screenHeight * 0.49, left: screenWidth * 0.415),
          //16,17,18,13,14,15
          coinPositionVe(rbc, 196,
              top: screenHeight * 0.49, left: screenWidth * 0.44),
          //13,14,15
          coinPositionVe(rbc, 197,
              top: screenHeight * 0.49, left: screenWidth * 0.465),
          //13,14,15,10,11,12
          coinPositionVe(rbc, 198,
              top: screenHeight * 0.49, left: screenWidth * 0.49),
          //10,11,12
          coinPositionVe(rbc, 199,
              top: screenHeight * 0.49, left: screenWidth * 0.515),
          //10,11,12,7,8,9
          coinPositionVe(rbc, 200,
              top: screenHeight * 0.49, left: screenWidth * 0.54),
          //7,8,9
          coinPositionVe(rbc, 201,
              top: screenHeight * 0.49, left: screenWidth * 0.565),
          //7,8,9,4,5,6
          coinPositionVe(rbc, 202,
              top: screenHeight * 0.49, left: screenWidth * 0.59),
          //4,5,6,
          coinPositionVe(rbc, 203,
              top: screenHeight * 0.49, left: screenWidth * 0.615),
          //4,5,6,1,2,3
          coinPositionVe(rbc, 204,
              top: screenHeight * 0.49, left: screenWidth * 0.64),
          //1,2,3
          coinPositionVe(rbc, 205,
              top: screenHeight * 0.49, left: screenWidth * 0.665),
        ],
      );
    });
  }

  Widget coinPositionHo(Timer36Controller rbc, int number,
      {double? left, double? top, double? right, double? bottom}) {
    return Positioned(
        top: top,
        left: left,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () {
                rbc.activeSingleBet(number, rbc.betValue, context);
              },
              child: Container(
                color: Colors.transparent,
                height: screenWidth * 0.04,
                width: screenWidth * 0.02,
              ),
            ),
            if (rbc.bets.where((e) => e['game_id'] == number).isNotEmpty)
              Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Adjust the perspective value
                  ..rotateX(0.01 * 140.270)
                  ..rotateY(0.01 * 100.186),
                alignment: FractionalOffset.center,
                child: Container(
                  height: screenWidth * 0.025,
                  width: screenWidth * 0.025,
                  alignment: Alignment.center,
                  decoration: getCoinDecoration(number, rbc),
                  child: FittedBox(
                      child: Text(
                    rbc.bets
                        .where((e) => e['game_id'] == number)
                        .first["amount"]
                        .toString(),
                    style: TextStyle(
                        fontSize: rbc.bets
                                    .where((e) => e['game_id'] == number)
                                    .first["amount"]
                                    .toString()
                                    .length ==
                                1
                            ? screenWidth * 0.02
                            : rbc.bets
                                        .where((e) => e['game_id'] == number)
                                        .first["amount"]
                                        .toString()
                                        .length ==
                                    2
                                ? screenWidth * 0.015
                                : screenWidth * 0.008,
                        fontWeight: FontWeight.w600),
                  )),
                ),
              )
          ],
        )
    );
  }

  Widget coinPositionVe(Timer36Controller rbc, int number,
      {double? left,
      double? top,
      double? right,
      double? bottom,
      bool isQuadPosition = false}) {
    return Positioned(
        top: top,
        left: left,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () {
                rbc.activeSingleBet(number, rbc.betValue, context);
              },
              child: Container(
                color: Colors.transparent,
                height: screenWidth * 0.025,
                width: screenWidth * 0.02,
                alignment: Alignment.center,
                child: isQuadPosition
                    ? Container(
                        height: 7,
                        width: 7,
                        decoration: const BoxDecoration(
                            color: Colors.white70, shape: BoxShape.circle))
                    : null,
              ),
            ),
            if (rbc.bets.where((e) => e['game_id'] == number).isNotEmpty)
              Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Adjust the perspective value
                  ..rotateX(0.01 * 140.270)
                  ..rotateY(0.01 * 100.186),
                alignment: FractionalOffset.center,
                child: Container(
                  height: screenWidth * 0.025,
                  width: screenWidth * 0.025,
                  alignment: Alignment.center,
                  decoration: getCoinDecoration(number, rbc),
                  child: FittedBox(
                      child: Text(
                    rbc.bets
                        .where((e) => e['game_id'] == number)
                        .first["amount"]
                        .toString(),
                    style: TextStyle(
                        fontSize: rbc.bets
                                    .where((e) => e['game_id'] == number)
                                    .first["amount"]
                                    .toString()
                                    .length ==
                                1
                            ? screenWidth * 0.02
                            : rbc.bets
                                        .where((e) => e['game_id'] == number)
                                        .first["amount"]
                                        .toString()
                                        .length ==
                                    2
                                ? screenWidth * 0.015
                                : screenWidth * 0.008,
                        fontWeight: FontWeight.w600),
                  )),
                ),
              )
          ],
        ));
  }

  Widget _build2To1Button(Timer36Controller rbc, int number, double top,
      double bottom, VoidCallback onTap) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: screenHeight * 0.165,
            width: screenWidth * 0.06,
            padding: const EdgeInsets.only(top: 3, bottom: 3),
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(width: top, color: Colors.white),
                    right: const BorderSide(width: 3, color: Colors.white),
                    left: const BorderSide(width: 4, color: Colors.white),
                    bottom: BorderSide(width: bottom, color: Colors.white))),
            alignment: Alignment.center,
            child: const RotatedBox(
              quarterTurns: 1,
              child: FittedBox(
                child: Text(
                  "2 to 1",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        if (rbc.bets.where((e) => e['game_id'] == number).isNotEmpty)
          GestureDetector(
            onTap: () {
              rbc.activeSingleBet(number, rbc.betValue, context);
            },
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Adjust the perspective value
                ..rotateX(0.01 * 140.270)
                ..rotateY(0.01 * 100.186),
              alignment: FractionalOffset.center,
              child: Container(
                height: screenWidth * 0.03,
                width: screenWidth * 0.03,
                alignment: Alignment.center,
                decoration: getCoinDecoration(number, rbc),
                child: FittedBox(
                    child: Text(
                  rbc.bets
                      .where((e) => e['game_id'] == number)
                      .first["amount"]
                      .toString(),
                  style: TextStyle(
                      fontSize: rbc.bets
                                  .where((e) => e['game_id'] == number)
                                  .first["amount"]
                                  .toString()
                                  .length ==
                              1
                          ? screenWidth * 0.02
                          : rbc.bets
                                      .where((e) => e['game_id'] == number)
                                      .first["amount"]
                                      .toString()
                                      .length ==
                                  2
                              ? screenWidth * 0.015
                              : screenWidth * 0.01,
                      fontWeight: FontWeight.w600),
                )),
              ),
            ),
          )
      ],
    );
  }

  Widget _buildTwelveButton(
      Timer36Controller rbc, int number, String title, VoidCallback onTap,
      {double right = 0, double left = 0}) {
    return Container(
      height: screenHeight * 0.17,
      width: screenWidth * 0.2,
      decoration: BoxDecoration(
          border: Border(
        right: BorderSide(width: right, color: Colors.white),
        left: BorderSide(width: left, color: Colors.white),
      )),
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.white),
                  borderRadius: BorderRadius.circular(8)),
              child: FittedBox(
                  child: Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 100),
              )),
            ),
          ),
          if (rbc.bets.where((e) => e['game_id'] == number).isNotEmpty)
            GestureDetector(
              onTap: () {
                rbc.activeSingleBet(number, rbc.betValue, context);
              },
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Adjust the perspective value
                  ..rotateX(0.01 * 140.270)
                  ..rotateY(0.01 * 100.186),
                alignment: FractionalOffset.center,
                child: Container(
                  height: screenWidth * 0.035,
                  width: screenWidth * 0.035,
                  alignment: Alignment.center,
                  decoration: getCoinDecoration(number, rbc),
                  child: FittedBox(
                      child: Text(
                    rbc.bets
                        .where((e) => e['game_id'] == number)
                        .first["amount"]
                        .toString(),
                    style: TextStyle(
                        fontSize: rbc.bets
                                    .where((e) => e['game_id'] == number)
                                    .first["amount"]
                                    .toString()
                                    .length ==
                                1
                            ? screenWidth * 0.02
                            : rbc.bets
                                        .where((e) => e['game_id'] == number)
                                        .first["amount"]
                                        .toString()
                                        .length ==
                                    2
                                ? screenWidth * 0.015
                                : screenWidth * 0.01,
                        fontWeight: FontWeight.w600),
                  )),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildBetButton(
      Timer36Controller rbc, int number, String title, VoidCallback onTap,
      {double right = 0, double left = 0}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: screenHeight * 0.17,
            width: screenWidth * 0.1,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border(
                    top: const BorderSide(width: 2, color: Colors.white),
                    right: BorderSide(width: right, color: Colors.white),
                    left: BorderSide(width: left, color: Colors.white),
                    bottom: const BorderSide(width: 3, color: Colors.white))),
            child: FittedBox(
                child: Text(
              title,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
            )),
          ),
        ),
        if (rbc.bets.where((e) => e['game_id'] == number).isNotEmpty)
          GestureDetector(
            onTap: () {
              rbc.activeSingleBet(number, rbc.betValue, context);
            },
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Adjust the perspective value
                ..rotateX(0.01 * 140.270)
                ..rotateY(0.01 * 100.186),
              alignment: FractionalOffset.center,
              child: Container(
                height: screenWidth * 0.035,
                width: screenWidth * 0.035,
                alignment: Alignment.center,
                decoration: getCoinDecoration(number, rbc),
                child: FittedBox(
                    child: Text(
                  rbc.bets
                      .where((e) => e['game_id'] == number)
                      .first["amount"]
                      .toString(),
                  style: TextStyle(
                      fontSize: rbc.bets
                                  .where((e) => e['game_id'] == number)
                                  .first["amount"]
                                  .toString()
                                  .length ==
                              1
                          ? screenWidth * 0.02
                          : rbc.bets
                                      .where((e) => e['game_id'] == number)
                                      .first["amount"]
                                      .toString()
                                      .length ==
                                  2
                              ? screenWidth * 0.015
                              : screenWidth * 0.01,
                      fontWeight: FontWeight.w600),
                )),
              ),
            ),
          )
      ],
    );
  }

  Widget _buildColorButton(
      Timer36Controller rbc, int number, Color color, VoidCallback onTap) {
    return Container(
      height: screenHeight * 0.17,
      width: screenWidth * 0.1,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(width: 2, color: Colors.white),
              right: BorderSide(width: 1, color: Colors.white),
              left: BorderSide(width: 1, color: Colors.white),
              bottom: BorderSide(width: 3, color: Colors.white))),
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: onTap,
            child: DiamondShape(
              width: screenWidth * 0.08,
              height: screenWidth * 0.06,
              color: color,
              borderColor: const Color(0xff000000),
              borderWidth: 0.7,
            ),
          ),
          if (rbc.bets.where((e) => e['game_id'] == number).isNotEmpty)
            GestureDetector(
              onTap: () {
                rbc.activeSingleBet(number, rbc.betValue, context);
              },
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Adjust the perspective value
                  ..rotateX(0.01 * 140.270)
                  ..rotateY(0.01 * 100.186),
                alignment: FractionalOffset.center,
                child: Container(
                  height: screenWidth * 0.035,
                  width: screenWidth * 0.035,
                  alignment: Alignment.center,
                  decoration: getCoinDecoration(number, rbc),
                  child: FittedBox(
                      child: Text(
                    rbc.bets
                        .where((e) => e['game_id'] == number)
                        .first["amount"]
                        .toString(),
                    style: TextStyle(
                        fontSize: rbc.bets
                                    .where((e) => e['game_id'] == number)
                                    .first["amount"]
                                    .toString()
                                    .length ==
                                1
                            ? screenWidth * 0.02
                            : rbc.bets
                                        .where((e) => e['game_id'] == number)
                                        .first["amount"]
                                        .toString()
                                        .length ==
                                    2
                                ? screenWidth * 0.015
                                : screenWidth * 0.01,
                        fontWeight: FontWeight.w600),
                  )),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget circleWidget(
    Timer36Controller rbc,
    int number,
    String image,
    Color borderColor,
    VoidCallback onTap, {
    double top = 0,
    double bottom = 0,
  }) {
    return Stack(
      children: [
        Container(
          height: screenHeight * 0.165,
          width: screenWidth * 0.05,
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(width: top, color: borderColor),
                  right: BorderSide(width: 1, color: borderColor),
                  left: BorderSide(width: 1, color: borderColor),
                  bottom: BorderSide(width: bottom, color: borderColor))),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  height: screenHeight * 0.165,
                  width: screenWidth * 0.05,
                  padding: const EdgeInsets.all(2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(image), fit: BoxFit.fill),
                  ),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: FittedBox(
                      child: Text(
                        number.toString(),
                        style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontFamily: 'lato_bold'),
                      ),
                    ),
                  ),
                ),
              ),
              if (rbc.bets.where((e) => e['game_id'] == number).isNotEmpty)
                GestureDetector(
                  onTap: () {
                    rbc.activeSingleBet(number, rbc.betValue, context);
                  },
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // Adjust the perspective value
                      ..rotateX(0.01 * 140.270)
                      ..rotateY(0.01 * 100.186),
                    alignment: FractionalOffset.center,
                    child: Container(
                      height: screenWidth * 0.03,
                      width: screenWidth * 0.03,
                      alignment: Alignment.center,
                      decoration: getCoinDecoration(number, rbc),
                      child: FittedBox(
                        child: Text(
                          rbc.bets
                              .where((e) => e['game_id'] == number)
                              .first["amount"]
                              .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: rbc.bets
                                          .where((e) => e['game_id'] == number)
                                          .first["amount"]
                                          .toString()
                                          .length ==
                                      1
                                  ? screenWidth * 0.02
                                  : rbc.bets
                                              .where(
                                                  (e) => e['game_id'] == number)
                                              .first["amount"]
                                              .toString()
                                              .length ==
                                          2
                                      ? screenWidth * 0.015
                                      : screenWidth * 0.01),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (rbc.showResult[rbc.showData] == number && rbc.indicateResult)
          Transform(
            transform: Matrix4.identity()
              ..setEntry(
                0,
                3,
                0,
              ) // Adjust the perspective value
              ..rotateX(0.01 * 150)
              ..rotateY(0.01 * 100.186),
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(top: screenWidth * 0.015),
              child: Image.asset(
                Assets.timer36ShowResult,
                scale: 4,
              ),
            ),
          ),
      ],
    );
  }
}

BoxDecoration getCoinDecoration(int number, Timer36Controller rbc) {
  try {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              rbc.bets.where((e) => e['game_id'] == number).first['amount'] == 2 ||
                      rbc.bets.where((e) => e['game_id'] == number).first['amount']! <
                          5
                  ? Assets.timer362
                  : rbc.bets.where((e) => e['game_id'] == number).first['amount'] == 5 ||
                          rbc.bets.where((e) => e['game_id'] == number).first['amount']! <
                              10
                      ? Assets.timer365
                      : rbc.bets.where((e) => e['game_id'] == number).first['amount'] == 10 ||
                              rbc.bets
                                      .where((e) => e['game_id'] == number)
                                      .first['amount']! <
                                  50
                          ? Assets.timer362
                          : rbc.bets.where((e) => e['game_id'] == number).first['amount'] == 50 ||
                                  rbc.bets
                                          .where((e) => e['game_id'] == number)
                                          .first['amount']! <
                                      100
                              ? Assets.timer3650
                              : rbc.bets.where((e) => e['game_id'] == number).first['amount'] == 100 ||
                                      rbc.bets.where((e) => e['game_id'] == number).first['amount']! <
                                          500
                                  ? Assets.timer36100
                                  : rbc.bets.where((e) => e['game_id'] == number).first['amount'] == 500 ||
                                          rbc.bets.where((e) => e['game_id'] == number).first['amount']! <
                                              1000
                                      ? Assets.timer36500
                                      : rbc.bets.where((e) => e['game_id'] == number).first['amount'] == 1000 ||
                                              rbc.bets.where((e) => e['game_id'] == number).first['amount']! < 3000
                                          ? Assets.timer361000
                                          : Assets.timer363000,
            ),
            fit: BoxFit.fill),
        shape: BoxShape.circle);
  } catch (e) {
    return const BoxDecoration(
      shape: BoxShape.circle,
    );
  }
}
