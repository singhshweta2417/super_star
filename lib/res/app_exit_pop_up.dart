import 'package:flutter/material.dart';
import '../main.dart';

class AppExitPopUp extends StatelessWidget {
  final VoidCallback yes;
  const AppExitPopUp({
    super.key,
    required this.yes,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.transparent,
        content: SizedBox(
          height: screenHeight * 0.3,
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.2,
                width: screenWidth * 0.3,
                padding: const EdgeInsets.fromLTRB(10, 13, 10, 10),
                color: Colors.black,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Confirmation',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.w900)),
                    FittedBox(
                      child: Text('Are you sure you want exit this app?',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'roboto',
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: screenWidth * 0.3,
                  color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: yes,
                        child: Container(
                          alignment: Alignment.center,
                          width: screenWidth * 0.13,
                          height: screenHeight * 0.07,
                          color: Colors.white,
                          child: const Text('Yes'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: screenWidth * 0.13,
                          height: screenHeight * 0.07,
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: const Text('No'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
})
{
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