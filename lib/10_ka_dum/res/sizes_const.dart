import 'package:flutter/material.dart';

class Sizes {
  static double screenHeight = 0.0;
  static double screenWidth = 0.0;
  static double pixelRatio = 0.0;

  static void initSizing(BuildContext context) {
    final size = MediaQuery.of(context).size;
    pixelRatio = View.of(context).devicePixelRatio;
    screenHeight = size.height;
    screenWidth = size.width;
  }

  static double scaleFont(double px) {
    return (px / 390.0) * screenWidth;
  }

  static double fontSize4 = scaleFont(4);
  static double fontSize4P5 = scaleFont(4.5);
  static double fontSize5 = scaleFont(5);
  static double fontSize6 = scaleFont(6);
  static double fontSize8 = scaleFont(8);
  static double fontSize10 = scaleFont(10);
  static double fontSize12 = scaleFont(12);
  static double fontSize14 = scaleFont(14);
  static double fontSize16 = scaleFont(16);
  static double fontSize18 = scaleFont(18);
  static double fontSize20 = scaleFont(20);
  static double fontSize24 = scaleFont(24);
  static double fontSize30 = scaleFont(30);

  static double fontSize(double val){
    return scaleFont(val);
  }

  // SizedBoxes with height and width based on pixelRatio
  static SizedBox spaceH1P5 = SizedBox(height: 1.5 * pixelRatio);
  static SizedBox spaceH3 = SizedBox(height: 3 * pixelRatio);
  static SizedBox spaceH5 = SizedBox(height: 5 * pixelRatio);
  static SizedBox spaceH10 = SizedBox(height: 10 * pixelRatio);
  static SizedBox spaceH15 = SizedBox(height: 15 * pixelRatio);
  static SizedBox spaceH20 = SizedBox(height: 20 * pixelRatio);
  static SizedBox spaceH25 = SizedBox(height: 25 * pixelRatio);
  static SizedBox spaceH30 = SizedBox(height: 30 * pixelRatio);

  static SizedBox spaceW5 = SizedBox(width: 5 * pixelRatio);
  static SizedBox spaceW10 = SizedBox(width: 10 * pixelRatio);
  static SizedBox spaceW15 = SizedBox(width: 15 * pixelRatio);
  static SizedBox spaceW20 = SizedBox(width: 20 * pixelRatio);
  static SizedBox spaceW25 = SizedBox(width: 25 * pixelRatio);
  static SizedBox spaceW30 = SizedBox(width: 30 * pixelRatio);
}
