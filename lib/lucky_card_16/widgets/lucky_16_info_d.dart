import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:super_star/lucky_card_16/controller/lucky_16_controller.dart';
import 'package:super_star/lucky_card_16/view_model/lucky_16_history_view_model.dart';
import 'package:super_star/lucky_card_16/widgets/lucky_16_btn.dart';
import 'package:super_star/main.dart';
import 'package:super_star/utils/utils.dart';
import '../../../generated/assets.dart';
import '../../spin_to_win/view_model/profile_view_model.dart'
    show ProfileViewModel;

class Lucky16InfoD extends StatefulWidget {
  const Lucky16InfoD({super.key});

  @override
  State<Lucky16InfoD> createState() => _Lucky16InfoDState();
}

class _Lucky16InfoDState extends State<Lucky16InfoD> {
  int selectedBtn = 1;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lucky16HistoryViewModel = Provider.of<Lucky16HistoryViewModel>(
        context,
        listen: false,
      );
      lucky16HistoryViewModel.lucky16HistoryApi(context);
      lucky16HistoryViewModel.lucky16TodayResultApi();
      lucky16HistoryViewModel.lucky16GameReportApi(
        DateFormat(
          'yyyy-MM-dd',
        ).format(DateTime.now().subtract(Duration(days: 2))),
        DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lucky16History = Provider.of<Lucky16HistoryViewModel>(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
        decoration: BoxDecoration(
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
                          selectedBtn = 1;
                        });
                      },
                      child: Container(
                        height: screenHeight * 0.08,
                        width: screenWidth * 0.18,
                        alignment: Alignment.center,
                        color:
                            selectedBtn == 1
                                ? Color(0xff910401)
                                : const Color(0xff40183a),
                        child: const Text(
                          'GAME HISTORY',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'roboto_bl',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedBtn = 2;
                        });
                      },
                      child: Container(
                        height: screenHeight * 0.08,
                        width: screenWidth * 0.2,
                        alignment: Alignment.center,
                        color:
                            selectedBtn == 2
                                ? Color(0xff910401)
                                : const Color(0xff40183a),
                        child: const Text(
                          "Today's Result",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,

                            fontFamily: 'roboto_bl',
                            color: Color(0xfffffbfb),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedBtn = 3;
                        });
                      },
                      child: Container(
                        height: screenHeight * 0.08,
                        width: screenWidth * 0.2,
                        alignment: Alignment.center,
                        color:
                            selectedBtn == 3
                                ? Color(0xff910401)
                                : const Color(0xff40183a),
                        child: const Text(
                          "REPORT DETAILS",
                          style: TextStyle(
                            fontFamily: 'roboto_bl',
                            color: Color(0xfffffbfb),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                GestureDetector(
                  onTap: () {
                    lucky16History.clearList();
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: screenHeight * 0.08,
                    width: screenHeight * 0.08,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.lucky12Close),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Container(
                child:
                    selectedBtn == 3
                        ? ReportDetails()
                        : selectedBtn == 1
                        ? const GameHistory()
                        : const TodayResultHistory(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodayResultHistory extends StatefulWidget {
  const TodayResultHistory({super.key});

  @override
  State<TodayResultHistory> createState() => _TodayResultHistoryState();
}

class _TodayResultHistoryState extends State<TodayResultHistory> {
  @override
  Widget build(BuildContext context) {
    final l16hvm = Provider.of<Lucky16HistoryViewModel>(context);
    final l16c = Provider.of<Lucky16Controller>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            commonWidget('S.No', screenHeight * 0.2),
            commonWidget('GAME ID', screenHeight * 0.45),
            commonWidget('TIME', screenHeight * 0.2),
            commonWidget('WIN', screenHeight * 0.2),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  l16hvm.lucky16HistoryModel != null
                      ? List.generate(
                        l16hvm.lucky16TodayResultList!.data!.length,
                        (index) {
                          final firstCard = l16c.cardList.firstWhere(
                            (card) =>
                                card.id ==
                                l16hvm
                                    .lucky16TodayResultList!
                                    .data![index]
                                    .winNumber,
                          );
                          final jackPotImage = l16c.getJackpotForIndex(
                            l16hvm
                                .lucky16TodayResultList!
                                .data![index]
                                .jackpot!,
                          );
                          return l16hvm.lucky16TodayResultList!.data!.isNotEmpty
                              ? Container(
                                padding: EdgeInsets.only(bottom: 5, top: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    commonWidget(
                                      '${index + 1}',
                                      screenHeight * 0.2,
                                      fotSize: 20,
                                    ),
                                    commonWidget(
                                      '${l16hvm.lucky16TodayResultList!.data![index].periodNo}',
                                      screenHeight * 0.45,
                                      fotSize: 20,
                                    ),
                                    commonWidget(
                                      l16hvm
                                          .lucky16TodayResultList!
                                          .data![index]
                                          .time!
                                          .substring(11, 16),
                                      screenHeight * 0.2,
                                      fotSize: 20,
                                    ),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.asset(
                                          firstCard.icon!,
                                          width: screenHeight * 0.2,
                                          height: 30,
                                        ),
                                        if (l16hvm
                                                .lucky16TodayResultList!
                                                .data![index]
                                                .jackpot! >
                                            1)
                                          Positioned(
                                            left: screenHeight * 0.13,
                                            child: Image.asset(
                                              jackPotImage!,
                                              width: 30,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                              : Container();
                        },
                      )
                      : [],
            ),
          ),
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
          color: Colors.white,
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
    final l16hvm = Provider.of<Lucky16HistoryViewModel>(context);
    final l16c = Provider.of<Lucky16Controller>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            commonWidget('S.No', screenHeight * 0.2),
            commonWidget('GAME ID', screenHeight * 0.45),
            commonWidget('PLAY', screenHeight * 0.2),
            commonWidget('WIN', screenHeight * 0.2),
            // commonWidget('WIN CARD', screenHeight * 0.2),
            commonWidget('Preview', screenHeight * 0.2),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  l16hvm.lucky16HistoryModel != null
                      ? List.generate(l16hvm.lucky16HistoryModel!.data!.length, (
                        index,
                      ) {
                        l16c.cardList.firstWhere(
                          (card) =>
                              card.id ==
                              l16hvm
                                  .lucky16TodayResultList
                                  ?.data![index]
                                  .winNumber,
                        );
                        return l16hvm.lucky16HistoryModel!.data!.isNotEmpty
                            ? Container(
                              padding: EdgeInsets.only(top: 3, bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  commonWidget(
                                    '${index + 1}',
                                    screenHeight * 0.2,
                                    fotSize: 20,
                                  ),
                                  commonWidget(
                                    '${l16hvm.lucky16HistoryModel!.data![index].periodNo}',
                                    screenHeight * 0.45,
                                    fotSize: 20,
                                  ),
                                  commonWidget(
                                    '${l16hvm.lucky16HistoryModel!.data![index].amount}',
                                    screenHeight * 0.2,
                                    fotSize: 20,
                                  ),
                                  commonWidget(
                                    '${l16hvm.lucky16HistoryModel!.data![index].winAmount}',
                                    screenHeight * 0.2,
                                    fotSize: 20,
                                  ),
                                  // Image.asset(
                                  //   firstCard.icon!,
                                  //   width: screenHeight * 0.2,
                                  //   height: 30,
                                  // ),
                                  GestureDetector(
                                    onTap: () {
                                      l16hvm.lucky16HistoryPreviewApi(
                                        context,
                                        l16hvm
                                            .lucky16HistoryModel!
                                            .data![index]
                                            .ticketId,
                                      );
                                    },
                                    child: SizedBox(
                                      width: screenHeight * 0.2,
                                      child: Icon(
                                        Icons.print,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : Container();
                      })
                      : [],
            ),
          ),
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
          color: Colors.white,
        ),
      ),
    );
  }
}

class ReportDetails extends StatefulWidget {
  const ReportDetails({super.key});

  @override
  State<ReportDetails> createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _pickDate(BuildContext context, String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: type == "start" ? _startDate : _endDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      if (type == "start") {
        setState(() {
          _startDate = picked;
        });
      } else {
        setState(() {
          _endDate = picked;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l16hvm = Provider.of<Lucky16HistoryViewModel>(context);
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                commonWidget('FROM', screenWidth * 0.08),
                commonWidget(
                  DateFormat('yyyy-MM-dd').format(
                    _startDate ?? DateTime.now().subtract(Duration(days: 2)),
                  ),
                  screenWidth * 0.08,
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    _pickDate(context, 'start');
                  },
                  child: Image.asset(Assets.lucky12InfoCallIcon, scale: 1.5),
                ),
              ],
            ),
            const SizedBox(width: 50),
            Row(
              children: [
                commonWidget('To', screenWidth * 0.08),
                commonWidget(
                  DateFormat('yyyy-MM-dd').format(_endDate ?? DateTime.now()),
                  screenWidth * 0.08,
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    _pickDate(context, 'end');
                  },
                  child: Image.asset(Assets.lucky12InfoCallIcon, scale: 1.5),
                ),
                const SizedBox(width: 30),
                Lucky16Btn(
                  title: 'VIEW',
                  fontSize: 10,
                  height: 18,
                  onTap: () {
                    if (_startDate != null && _endDate != null) {
                      l16hvm.lucky16GameReportApi(
                        DateFormat('yyyy-MM-dd').format(_startDate!),
                        DateFormat('yyyy-MM-dd').format(_endDate!),
                      );
                    } else {
                      Utils.show(
                        "Please select from and to date to proceed",
                        context,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            commonWidget('Name', screenHeight * 0.2),
            commonWidget('play', screenHeight * 0.45),
            commonWidget('win', screenHeight * 0.2),
            commonWidget('claim', screenHeight * 0.2),
            commonWidget('un claim', screenHeight * 0.2),
            commonWidget('Ntp', screenHeight * 0.2),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child:
                l16hvm.reportLoading
                    ? Center(child: CircularProgressIndicator())
                    : (l16hvm.reportDetailsData != null &&
                        l16hvm.reportDetailsData!.data != null &&
                        l16hvm.reportDetailsData!.data!.isNotEmpty)
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        l16hvm.reportDetailsData!.data!.length,
                        (index) {
                          final data = l16hvm.reportDetailsData!.data![index];
                          // final firstCard = l16c.cardList.firstWhere(
                          //   (card) => card.id == int.parse(data.winNumber.toString()),
                          // );
                          return Container(
                            color: Colors.grey,
                            padding: EdgeInsets.only(top: 3, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                commonWidget(
                                  profileViewModel.userName,
                                  screenHeight * 0.2,
                                  fotSize: 20,
                                ),
                                commonWidget(
                                  '${data.totalBetAmount}',
                                  screenHeight * 0.45,
                                  fotSize: 20,
                                ),
                                commonWidget(
                                  '${data.totalClaimAmount}',
                                  screenHeight * 0.2,
                                  fotSize: 20,
                                ),
                                commonWidget(
                                  '${data.totalClaimAmount}',
                                  screenHeight * 0.2,
                                  fotSize: 20,
                                ),
                                commonWidget(
                                  '${data.totalUnclaimAmount}',
                                  screenHeight * 0.2,
                                  fotSize: 20,
                                ),
                                // commonWidget(
                                //   '${data.totalPercent}',
                                //   screenHeight * 0.2,
                                //   fotSize: 20,
                                // ),
                                commonWidget(
                                  '${data.totalProfit}',
                                  screenHeight * 0.2,
                                  fotSize: 20,
                                ),

                                // Image.asset(
                                //   firstCard.icon!,
                                //   width: screenHeight * 0.2,
                                //   height: 30,
                                // ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                    : Text("No report found for today"),
          ),
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
          color: Colors.white,
        ),
      ),
    );
  }
}
