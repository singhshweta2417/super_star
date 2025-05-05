import 'package:flutter/material.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/res/app_constant.dart';


import '../../../main.dart';

class AndarBaharExit extends StatelessWidget {
  final VoidCallback onTap;
  const AndarBaharExit({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          height: screenHeight * 0.35,
          width: screenWidth * 0.4,
          // padding: const EdgeInsets.fromLTRB(5, 4, 5, 15),
          padding: EdgeInsets.only(top: screenHeight*0.01,bottom: screenHeight*0.03),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Assets.andarBBgHelp), fit: BoxFit.fill)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textWidget(
                  text: 'Andar Bahar',
                  fontWeight: FontWeight.w900,
                  fontSize: AppConstant.anBaExitFont,
                  textAlign: TextAlign.center),
              textWidget(
                  text: 'Are you sure You want to\ngoto Lobby?',
                  fontWeight: FontWeight.w900,
                  fontSize: AppConstant.anBaExitFont,
                  textAlign: TextAlign.center),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap:onTap,
                      child: Container(
                        height: 30,
                        width: 60,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(Assets.andarBBetCountBg), fit: BoxFit.fill)),
                        child: const Text(
                          'Yes',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900)
                        ),
                      )),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 30,
                        width: 60,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(Assets.andarBBetCountBg),
                                fit: BoxFit.fill)),
                        child: const Text('No',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900)),
                      )),
                ],
              )
            ],
          ),
        )
    );
  }
}

Widget textWidget({
  required String text,
  double? fontSize,
  String? fontFamily,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.white,
  TextAlign textAlign = TextAlign.start,
  int? maxLines,
}) {
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
    style: TextStyle(
      fontFamily: fontFamily ?? 'roboto',
      fontSize: fontSize ?? 12,
      fontWeight: fontWeight,
      color: color,
    ),
  );
}
