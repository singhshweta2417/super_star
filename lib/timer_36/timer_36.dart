import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/main.dart';
import 'package:super_star/timer_36/controller/timer_36_controller.dart';
import 'package:super_star/timer_36/widgets/circular_percent_indicator.dart';
import 'package:super_star/timer_36/widgets/exit_pop_up.dart';
import 'package:super_star/timer_36/widgets/timer_36_history.dart';
import 'package:super_star/utils/routes/routes_name.dart';

import '../spin_to_win/view_model/profile_view_model.dart';
import 'view_model/timer_36_last_result_view_model.dart';
import 'widgets/timer_13_history.dart';
import 'widgets/timer_36_board.dart';
import 'widgets/timer_neighbour_dialog.dart';

class Timer36View extends StatefulWidget {
  const Timer36View({super.key});

  @override
  State<Timer36View> createState() => _Timer36ViewState();
}

class _Timer36ViewState extends State<Timer36View> {
  @override
  void initState() {
    super.initState();
    final resTimer = Provider.of<Timer36Controller>(context, listen: false);
    resTimer.connectToServer(context);
    final timer36LastResultViewModel =
    Provider.of<Timer36LastResultViewModel>(listen: false, context);
    timer36LastResultViewModel.timer36LastResultApi(0,context);
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    return Consumer<Timer36Controller>(builder: (context, rbc, child) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          showDialog(
            context: context,
            barrierColor: Colors.transparent,
            builder: (BuildContext context) {
              return ExitPopUp(
                title: 'Are you sure You want to\ngoto Lobby?',
                yes: () {
                  // Dashboard screen
                  rbc.disConnectToServer(context);
                  rbc.clearAll(context);
                  Navigator.pushReplacementNamed(context, RoutesName.dashboard);
                },
                image: const DecorationImage(
                    image: AssetImage(Assets.timer36CloseBg), fit: BoxFit.fill),
              );
            },
          );
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Stack(
              children: [
                Container(
                  height: screenHeight,
                  width: screenWidth,
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Assets.timer36Blue36Bg),
                          fit: BoxFit.fill)),
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.019),
                    child: Transform.translate(
                      offset: Offset(0, -screenHeight * 0.02),
                      child: RotatedBox(
                        quarterTurns: 90,
                        child: Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.00034)
                            ..rotateX(1.11)
                            ..rotateY(-0.04)
                            ..rotateZ(0.74),
                          alignment: FractionalOffset.center,
                          child: Transform.rotate(
                            angle: -1.47,
                            child: const RotatedBox(
                              quarterTurns: 90,
                              child: Timer36Board(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ),
                TimerThirteenHistory(rbc: rbc),
                Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: screenWidth,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commonWidget(Assets.timer36Neighbour,
                                  screenHeight * 0.08, screenWidth * 0.1, () {
                                //green neighbour pop up
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        child: const TimerNeighbourDialog(),
                                      );
                                    });
                              }),
                              viewWidget('POINT BALANCE',
                                  profileViewModel.balance.toStringAsFixed(2)
                              ),
                            ],
                          ),
                          viewWidget('NAME', profileViewModel.userName),
                          if (rbc.bets.isNotEmpty && rbc.showButtons == false)
                            commonWidget(Assets.timer36Remove,
                                screenHeight * 0.08, screenWidth * 0.11, () {
                              setState(() {
                                rbc.resetOne = true;
                                rbc.betValue = 0;
                              });
                            })
                          else
                            commonElseWidget(),
                          if (rbc.bets.isNotEmpty && rbc.showButtons == false)
                            commonWidget(Assets.timer36Double,
                                screenHeight * 0.08, screenWidth * 0.11, () {
                              rbc.doubleAllBets(context);
                            })
                          else
                            commonElseWidget(),
                          if (rbc.bets.isNotEmpty && rbc.showButtons == false)
                            commonWidget(Assets.timer36ClearBet,
                                screenHeight * 0.08, screenWidth * 0.11, () {
                              rbc.clearAll(context);
                            })
                          else
                            commonElseWidget(),
                          commonWidget(Assets.timer36GameHistory,
                              screenHeight * 0.08, screenWidth * 0.11, () {
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    // insetPadding: EdgeInsets.only(right: 10,left: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    backgroundColor: Colors.white,
                                    child: const Timer36History(),
                                  );
                                });
                          }),
                          Column(
                            children: [
                              if (rbc.timerStatus == 1)
                                Text(
                                  'Time Left:${rbc.timerBetTime}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              if (rbc.timerStatus == 1)
                                Container(
                                  height: screenWidth * 0.1,
                                  width: screenWidth * 0.12,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              Assets.timer36Watch40))),
                                  child: CircularPercentIndicator(
                                    radius: screenWidth / 25,
                                    lineWidth: screenWidth / 25,
                                    percent: rbc.timerBetTime / 60,
                                    reverse: true,
                                    backgroundColor: Colors.transparent,
                                    progressColor: rbc.timerBetTime <= 10
                                        ? Colors.red.withValues(alpha: 0.8)
                                        : rbc.timerBetTime <= 30
                                            ? Colors.yellow.withValues(alpha: 0.8)
                                            : Colors.green.withValues(alpha: 0.8),
                                  ),
                                ),
                              SizedBox(height: screenWidth * 0.01),
                              commonWidget(Assets.timer36LeaveTable,
                                  screenWidth * 0.024, screenWidth * 0.12, () {
                                showDialog(
                                  context: context,
                                  barrierColor: Colors.transparent,
                                  builder: (BuildContext context) {
                                    return ExitPopUp(
                                      title:
                                          'Are you sure You want to\ngoto Lobby?',
                                      yes: () {
                                        // Dashboard screen
                                        rbc.disConnectToServer(context);
                                        rbc.clearAll(context);
                                        Navigator.pushReplacementNamed(
                                            context, RoutesName.dashboard);
                                      },
                                      image: const DecorationImage(
                                          image:
                                              AssetImage(Assets.timer36CloseBg),
                                          fit: BoxFit.fill),
                                    );
                                  },
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget commonWidget(
      String image, double height, double widths, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: widths,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.fill)),
      ),
    );
  }

  Widget commonElseWidget() {
    return Container(
      height: screenWidth * 0.05,
      width: screenWidth * 0.11,
      color: Colors.transparent,
    );
  }

  Widget viewWidget(String title, String subTitle) {
    return Container(
      height: screenHeight * 0.095,
      width: screenWidth * 0.15,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Assets.timer36ButtonBg), fit: BoxFit.fill)),
      child: Column(
        children: [
          SizedBox(
            height: screenWidth * 0.02,
            child: FittedBox(
              child: Text(
                title,
                style: TextStyle(
                    color: const Color(0xff11064e),
                    fontWeight: FontWeight.w900,
                    fontSize: screenWidth * 0.015),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: FittedBox(
                child: Text(
                  subTitle,
                  style: TextStyle(
                      color: const Color(0xffFFFFFF),
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.015),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
