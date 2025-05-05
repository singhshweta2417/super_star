
import 'package:flutter/material.dart';
import 'package:super_star/generated/assets.dart';

import '../../../main.dart';

class ExitPopUp extends StatelessWidget {
  final String title;
  final VoidCallback yes;
  final DecorationImage image;
  const ExitPopUp({
    super.key,
    required this.title,
    required this.yes, required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          height: screenHeight * 0.6,
          width: screenWidth * 0.5,
          decoration:  BoxDecoration(
              image: image),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              textWidget(
                  text: title,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  textAlign: TextAlign.center),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: yes,
                      child: Image.asset(Assets.timer36YesBtn, scale: 1.2)),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(Assets.timer36NoBtn, scale: 1.2)),
                ],
              )
            ],
          ),
        ));
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
      fontFamily: fontFamily??'roboto',
      fontSize: fontSize??12,
      fontWeight: fontWeight,
      color:  color,
    ),
  );
}