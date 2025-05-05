import 'dart:async';

import 'package:flutter/material.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/main.dart';
import 'package:super_star/res/app_constant.dart';

class SpinUtils {
  static OverlayEntry? _overlayImgEntry;
  static bool _isShowingImg = false;

  static void showSpiToast(String title, BuildContext context,
      {int duration = 2}) {
    if (_isShowingImg) {
      _overlayImgEntry?.remove();
    }

    _overlayImgEntry = OverlayEntry(
      builder: (BuildContext context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding:  EdgeInsets.only(left: screenWidth*0.05),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: screenWidth * 0.325,
                height: screenHeight*0.1,
                margin: EdgeInsets.only(left: screenWidth * 0.045,
                    bottom: AppConstant.spinErrorDPosition
                ),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Assets.spinAlertBg), fit: BoxFit.fill)),
                child: Text(
                  title,
                  style:  TextStyle(
                      color: const Color(0xfff9af04),
                    fontSize: AppConstant.spinUsFont
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayImgEntry!);
    _isShowingImg = true;

    _startImgTimer(duration);
  }

  static void _startImgTimer(int duration) {
    Timer(Duration(seconds: duration), () {
      if (_overlayImgEntry != null) {
        _overlayImgEntry!.remove();
        _isShowingImg = false;
      }
    });
  }

  static OverlayEntry? _overlayWinEntry;
  static bool _isShowingWin = false;

  static void showSpiWinToast(String title, BuildContext context,
      {int duration = 3}) {
    if (_isShowingWin) {
      _overlayWinEntry?.remove();
    }

    _overlayWinEntry = OverlayEntry(
      builder: (BuildContext context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 250,
              height: 230,
              margin:  EdgeInsets.only(left: screenWidth * 0.062, bottom: 30),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Assets.spinWinBg), fit: BoxFit.fill)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'roboto_bl',
                      fontSize: 20),
                ),
              ),
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
