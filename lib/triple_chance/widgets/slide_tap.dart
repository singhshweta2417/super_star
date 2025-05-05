import 'package:flutter/material.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/main.dart';
import 'package:super_star/res/app_constant.dart';


class SlideTap extends StatelessWidget {
  const SlideTap({
    super.key,
    required this.title,
    required this.play,
    required this.win,
    required this.reversIcon,
    required this.onTap,
  });

  final String title;
  final String play;
  final String win;
  final bool reversIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: screenHeight,
          width: screenWidth * 0.08,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Assets.tripleChanceTSlideBgNew),
                  fit: BoxFit.fill)),
          child: RotatedBox(
              quarterTurns: 1,
              child: Row(children: [
                Container(
                  margin:  EdgeInsets.only(left: screenHeight*0.018),
                  height: screenHeight * 0.08,
                  width: AppConstant.trChSlideConWi,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: const Color(0xff620000),
                  ),
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: Text(
                      'WIN : $win',
                      style:  TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                           fontSize: screenHeight*0.035,
                          fontFamily: 'roboto_lite'),
                    ),
                  ),
                ),
                Container(
                  height: screenHeight * 0.08,
                  width: AppConstant.trChSlideConWi,
                  margin:  EdgeInsets.only(left: screenHeight*0.01),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: const Color(0xff620000),
                  ),
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: Text(
                      'PLAY : $play',
                      style:  TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight*0.035,
                          fontFamily: 'roboto_lite'),
                    ),
                  ),
                ),
                Expanded(
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: Padding(
                      padding:  EdgeInsets.only(left: screenHeight*0.03, right: screenHeight*0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style:  TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: screenHeight*0.026,
                                fontFamily: 'roboto_lite'),
                          ),
                          RotatedBox(
                              quarterTurns: 1,
                              child: !reversIcon
                                  ? Image.asset(
                                Assets.tripleChancePlay,
                                color: Colors.green,
                                scale: AppConstant.trChSlidePlayIcon,
                              )
                                  : RotatedBox(
                                  quarterTurns: 2,
                                  child: Image.asset(
                                    Assets.tripleChancePlay,
                                    color: Colors.yellow,
                                    scale: AppConstant.trChSlidePlayIcon,
                                  ))),
                        ],
                      ),
                    ),
                  ),
                ),
              ]))),
    );
  }
}