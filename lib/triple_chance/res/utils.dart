import 'dart:async';
import 'package:flutter/material.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/main.dart';
import '../../spin_to_win/res/stroke_text.dart';


class Utils {
  static OverlayEntry? _overlayWinEntry;
  static bool _isShowingWin = false;

  static void showTrChWinToast(String title, String firstTitle, String secTitle,
      String thirdTitle, BuildContext context,
      {int duration = 10}) {
    if (_isShowingWin) {
      _overlayWinEntry?.remove();
    }

    _overlayWinEntry = OverlayEntry(
      builder: (BuildContext context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.center,
            child: Container(
                width: screenWidth*0.5,
                height: screenHeight*0.45,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Assets.tripleChanceTWinBg),
                        fit: BoxFit.fill)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const StrokeText(
                      text: "YOU HAVE WON",
                      fontSize: 28,
                      strokeWidth: 1,
                      fontWeight: FontWeight.w900,
                      textColor: Color(0xff5c350a),
                    ),
                    Container(
                      height: screenHeight*0.09,
                      width: screenWidth*0.25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff5c350a),
                      ),
                      child: Text(title,style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),),
                    ),
                    Container(
                      height: screenHeight*0.055,
                      width: screenWidth*0.4,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                          color: const Color(0xff5c350a),
                          borderRadius: BorderRadius.circular(10)
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'SINGLE  : ',
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                TextSpan(
                                  text: firstTitle,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'DOUBLE  : ',
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                TextSpan(
                                  text: secTitle,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'TRIPLE  : ',
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                TextSpan(
                                  text: thirdTitle,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayWinEntry!);
    _isShowingWin = true;
    _startWinTimer(duration);
  }

  static void _startWinTimer(int duration) {
    Timer(Duration(seconds: duration), () {
      if (_overlayWinEntry != null) {
        _overlayWinEntry!.remove();
        _isShowingWin = false;
      }
    });
  }
}