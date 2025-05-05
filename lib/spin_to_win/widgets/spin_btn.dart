import 'package:flutter/material.dart';
import 'package:super_star/main.dart';
import 'package:super_star/res/app_constant.dart';


class SpinBtn extends StatelessWidget {
  const SpinBtn({
    super.key,
    required this.title,
    required this.onTap,
    this.color,
  });
  final String title;
  final VoidCallback onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: screenHeight * 0.12,
        width: screenWidth * 0.12,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color ?? const Color(0xffcf0101),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          title,
          style:  TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: AppConstant.spinBtnFont,
            fontFamily: 'roboto_bl'
          ),
        ),
      ),
    );
  }
}
