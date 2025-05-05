import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_star/lucky_card_12/view_model/lucky_12_history_view_model.dart';
import 'package:super_star/lucky_card_12/widgets/lucky_12_btn.dart';
import 'package:super_star/main.dart';
import '../../../generated/assets.dart';

class Lucky12InfoD extends StatefulWidget {
  const Lucky12InfoD({
    super.key,
  });

  @override
  State<Lucky12InfoD> createState() => _Lucky12InfoDState();
}

class _Lucky12InfoDState extends State<Lucky12InfoD> {
  bool selectedBtn = true;
  @override
  void initState() {
    final lucky12HistoryViewModel =
    Provider.of<Lucky12HistoryViewModel>(context, listen: false);
    lucky12HistoryViewModel.lucky12HistoryApi(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: const DecorationImage(
            image: AssetImage(Assets.lucky12InfoBg),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: screenHeight * 0.08,
                  width: screenHeight * 0.08,
                  color: Colors.transparent,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedBtn = true;
                        });
                      },
                      child: Container(
                        height: screenHeight * 0.08,
                        width: screenWidth * 0.18,
                        alignment: Alignment.center,
                        color: const Color(0xff40183a),
                        child: const Text(
                          'GAME HISTORY',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'roboto_bl'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedBtn = false;
                        });
                      },
                      child: Container(
                        height: screenHeight * 0.08,
                        width: screenWidth * 0.2,
                        alignment: Alignment.center,
                        color: const Color(0xff40183a),
                        child: const Text(
                          'REPORT DETAILS',
                          style: TextStyle(
                              fontFamily: 'roboto_bl',
                              color: Color(0xfffffbfb),
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: screenHeight * 0.08,
                    width: screenHeight * 0.08,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Assets.lucky12Close),
                          fit: BoxFit.fill),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Container(
                child: selectedBtn ? const GameHistory() : const ReportDetails(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class GameHistory extends StatefulWidget {
  const GameHistory({super.key});

  @override
  State<GameHistory> createState() => _GameHistoryState();
}

class _GameHistoryState extends State<GameHistory> {

  @override
  Widget build(BuildContext context) {
    final l12hvm = Provider.of<Lucky12HistoryViewModel>(context);
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              commonWidget('S.No', screenHeight * 0.2),
              commonWidget('GAME ID', screenHeight * 0.45),
              commonWidget('PLAY', screenHeight * 0.2),
              commonWidget('WIN', screenHeight * 0.2),
            ]),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: l12hvm.lucky12HistoryModel!=null?List.generate(
              l12hvm.lucky12HistoryModel!.data!.length,
                  (index) {
                return l12hvm.lucky12HistoryModel!.data!.isNotEmpty?Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      commonWidget('${index+1}', screenHeight * 0.2,
                          fotSize: 20
                      ),
                      commonWidget('${l12hvm.lucky12HistoryModel!.data![index].periodNo}', screenHeight * 0.45,
                          fotSize: 20
                      ),
                      commonWidget('${l12hvm.lucky12HistoryModel!.data![index].amount}', screenHeight * 0.2,
                          fotSize: 20
                      ),
                      commonWidget('${l12hvm.lucky12HistoryModel!.data![index].winAmount}', screenHeight * 0.2,
                          fotSize: 20
                      ),
                    ]):Container(); // Replace with your actual widget
              }):[],
        ),
      ],
    );
  }

  Widget commonWidget(String title, double width, {double? fotSize}) {
    return Container(
        alignment: Alignment.center,
        width: width,
        child: Text(
          title,
          style: TextStyle(
              fontFamily: 'roboto',
              fontSize: fotSize ?? 18,
              fontWeight: FontWeight.w600,
              color: Colors.white
          ),
        ));
  }
}

class ReportDetails extends StatefulWidget {
  const ReportDetails({super.key});

  @override
  State<ReportDetails> createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  commonWidget('FROM',screenWidth * 0.08),
                  commonWidget('23/9/2024',screenWidth * 0.08),
                  const SizedBox(width: 10),
                  Image.asset(Assets.lucky12InfoCallIcon,scale: 1.5)
                ],
              ),
              const SizedBox(width: 50),
              Row(
                children: [
                  commonWidget('FROM',screenWidth * 0.08),
                  commonWidget('23/9/2024',screenWidth * 0.08),
                  const SizedBox(width: 10),
                  Image.asset(Assets.lucky12InfoCallIcon,scale: 1.5),
                  const SizedBox(width: 30),
                  Lucky12Btn(
                    title: 'VIEW',
                    fontSize: 10,
                    height: 18,
                    onTap: () {  },
                  )
                ],
              ),

            ]),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              commonWidget('NAME', screenWidth * 0.1),
              commonWidget('PLAY', screenWidth * 0.08),
              commonWidget('WIN', screenWidth * 0.08),
              commonWidget('CLAIM', screenWidth * 0.08),
              commonWidget('UNCLAIMED', screenWidth * 0.08),
              commonWidget('END', screenWidth *  0.08),
              commonWidget('COMM', screenWidth *  0.08),
              commonWidget('NTP', screenWidth * 0.08),
            ]),
      ],
    );
  }

  Widget commonWidget(String title, double width, {double? fotSize}) {
    return Container(
        alignment: Alignment.center,
        // color: Colors.red,
        width: width,
        child: Text(
          title,
          style: TextStyle(
              fontFamily: 'roboto',
              fontSize: fotSize ?? 10,
              fontWeight: FontWeight.w600,
              color: Colors.white
          ),
        ));
  }
}