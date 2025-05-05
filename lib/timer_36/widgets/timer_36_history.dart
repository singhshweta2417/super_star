import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/helper/response/status.dart';
import 'package:super_star/main.dart';
import 'package:super_star/timer_36/view_model/timer_36_g_h_view_model.dart';

import '../../spin_to_win/view_model/profile_view_model.dart';

class Timer36History extends StatefulWidget {
  const Timer36History({super.key});

  @override
  State<Timer36History> createState() => _Timer36HistoryState();
}

class _Timer36HistoryState extends State<Timer36History> {
  Timer36GHViewModel timer36GHViewModel = Timer36GHViewModel();
  @override
  void initState() {
    super.initState();
    timer36GHViewModel.timer36GHApi(context);
  }

  @override
  Widget build(BuildContext context) {
    final profileData = Provider.of<ProfileViewModel>(context);
    return SizedBox(
      width: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: screenHeight * 0.07,
            padding: const EdgeInsets.only(right: 5, left: 5),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
              color: Color(0xffabc4e0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Game History',
                  style: TextStyle(color: Color(0xff58206f)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: screenHeight * 0.04,
                    width: screenWidth * 0.05,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(Assets.timer36Cancel),
                            fit: BoxFit.fill)),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black.withValues(alpha: 0.8)),
                  ),
                  child: Column(
                    children: [
                      firstTable("GREEN 36 TIMER"),
                      firstTable(profileData.userName),
                      firstTable('${profileData.balance}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ChangeNotifierProvider<Timer36GHViewModel>(
            create: (BuildContext context) => timer36GHViewModel,
            child: Consumer<Timer36GHViewModel>(
              builder: (context, value, _) {
                switch (value.timer36GHList.status) {
                  case Status.LOADING:
                    return Container();
                  case Status.ERROR:
                    return Container(
                        height: screenWidth * 0.3,
                        width: screenWidth * 0.6,
                        alignment: Alignment.center,
                        child: textWidget(
                            textAlign: TextAlign.center,
                            text: value.timer36GHList.message.toString(),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey));
                  case Status.COMPLETED:
                    if (value.timer36GHList.data!.data!.isNotEmpty) {
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                              margin: const EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black.withValues(alpha: 0.5)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildDualBorderCell(
                                          'NO.', screenWidth * 0.06,
                                          isHeader: true),
                                      _buildDualBorderCell(
                                          'Hand ID', screenWidth * 0.16,
                                          isHeader: true),
                                      _buildDualBorderCell(
                                          'Ball Position', screenWidth * 0.16,
                                          isHeader: true),
                                      _buildDualBorderCell(
                                          'Play', screenWidth * 0.16,
                                          isHeader: true),
                                      _buildDualBorderCell(
                                          'Won', screenWidth * 0.16,
                                          isHeader: true),
                                    ],
                                  ),
                                  Column(
                                    children: List.generate(
                                        value.timer36GHList.data!.data!.length,
                                        (index) {
                                      final resData = value
                                          .timer36GHList.data!.data![index];
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildDualBorderCell(
                                              (index + 1).toString(),
                                              screenWidth * 0.06),
                                          _buildDualBorderCell(
                                              resData.gamesNo.toString(),
                                              screenWidth * 0.16),
                                          _buildDualBorderCell(
                                              resData.number.toString(),
                                              screenWidth * 0.16),
                                          _buildDualBorderCell(
                                              resData.amount ?? '',
                                              screenWidth * 0.16),
                                          _buildDualBorderCell(
                                              resData.winAmount ?? '',
                                              screenWidth * 0.16),
                                        ],
                                      );
                                    }),
                                  )
                                ],
                              )),
                        ),
                      );
                    } else {
                      return Container(
                        alignment: Alignment.center,
                        child: textWidget(
                            text: 'No data available',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey),
                      );
                    }
                  case null:
                }
                return Container();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget firstTable(String title) {
    return Container(
      alignment: Alignment.center,
      height: screenHeight * 0.05,
      width: screenWidth * 0.2,
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.5),
      ),
      child: Text(
        title,
        style: const TextStyle(
            fontFamily: 'roboto_light',
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 12),
      ),
    );
  }

  Widget _buildDualBorderCell(String text, double width,
      {bool isHeader = false}) {
    return Container(
      height: screenHeight * 0.05,
      width: width,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      padding: const EdgeInsets.all(2.0),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontFamily: isHeader ? 'lora_bold' : 'roboto'),
      ),
    );
  }
}

class GameHistory {
  final int id;
  final int handId;
  final int result;
  final int? playAmount;
  final int? wonAmount;

  GameHistory({
    required this.id,
    required this.handId,
    required this.result,
    this.playAmount,
    this.wonAmount,
  });
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
