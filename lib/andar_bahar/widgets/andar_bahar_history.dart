import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:super_star/andar_bahar/view_model/andar_bahar_history_view_model.dart';
import 'package:super_star/generated/assets.dart';

import '../../../main.dart';

class AndarBaharHistory extends StatefulWidget {
  const AndarBaharHistory({
    super.key,
  });

  @override
  State<AndarBaharHistory> createState() => _AndarBaharHistoryState();
}

class _AndarBaharHistoryState extends State<AndarBaharHistory> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final andarBaharHistoryViewModel =
          Provider.of<AndarBaharHistoryViewModel>(context, listen: false);
      andarBaharHistoryViewModel.andarBaharHistoryApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final andarBaharHistoryViewModel =
        Provider.of<AndarBaharHistoryViewModel>(context);
    return AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          height: screenHeight * 0.65,
          width: screenWidth * 0.8,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Assets.andarBBgPicture), fit: BoxFit.fill)),
          child: Column(
            children: [
              Container(
                height: 25,
                padding: const EdgeInsets.only(left: 10, right: 10),
                width: screenWidth * 0.8,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(10),
                )),
                child: Row(
                  children: [
                    SizedBox(
                      height: 25,
                      width: screenWidth * 0.5,
                      child: const Text(
                        textAlign: TextAlign.center,
                        'Game History',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            padding: const EdgeInsets.only(bottom: 5),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: List.generate(
                    andarBaharHistoryViewModel.historyList.length, (index) {
                  final resData = andarBaharHistoryViewModel.historyList[index];
                  if (index == 0) {
                    return Row(
                      children: [
                        Container(
                            width: screenWidth * 0.2,
                            alignment: Alignment.center,
                            child: textWidget(
                                text: 'Game No',
                                fontWeight: FontWeight.w900,
                                fontSize: 16)),
                        Container(
                            width: screenWidth * 0.2,
                            alignment: Alignment.center,
                            child: textWidget(
                                text: 'Bet Amount',
                                fontWeight: FontWeight.w900,
                                fontSize: 16)),
                        Container(
                            width: screenWidth * 0.2,
                            alignment: Alignment.center,
                            child: textWidget(
                                text: 'Win Amount',
                                fontWeight: FontWeight.w900,
                                fontSize: 16)),
                        Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                child: textWidget(
                                    text: 'Status',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16))),
                      ],
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          width: screenWidth * 0.2,
                          alignment: Alignment.center,
                          child: textWidget(text: resData.periodNo.toString())),
                      Container(
                          width: screenWidth * 0.2,
                          alignment: Alignment.center,
                          child: textWidget(
                              text: "₹${resData.amount}".toString(),
                            color:
                            resData.status == 1 ? Colors.green : Colors.white,
                          ),
                      ),
                      Container(
                          width: screenWidth * 0.2,
                          alignment: Alignment.center,
                          child: textWidget(
                            text: "₹${resData.winAmount}".toString(),
                            color:
                                resData.status == 1 ? Colors.green : Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        child: textWidget(
                          text: resData.status == 1 ? "Win" : "Lose",
                          color:
                              resData.status == 1 ? Colors.green : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        // if(resData.status==1){}
                      )),
                    ],
                  );
                }),
              ),
            ],
          ),
        ));
  }
}

Widget textWidget({
  required String text,
  double? fontSize,
  String? fontFamily,
  FontWeight fontWeight = FontWeight.bold,
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
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight,
      color: color,
    ),
  );
}
