import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:super_star/andar_bahar/widgets/fade_animation.dart';
import 'package:super_star/main.dart';
import 'package:super_star/triple_chance/controller/triple_chance_controller.dart';
import 'package:super_star/triple_chance/res/utils.dart';
import 'package:super_star/triple_chance/widgets/slide_tap.dart';
import 'package:super_star/utils/routes/routes_name.dart';

import '../../generated/assets.dart';
import '../spin_to_win/view_model/profile_view_model.dart';
import '../spin_to_win/widgets/exit_pop_up.dart';
import 'view_model/triple_chance_result_view_model.dart';
import 'widgets/double_bet_grid.dart';
import 'widgets/first_wheel.dart';
import 'widgets/green_btn_widget.dart';
import 'widgets/second_wheel.dart';
import 'widgets/single_bet_grid.dart';
import 'widgets/third_wheel.dart';
import 'widgets/triple_bet_grid.dart';
import 'widgets/triple_chance_result.dart';

class TripleChance extends StatefulWidget {
  const TripleChance({super.key});

  @override
  State<TripleChance> createState() => _TripleChanceState();
}

class _TripleChanceState extends State<TripleChance> {
  bool _showContainerOne = false;
  bool _showContainerTwo = false;
  bool _showContainerThree = false;

  void _toggleContainerOne() {
    setState(() {
      _showContainerOne = !_showContainerOne;
      _showContainerTwo = false;
      _showContainerThree = false;
    });
  }

  void _toggleContainerTwo() {
    setState(() {
      _showContainerOne = false;
      _showContainerTwo = !_showContainerTwo;
      _showContainerThree = false;
    });
  }

  void _toggleContainerThree() {
    setState(() {
      _showContainerOne = false;
      _showContainerTwo = false;
      _showContainerThree = !_showContainerThree;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final resTimer =
          Provider.of<TripleChanceController>(context, listen: false);
      resTimer.connectToServer(context);
      final tcr =
          Provider.of<TripleChanceResultViewModel>(context, listen: false);
      tcr.tripleChanceResultApi(context, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    final tcr = Provider.of<TripleChanceResultViewModel>(context);
    return Consumer<TripleChanceController>(builder: (context, tcc, child) {
      return PopScope(
        canPop: false,
        // onPopInvoked: (didPop) {
        //   showDialog(
        //     context: context,
        //     barrierColor: Colors.transparent,
        //     //   return ExitPopUp(
        //         //     //     // title: 'Are you sure You want to\ngoto Lobby?',
        //         //     //     yes: () {
        //         //     //       // Dashboard screen
        //         //     //       tcc.disConnectToServer(context);
        //         //     //       Navigator.pushReplacementNamed(context, RoutesName.dashboard);
        //         //   // builder: (BuildContext context) {
        //       //     },
        //     //     // image: const DecorationImage(
        //     //     //     image: AssetImage(Assets.timer36CloseBg), fit: BoxFit.fill),
        //     //   );
        //     // },
        //   );
        // },
        child: Scaffold(
            body: Center(
          child: Stack(
              alignment: Alignment.center,
              children: [
            SizedBox(
              width: screenWidth * 0.03,
            ),
            Container(
              height: screenHeight,
              width: screenWidth,
              padding: EdgeInsets.only(right: screenWidth * 0.03),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.tripleChanceTChanceBg),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FirstWheelSpin(
                    controller: tcc,
                    pathImage: Assets.tripleChanceFirstWheel,
                    withWheel: screenWidth * 0.43,
                    pieces: 10,
                  ),
                  SecondWheelSpin(
                    controller: tcc,
                    pathImage: Assets.tripleChanceSecondWheel,
                    withWheel: screenWidth * 0.3,
                    pieces: 10,
                  ),
                  ThirdWheelSpin(
                    controller: tcc,
                    pathImage: Assets.tripleChanceThirdWheel,
                    withWheel: screenWidth * 0.2,
                    pieces: 10,
                  ),
                  Container(
                      alignment: Alignment.center,
                      height: screenWidth * 0.12,
                      width: screenWidth * 0.12,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:
                                  AssetImage(Assets.tripleChanceTCenterCircle),
                              fit: BoxFit.fill)),
                      child: Image(
                          image:
                              const AssetImage(Assets.tripleChanceTripleText),
                          width: screenWidth * 0.08)),
                  Container(
                    height: screenWidth * 0.5,
                    width: screenWidth * 0.5,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Assets.tripleChanceCircleBg),
                          fit: BoxFit.fill),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.53,
                          ),
                        child: GestureDetector(
                          onTap: (){
                            showDialog(context: context, builder: (context){
                              return  ExitPopUp(
                                // title: 'Are you sure You want to\ngoto Lobby?',
                                yes: () {
                                  // Dashboard screen
                                  tcc.disConnectToServer(context);
                                  Navigator.pushReplacementNamed(context, RoutesName.dashboard);
                                },
                                // image: const DecorationImage(
                                //     image: AssetImage(Assets.timer36CloseBg), fit: BoxFit.fill),
                              );
                            });
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: screenHeight*0.1,
                                width: screenHeight*0.4,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(Assets.tripleChanceArrowBack),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child:  Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: screenWidth*0.03),
                                    child:  Text(
                                      "Exit",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenHeight * 0.037,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'roboto_lite'),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        )),
                  )
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(
                height: screenHeight,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.03,
                      bottom: screenHeight * 0.02,
                      left: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SlideTap(
                          title: 'SINGLE',
                          play: tcc.singleTotalAmount.toString(),
                          win: tcr.fiWheelWinAmount.toString(),
                          reversIcon: _showContainerOne,
                          onTap: _toggleContainerOne),
                      if (_showContainerOne)
                        FadeInLeft(child: const SingleBetGrid()),
                      SlideTap(
                          title: 'DOUBLE',
                          play: tcc.doubleTotalAmount.toString(),
                          win: tcr.seWheelWinAmount.toString(),
                          reversIcon: _showContainerTwo,
                          onTap: _toggleContainerTwo),
                      if (_showContainerTwo)
                        FadeInLeft(child: const DoubleBetGrid()),
                      SlideTap(
                        title: 'TRIPLE',
                        play: tcc.tripleTotalAmount.toString(),
                        win: tcr.thWheelWinAmount.toString(),
                        reversIcon: _showContainerThree,
                        onTap: _toggleContainerThree,
                      ),
                      if (_showContainerThree)
                        FadeInLeft(child: const TripleBetGrid()),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.06),
                child: SizedBox(
                  height: screenHeight,
                  width: screenWidth * 0.26,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: screenHeight * 0.14,
                        width: screenWidth * 0.25,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(Assets.tripleChanceBalanceBg),
                                fit: BoxFit.fill)),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                    margin:
                                        const EdgeInsets.only(top: 5, left: 5),
                                    alignment: Alignment.centerLeft,
                                    height: screenHeight * 0.051,
                                    width: screenWidth * 0.133,
                                    child: FittedBox(
                                      child: Text(
                                        'PLAY:${tcc.singleTotalAmount + tcc.doubleTotalAmount + tcc.tripleTotalAmount}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenHeight * 0.026,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'roboto_lite'),
                                      ),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: screenWidth * 0.005,
                                        left: screenWidth * 0.01),
                                    alignment: Alignment.centerLeft,
                                    height: screenHeight * 0.0495,
                                    width: screenWidth * 0.133,
                                    child: Text(
                                      'WIN:  ${tcr.winAmount}',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenHeight * 0.026,
                                          fontFamily: 'roboto_lite'),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'BALANCE',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenHeight * 0.026,
                                        fontFamily: 'roboto_lite'),
                                  ),
                                  Text(
                                    profileViewModel.balance.toStringAsFixed(2),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenHeight * 0.026,
                                        fontFamily: 'roboto_lite'),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const TripleChanceResult(),
                      Container(
                        alignment: Alignment.center,
                        height: screenHeight * 0.07,
                        width: screenWidth * 0.25,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage(Assets.tripleChancePlaceChipBg),
                                fit: BoxFit.fill)),
                        child: Text(
                          tcc.showMessage,
                          style: const TextStyle(
                              color: Color(0xffd81511),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.all(screenHeight * 0.01),
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage(Assets.tripleChanceChipsBg1),
                                    fit: BoxFit.fill)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                        tcc.coinList.length,
                                        (index) => GestureDetector(
                                              onTap: () {
                                                tcc.setResetOne(false);
                                                tcc.selectChips(index,
                                                    tcc.coinList[index].value);
                                              },
                                              child: Container(
                                                  height: screenHeight * 0.1,
                                                  width: screenHeight * 0.1,
                                                  alignment: Alignment.center,
                                                  decoration: tcc.selectedIndex ==
                                                              index &&
                                                          tcc.resetOne == false
                                                      ? const BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  Assets
                                                                      .tripleChanceSelectBg)))
                                                      : BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: const Color(
                                                              0xff351f07),
                                                          border: Border.all(
                                                              width: 1,
                                                              color: const Color(
                                                                  0xffcd9838)),
                                                        ),
                                                  child: Container(
                                                      height:
                                                          screenHeight * 0.09,
                                                      width:
                                                          screenHeight * 0.09,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                tcc
                                                                    .coinList[
                                                                        index]
                                                                    .image),
                                                            fit: BoxFit.fill),
                                                      ))
                                                  // Image.asset(
                                                  //   tcc.coinList[index].image,
                                                  //   scale: 2.55,
                                                  // )
                                                  ),
                                            ))),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GreenBtnWidget(
                                      title: 'INFO',
                                      onTap: () {
                                        Utils.showTrChWinToast(
                                            "100", '11', '5', '5', context);
                                        // showDialog(
                                        //   barrierDismissible: false,
                                        //   context: context,
                                        //   builder: (BuildContext context) {
                                        //     return const InfoDialog(
                                        //       image: DecorationImage(
                                        //           image: AssetImage(
                                        //               Assets.tripleChanceDailogBg),
                                        //           fit: BoxFit.fill),
                                        //     );
                                        //   },
                                        // );
                                      },
                                    ),
                                    Stack(
                                      children: [
                                        GreenBtnWidget(
                                          title: 'DOUBLE',
                                          onTap: () {
                                            if (tcc.addTripleChanceBets
                                                .isNotEmpty) {
                                              tcc.doubleAllBets(context);
                                            }
                                          },
                                        ),
                                        if (tcc.addTripleChanceBets.isEmpty)
                                          shadowContainer()
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        GreenBtnWidget(
                                          title: 'CLEAR',
                                          onTap: () {
                                            if (tcc.addTripleChanceBets
                                                .isNotEmpty) {
                                              tcc.clearAllBet(context);
                                            }
                                          },
                                        ),
                                        if (tcc.addTripleChanceBets.isEmpty)
                                          shadowContainer()
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        GreenBtnWidget(
                                          title: 'REMOVE',
                                          onTap: () {
                                            if (tcc.addTripleChanceBets
                                                .isNotEmpty) {
                                              tcc.setResetOne(true);
                                            }
                                          },
                                        ),
                                        if (tcc.addTripleChanceBets.isEmpty)
                                          shadowContainer()
                                      ],
                                    ),
                                    Container(
                                      height: screenHeight * 0.22,
                                      width: screenWidth * 0.177,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff3f2202),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              width: 1,
                                              color: const Color(0xffcd9838))),
                                      child: Column(
                                        children: [
                                          Text(
                                            tcc.timerStatus == 1
                                                ? '00:${tcc.timerBetTime.toString().padLeft(2, '0')}'
                                                : '00:00',
                                            style: TextStyle(
                                                color: const Color(0xffffff34),
                                                fontWeight: FontWeight.bold,
                                                fontSize: screenHeight * 0.07),
                                          ),
                                          Text(
                                            'SECONDS LEFT',
                                            style: TextStyle(
                                                color: const Color(0xfffd9903),
                                                fontWeight: FontWeight.bold,
                                                fontSize: screenHeight * 0.03,
                                                fontFamily: 'roboto_lite'),
                                          ),
                                          Text(
                                            tcr.tripleChanceResultList
                                                    .isNotEmpty
                                                ? '${tcr.tripleChanceResultList.first.gamesNo! + 1}'
                                                : '',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: screenHeight * 0.03,
                                                fontFamily: 'roboto_lite'),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              )
            ])
          ]),
        )),
      );
    });
  }

  Widget shadowContainer() {
    return Container(
      height: screenHeight * 0.09,
      width: screenWidth * 0.177,
      decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(5)),
    );
  }
}
