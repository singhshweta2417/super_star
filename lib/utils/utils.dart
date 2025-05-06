import 'package:flutter/material.dart';
import 'dart:async';

import '../main.dart';

class Utils {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;

  static void show(String message, BuildContext context,{Color? color}) {
    if (_isShowing) {
      _overlayEntry?.remove();
    }

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: color??Colors.black.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isShowing = true;

    _startTimer();
  }

  static void _startTimer() {
    Timer(const Duration(seconds: 5), () {
      if (_overlayEntry != null && _overlayEntry!.mounted) {
        _overlayEntry?.remove();
        _isShowing = false;
        _overlayEntry = null;
      }
    });
  }


  static OverlayEntry? _overlayImgEntry;
  static bool _isShowingImg = false;

  static void showImage(String imagePath, BuildContext context, {int duration = 2}) {
    if (_isShowingImg) {
      _overlayImgEntry?.remove();
    }

    _overlayImgEntry = OverlayEntry(
      builder: (BuildContext context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: screenWidth,
            height: screenWidth*0.05,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(imagePath),fit: BoxFit.fill)
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
}