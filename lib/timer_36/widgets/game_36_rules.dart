
import 'package:flutter/material.dart';

import '../../../generated/assets.dart';
import '../../../main.dart';

class Game36Rules extends StatelessWidget {
  const Game36Rules({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Assets.timer36RulesBg), fit: BoxFit.fill)),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: screenHeight * 0.05,
                  width: screenWidth * 0.12,
                  color: const Color(0xffcd8500),
                  child: const Text(
                    'Back',
                    style: TextStyle(fontFamily: 'lora_bold'),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              height: screenHeight * 0.18,
            ),
            Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.1),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: screenWidth * 0.7,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.white))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "The goal of the Lucky36 Mini Timer game is to make a  gamble on the result of a ball spin around a wheel, which is divided into Lucky36 Timer sections, Each Lucky36 Mini Timer section has a precise number and a specific color. You can play on a particular number being landed on by the ball, or that it will be odd or even, or downfall within a column of figures on the Lucky36 Mini 36 Timer layout.",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.0085,
                              fontFamily: 'lora_semi_bold')),
                      SizedBox(height: screenHeight * 0.02),
                      Text("Payouts:",
                          style: TextStyle(
                              color: const Color(0xffde8e00),
                              fontSize: screenWidth * 0.015,
                              fontFamily: 'lora_semi_bold')),
                      SizedBox(height: screenHeight * 0.01),
                      SizedBox(
                        width: screenWidth * 0.38,
                        child: Table(
                          border: TableBorder.all(color: Colors.white),
                          columnWidths: {
                            0: FixedColumnWidth(screenWidth *
                                0.25), // Adjust the width as needed
                            1: FixedColumnWidth(screenWidth *
                                0.01), // Adjust the width as needed
                          },
                          children: [
                            TableRow(children: [
                              Center(
                                  child: Text(
                                    'Type',
                                    style: TextStyle(
                                        color: const Color(0xffde8e00),
                                        fontSize: screenWidth * 0.015,
                                        fontFamily: 'lora_semi_bold'),
                                  )),
                              Center(
                                  child: Text('Payout',
                                      style: TextStyle(
                                          color: const Color(0xffde8e00),
                                          fontSize: screenWidth * 0.015,
                                          fontFamily: 'lora_semi_bold'))),
                            ]),
                            tableData(
                                '10 placed on a number only, called a straight-up play, player get',
                                '350'),
                            tableData(
                                '10 placed in between Two numbers, called split play, player gets',
                                '175'),
                            tableData(
                                '10 placed in between Three-numbers called street play, player gets',
                                '116.60'),
                            tableData(
                                '10 placed in between four-numbers, called corner play,player gets',
                                '87.50'),
                            tableData(
                                '10 placed on the outside dozen or column, player gets',
                                '30'),
                            tableData('10 placed on Six-numbers, players gets',
                                '58.30'),
                            tableData(
                                '10 placed on Even/odd or red/black, player gets',
                                '58.30'),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                          "There are 2 categories of Lucky36 Mini Timer Play that you can put, and you may do so in whatever combination or arrangement you wish.\nThese two types of Lucky36 Mini Timer play include:",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.008,
                              fontFamily: 'lora_semi_bold')),
                      SizedBox(height: screenHeight * 0.02),
                      Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: screenWidth * 0.66,
                          child: Text(
                              "Lucky36 Mini Timer inside play- Lucky36 Mini Timer inside play are the figures on the internal area of the Lucky36  Mini Timer table layout, where you play for each particular number.",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.008,
                                  fontFamily: 'lora_semi_bold')),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: screenWidth * 0.66,
                          child: Text(
                              "Lucky36 Mini Timer outside play- Around the outside of the board lie a figure of other playing alternatives, and those are collectively referred to as Lucky36 Mini Timer outside play.",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.008,
                                  fontFamily: 'lora_semi_bold')),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                          "The winners are those play that are on or around the number that comes up. Also the play on the outside of the layout win if the winning number is represented",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.008,
                              fontFamily: 'lora_semi_bold')),
                      SizedBox(height: screenHeight * 0.01),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow tableData(String title, String subTitle) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(2),
        child: Text(title,
            style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.009,
                fontFamily: 'lora_semi_bold')),
      ),
      Padding(
        padding: const EdgeInsets.all(2),
        child: Text(subTitle,
            style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.009,
                fontFamily: 'lora_semi_bold')),
      ),
    ]);
  }
}