import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:super_star/main.dart';

import '../../../generated/assets.dart';
import '../controller/spin_controller.dart';
import '../view_model/spin_history_view_model.dart';

class InfoSpinDialog extends StatefulWidget {
  const InfoSpinDialog({
    super.key,
  });

  @override
  State<InfoSpinDialog> createState() => _InfoSpinDialogState();
}

class _InfoSpinDialogState extends State<InfoSpinDialog> {
  bool selectedBtn = true;
  @override
  void initState() {
    final spinHistoryViewModel =
        Provider.of<SpinHistoryViewModel>(context, listen: false);
    spinHistoryViewModel.spinHistoryApi(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpinController>(builder: (context, stc, child) {
      return Stack(
        children: [
          Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.spinRuleBg),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedBtn = true;
                          });
                        },
                        child: Container(
                          height: screenHeight * 0.11,
                          width: screenWidth * 0.15,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width: 2, color: const Color(0xffc89539)),
                              color: selectedBtn
                                  ? const Color(0xffb33a39)
                                  : const Color(0xff614532)),
                          child: const Text(
                            'RULES',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xfffffbfb),
                                fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedBtn = false;
                          });
                        },
                        child: Container(
                          height: screenHeight * 0.11,
                          width: screenWidth * 0.25,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width: 2, color: const Color(0xffc89539)),
                              color: !selectedBtn
                                  ? const Color(0xffb33a39)
                                  : const Color(0xff614532)),
                          child: const Text(
                            'GAME HISTORY',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xffd9c1a4),
                                fontSize: 20),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        right: 10,left: 10
                      ),
                      child: selectedBtn
                          ? const SpinToWinRules()
                          : const SpinToWinHistory(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  if (stc.isDialogOpen) {
                    stc.setIsDialogOpen(false);
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  height: screenHeight * 0.08,
                  width: screenWidth * 0.08,
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.spinCancelSpinBg),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ))
        ],
      );
    });
  }
}

class SpinToWinRules extends StatelessWidget {
  const SpinToWinRules({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 5),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Game Play',
              style: TextStyle(
                  color: Color(0xff342b1d),
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            const Text(
              'Spin2win pro timer is a very simple game with one wheel rotating in clockwise direction.',
              style: TextStyle(
                  color: Color(0xff342b1d),
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
            SizedBox(
              height: screenHeight * 0.04,
            ),
            const Text(
              'The Wheel has numbers 0-9 randomly placed at intervals. Wheels come to halt and the result is \ndisplayed and payout is calculated.',
              style: TextStyle(
                  color: Color(0xff342b1d),
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Align(
              child: Container(
                height: screenHeight * 0.6,
                width: screenWidth * 0.3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Assets.spinRuleWheelBg),
                      fit: BoxFit.fill),
                ),
              ),
            ),
            const Text(
              'Singles play can be placed between 0-9',
              style: TextStyle(
                  color: Color(0xff342b1d),
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
            const Text(
              'Play Limit',
              style: TextStyle(
                  color: Color(0xff342b1d),
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              width: screenWidth * 0.7,
              child: Table(
                border: TableBorder.all(color: const Color(0xff9b5f17)),
                columnWidths: {
                  0: FixedColumnWidth(
                      screenWidth * 0.1), // Adjust the width as needed
                  1: FixedColumnWidth(screenWidth * 0.13),
                  2: FixedColumnWidth(
                      screenWidth * 0.0005), // Adjust the width as needed
                },
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Text(
                        'Play',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: const Color(0xff322c14),
                            fontSize: screenWidth * 0.018,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'roboto_lite'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Text('Minimum Play',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: const Color(0xff322c14),
                              fontSize: screenWidth * 0.018,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'roboto_lite')),
                    ),
                    Text('Maximum Play',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: const Color(0xff322c14),
                            fontSize: screenWidth * 0.018,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'roboto_lite')),
                  ]),
                  tableData('Singles Play', '5', '100000'),
                ],
              ),
            ),
            const Text(
              'Game Play',
              style: TextStyle(
                  color: Color(0xff342b1d),
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            SizedBox(
              width: screenWidth * 0.7,
              child: Table(
                border: TableBorder.all(color: const Color(0xff9b5f17)),
                columnWidths: {
                  0: FixedColumnWidth(
                      screenWidth * 0.1), // Adjust the width as needed
                  1: FixedColumnWidth(screenWidth * 0.13),
                  // Adjust the width as needed
                },
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Text(
                        'Type',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: const Color(0xff322c14),
                            fontSize: screenWidth * 0.018,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'roboto_lite'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Text('Payout',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: const Color(0xff322c14),
                              fontSize: screenWidth * 0.018,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'roboto_lite')),
                    ),
                  ]),
                  tableDataTwo(
                      'Play 10 chips on a single number and if that number appears once then the player gets.',
                      '90'),
                  tableDataTwo(
                      'Play 10 chips on a single number and if that number appears once with 2X multiplier then the player gets.',
                      '180'),
                  tableDataTwo(
                      'Play 10 chips on a single number and if that number appears once with 3X multiplier then the player gets.',
                      '270'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow tableData(String value, String wheel, String payout) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Text(value,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color(0xff322c14),
                fontSize: screenWidth * 0.017,
                fontFamily: 'roboto_lite')),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Text(wheel,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color(0xff322c14),
                fontSize: screenWidth * 0.017,
                fontFamily: 'roboto_lite')),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Text(payout,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color(0xff322c14),
                fontSize: screenWidth * 0.017,
                fontFamily: 'roboto_lite')),
      ),
    ]);
  }

  TableRow tableDataTwo(
    String value,
    String wheel,
  ) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(value,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: const Color(0xff322c14),
                fontSize: screenWidth * 0.017,
                fontFamily: 'roboto_lite')),
      ),
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(wheel,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color(0xff322c14),
                fontSize: screenWidth * 0.017,
                fontFamily: 'roboto_lite')),
      ),
    ]);
  }
}

class SpinToWinHistory extends StatelessWidget {
  const SpinToWinHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final spinHistoryViewModel = Provider.of<SpinHistoryViewModel>(context);
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 5),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                spinHistoryViewModel.spinHistoryModel!.data!.length + 1,
                (index) {
              if (index == 0) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      commonWidget('SR.NO', screenHeight * 0.2),
                      commonWidget('GAME REF NO', screenHeight * 0.45),
                      commonWidget('PLAY', screenHeight * 0.2),
                      commonWidget('WIN', screenHeight * 0.2),
                    ]);
              }
              final resData =
                  spinHistoryViewModel.spinHistoryModel!.data![index - 1];
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    commonWidget(index.toString(), screenHeight * 0.2,
                        fotSize: 20
                    ),
                    commonWidget('${resData.periodNo}', screenHeight * 0.45,
                        fotSize: 20
                    ),
                    commonWidget('${resData.amount}', screenHeight * 0.2,
                        fotSize: 20
                    ),
                    commonWidget('${resData.winAmount}', screenHeight * 0.2,
                        fotSize: 20
                    ),
                  ]); // Replace with your actual widget
            }),
          ),
          const Divider(color: Colors.black),
          const Text(
            'TOTAL',
            style: TextStyle(fontFamily: 'roboto_bl', fontSize: 25),
          )
        ],
      ),
    );
  }

  Widget commonWidget(String title, double width, {double? fotSize}) {
    return Container(
        alignment: Alignment.center,
        width: width,
        child: Text(
          title,
          style: TextStyle(
              fontFamily: fotSize == null ? 'roboto_bl' : 'roboto',
              fontSize: fotSize ?? 25,
            fontWeight: fotSize != null ?FontWeight.w600:null
          ),
        ));
  }
}
