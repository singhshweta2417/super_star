import 'package:flutter/material.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/main.dart';
import 'package:super_star/res/app_constant.dart';


class Lucky12Btn extends StatelessWidget {
  const Lucky12Btn({
    super.key,
    required this.title,
    required this.onTap,
    this.fontSize,
    this.height,
  });
  final String title;
  final VoidCallback onTap;
  final double? fontSize;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: screenHeight * 0.06,
        width: screenWidth * 0.09,
        padding: EdgeInsets.only(left: 3,right: 3),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Assets.lucky16LBtn), fit: BoxFit.fill),
        ),
        child: Text(
          title,
          style:  TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize??AppConstant.luckyBtnFont),
        ),
      ),
    );
  }
}