import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/lucky_card_16/view_model/lucky_16_bet_view_model.dart';
import 'package:super_star/lucky_card_16/view_model/lucky_16_check_view_model.dart';
import 'package:super_star/lucky_card_16/view_model/lucky_16_result_view_model.dart';
import 'package:super_star/lucky_card_16/view_model/usb_print.dart';
import 'package:super_star/lucky_card_16/widgets/luck_16_exit_pop_up.dart';
import 'package:super_star/lucky_card_16/widgets/lucky_16_btn.dart';
import 'package:super_star/lucky_card_16/widgets/lucky_16_coin_list.dart';
import 'package:super_star/lucky_card_16/widgets/lucky_16_info_d.dart';
import 'package:super_star/lucky_card_16/widgets/lucky_16_result.dart';
import 'package:super_star/lucky_card_16/widgets/lucky_16_timer.dart';
import 'package:super_star/lucky_card_16/widgets/lucky_16_top.dart';
import 'package:super_star/main.dart';
import 'package:super_star/res/app_constant.dart';
import 'package:super_star/utils/routes/routes_name.dart';
import '../lucky_card_12/widgets/lucky_12_btn.dart';
import 'controller/lucky_16_controller.dart';
import 'widgets/lucky_16_second_wheel.dart';
import 'widgets/lucky_16_wheel_first.dart';

class LuckyCard16 extends StatefulWidget {
  const LuckyCard16({super.key});

  @override
  State<LuckyCard16> createState() => _LuckyCard16State();
}

class _LuckyCard16State extends State<LuckyCard16> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keyboardFocusNode.requestFocus();
      final resTimer = Provider.of<Lucky16Controller>(context, listen: false);
      final usbPrint = Provider.of<UsbPrintViewModel>(context, listen: false);
      usbPrint.scan(context);
      resTimer.connectToServer(context);
      final lucky16ResultViewModel = Provider.of<Lucky16ResultViewModel>(
        context,
        listen: false,
      );
      lucky16ResultViewModel.lucky16ResultApi(context, 1);
    });
  }


  bool _isKeyLocked = false;

  void _handleKey(KeyEvent event) async {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter) {

        if (_isKeyLocked) return; // prevent duplicate action
        _isKeyLocked = true;

        final l16c = Provider.of<Lucky16Controller>(context, listen: false);
        final l16cBetCon = Provider.of<Lucky16BetViewModel>(context, listen: false);
        if (l16c.addLucky16Bets.isNotEmpty &&
            !l16cBetCon.loading &&
            l16c.addLucky16Bets != []) {
          await l16c.lucky16BetViewModel.lucky16BetApi(
            l16c.addLucky16Bets,
            context,
          );
        }
        await Future.delayed(Duration(seconds: 1));
        _isKeyLocked = false; // unlock after API call completes
      }
      else if (event.logicalKey == LogicalKeyboardKey.backspace) {
        Navigator.pop(context);
      }
    }
  }


  final TextEditingController ticketController = TextEditingController();

  final FocusNode _keyboardFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final lucky16ResultViewModel = Provider.of<Lucky16ResultViewModel>(context);
    final checkData = Provider.of<Lucky16CheckViewModel>(
      context,
      listen: false,
    );
    return Consumer<Lucky16Controller>(
      builder: (context, l16c, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, Object? result) {
            showDialog(
              context: context,
              barrierColor: Colors.transparent,
              builder: (BuildContext context) {
                return Luck16ExitPopUp(
                  yes: () {
                    // exit pop up
                    l16c.disConnectToServer(context);
                    Navigator.pushReplacementNamed(
                      context,
                      RoutesName.dashboard,
                    );
                  },
                );
              },
            );
          },
          child: KeyboardListener(
            focusNode: _keyboardFocusNode,
            onKeyEvent: _handleKey,
            // autofocus: true,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Center(
                child: Container(
                  height: screenHeight,
                  width: screenWidth,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.lucky16LuckyBg),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    children: [
                      Lucky16Top(),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: Colors.transparent,
                                width: screenWidth * 0.5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: screenHeight * 0.06),
                                    Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: screenWidth * 0.32,
                                              width: screenWidth * 0.32,
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    Assets.lucky16LWheelBgOne,
                                                  ),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            Lucky16WheelFirst(
                                              controller: l16c,
                                              pathImage:
                                                  Assets.lucky16L16FirstWheel,
                                              withWheel: screenWidth * 0.289,
                                              pieces: 16,
                                            ),
                                            Lucky16SecondWheel(
                                              controller: l16c,
                                              pathImage:
                                                  Assets.lucky16L16SecondWheel,
                                              withWheel: screenWidth * 0.2,
                                              pieces: 16,
                                            ),
                                            Container(
                                              height: screenWidth * 0.134,
                                              width: screenWidth * 0.134,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    Assets.lucky16L16ThirdWheel,
                                                  ),
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                              child:
                                                  lucky16ResultViewModel
                                                              .lucky16ResultList
                                                              .isNotEmpty &&
                                                          !l16c.resultShowTime
                                                      ? _buildVerticalLayout(
                                                        l16c,
                                                        lucky16ResultViewModel,
                                                      )
                                                      : null,
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          child: Container(
                                            height: screenWidth * 0.38,
                                            width: screenWidth * 0.32,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  Assets.lucky12ShowRes,
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      height: screenHeight * 0.08,
                                      width: screenWidth * 0.3,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.all(
                                        2,
                                      ), // Reduced margin
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            Assets.lucky16LBgBlue,
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: CupertinoTextField(
                                              // focusNode: _textFieldFocusNode,
                                              controller: ticketController,
                                              // autofocus: true,
                                              placeholder:
                                                  "Enter your Ticket I'd",
                                              padding: EdgeInsets.all(10),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          SizedBox(
                                            width: screenWidth * 0.07,
                                            child: Lucky12Btn(
                                              title: 'CHECK',
                                              onTap: () async {
                                                await checkData.lucky16CheckApi(
                                                  context,
                                                  ticketController.text
                                                ).then((_){
                                                  ticketController.clear();
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: screenHeight * 0.08,
                                          width: screenWidth * 0.15,
                                          margin: const EdgeInsets.all(
                                            2,
                                          ), // Reduced margin
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                Assets.lucky16LBgYellow,
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 5,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'PLAY:',
                                                  style: TextStyle(
                                                    fontSize:
                                                        AppConstant.luckyRoFont,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'roboto',
                                                  ),
                                                ),
                                                Text(
                                                  l16c.totalBetAmount
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize:
                                                        AppConstant.luckyRoFont,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: screenHeight * 0.08,
                                          width: screenWidth * 0.15,
                                          margin: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                Assets.lucky16LBgYellow,
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 5,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  l16c.showMessage,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'roboto',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: Colors.transparent,
                                // width: screenWidth * 0.5,
                                // height: screenHeight,
                                // padding: const EdgeInsets.only(bottom: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: screenWidth * 0.3,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: List.generate(l16c.columnBetList.length, (
                                                  index,
                                                ) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      if (l16c
                                                              .addLucky16Bets
                                                              .isEmpty &&
                                                          l16c.resetOne ==
                                                              true) {
                                                        l16c.setResetOne(false);
                                                      }
                                                      l16c.addColumnBet(
                                                        context,
                                                        index,
                                                      );
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height:
                                                          screenHeight * 0.11,
                                                      width: screenWidth * 0.06,
                                                      padding: EdgeInsets.only(
                                                        bottom:
                                                            screenWidth * 0.005,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                            l16c.columnBetList[index],
                                                          ),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      child:
                                                          l16c
                                                                      .tapedColumnList
                                                                      .isNotEmpty &&
                                                                  l16c.tapedColumnList
                                                                      .where(
                                                                        (e) =>
                                                                            e["index"] ==
                                                                            index,
                                                                      )
                                                                      .isNotEmpty
                                                              ? Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height:
                                                                    screenHeight *
                                                                    0.052,
                                                                width:
                                                                    screenHeight *
                                                                    0.052,
                                                                padding:
                                                                    const EdgeInsets.fromLTRB(
                                                                      1,
                                                                      2.5,
                                                                      1,
                                                                      1,
                                                                    ),
                                                                decoration: getBoxDecoration(
                                                                  l16c.tapedColumnList
                                                                      .where(
                                                                        (e) =>
                                                                            e["index"] ==
                                                                            index,
                                                                      )
                                                                      .first["amount"]!,
                                                                ),
                                                                child: Text(
                                                                  l16c.tapedColumnList
                                                                      .where(
                                                                        (e) =>
                                                                            e["index"] ==
                                                                            index,
                                                                      )
                                                                      .first["amount"]
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        l16c.tapedColumnList
                                                                                    .where(
                                                                                      (
                                                                                        e,
                                                                                      ) =>
                                                                                          e["index"] ==
                                                                                          index,
                                                                                    )
                                                                                    .first["amount"]
                                                                                    .toString()
                                                                                    .length <
                                                                                3
                                                                            ? 8
                                                                            : 7,
                                                                    fontFamily:
                                                                        'dangrek',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              )
                                                              : Text(
                                                                index == 0
                                                                    ? 'H'
                                                                    : index == 1
                                                                    ? 'S'
                                                                    : index == 2
                                                                    ? 'D'
                                                                    : 'C',
                                                                // : '',
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      AppConstant
                                                                          .luckyBtnFont,
                                                                  fontFamily:
                                                                      'dancing',
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                              GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: l16c.cardList.length,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 4,
                                                      childAspectRatio: 1.4 / 1,
                                                      mainAxisSpacing: 2,
                                                    ),
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      if (l16c
                                                              .addLucky16Bets
                                                              .isEmpty &&
                                                          l16c.resetOne ==
                                                              true) {
                                                        l16c.setResetOne(false);
                                                      }
                                                      l16c.luckyAddBet(
                                                        l16c.cardList[index].id,
                                                        l16c.selectedValue,
                                                        index,
                                                        context,
                                                      );
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment
                                                              .bottomCenter,
                                                      height:
                                                          screenHeight * 0.10,
                                                      width: screenWidth * 0.06,
                                                      padding: EdgeInsets.only(
                                                        bottom:
                                                            screenWidth * 0.008,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                            l16c
                                                                .cardList[index]
                                                                .image,
                                                          ),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      child:
                                                          l16c
                                                                      .addLucky16Bets
                                                                      .isNotEmpty &&
                                                                  l16c.addLucky16Bets
                                                                      .where(
                                                                        (
                                                                          value,
                                                                        ) =>
                                                                            value['game_id'] ==
                                                                            l16c.cardList[index].id,
                                                                      )
                                                                      .isNotEmpty
                                                              ? Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height:
                                                                    screenHeight *
                                                                    0.052,
                                                                width:
                                                                    screenHeight *
                                                                    0.052,
                                                                padding:
                                                                    const EdgeInsets.fromLTRB(
                                                                      1,
                                                                      2.5,
                                                                      1,
                                                                      1,
                                                                    ),
                                                                decoration: getBoxDecoration(
                                                                  l16c.addLucky16Bets
                                                                      .where(
                                                                        (e) =>
                                                                            e['game_id'] ==
                                                                            l16c.cardList[index].id,
                                                                      )
                                                                      .first["amount"]!,
                                                                ),
                                                                child: Text(
                                                                  l16c.addLucky16Bets
                                                                      .where(
                                                                        (e) =>
                                                                            e['game_id'] ==
                                                                            l16c.cardList[index].id,
                                                                      )
                                                                      .first["amount"]
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        l16c.addLucky16Bets
                                                                                    .where(
                                                                                      (
                                                                                        e,
                                                                                      ) =>
                                                                                          e['game_id'] ==
                                                                                          l16c.cardList[index].id,
                                                                                    )
                                                                                    .first["amount"]
                                                                                    .toString()
                                                                                    .length <
                                                                                3
                                                                            ? 11
                                                                            : 9,
                                                                    fontFamily:
                                                                        'dangrek',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                  ),
                                                                ),
                                                              )
                                                              : Text(
                                                                !l16c.showBettingTime
                                                                    ? 'Play'
                                                                    : '',
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      AppConstant
                                                                          .luckyKaFont,
                                                                  fontFamily:
                                                                      'dancing',
                                                                ),
                                                              ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              width: screenWidth * 0.12,
                                              height: screenHeight * 0.11,
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    Assets.lucky16LBetInfo,
                                                  ),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: List.generate(l16c.rowBetList.length, (
                                                index,
                                              ) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    if (l16c
                                                            .addLucky16Bets
                                                            .isEmpty &&
                                                        l16c.resetOne == true) {
                                                      l16c.setResetOne(false);
                                                    }
                                                    l16c.addRowBet(
                                                      context,
                                                      index,
                                                    );
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                      top: screenWidth * 0.008,
                                                    ),
                                                    // padding:
                                                    // EdgeInsets.only(
                                                    //     top: screenWidth*0.008, left: screenWidth*0.03),
                                                    alignment: Alignment.center,
                                                    height:
                                                        AppConstant.luckyColHi,
                                                    width: screenWidth * 0.07,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                          l16c.rowBetList[index],
                                                        ),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    child:
                                                        l16c
                                                                    .tapedRowList
                                                                    .isNotEmpty &&
                                                                l16c.tapedRowList
                                                                    .where(
                                                                      (e) =>
                                                                          e["index"] ==
                                                                          index,
                                                                    )
                                                                    .isNotEmpty
                                                            ? Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height:
                                                                  screenHeight *
                                                                  0.052,
                                                              width:
                                                                  screenHeight *
                                                                  0.052,
                                                              padding:
                                                                  const EdgeInsets.fromLTRB(
                                                                    1,
                                                                    2.5,
                                                                    1,
                                                                    1,
                                                                  ),
                                                              decoration: getBoxDecoration(
                                                                l16c.tapedRowList
                                                                    .where(
                                                                      (e) =>
                                                                          e["index"] ==
                                                                          index,
                                                                    )
                                                                    .first["amount"]!,
                                                              ),
                                                              child: Text(
                                                                l16c.tapedRowList
                                                                    .where(
                                                                      (e) =>
                                                                          e["index"] ==
                                                                          index,
                                                                    )
                                                                    .first["amount"]
                                                                    .toString(),
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      l16c.tapedRowList
                                                                                  .where(
                                                                                    (
                                                                                      e,
                                                                                    ) =>
                                                                                        e["index"] ==
                                                                                        index,
                                                                                  )
                                                                                  .first["amount"]
                                                                                  .toString()
                                                                                  .length <
                                                                              3
                                                                          ? 8
                                                                          : 7,
                                                                  fontFamily:
                                                                      'dangrek',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            )
                                                            : Text(
                                                              !l16c.showBettingTime
                                                                  ? 'Play'
                                                                  : '',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    AppConstant
                                                                        .luckyKaFont,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontFamily:
                                                                    'dancing',
                                                              ),
                                                            ),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      children: [
                                        Column(
                                          children: [
                                            Lucky16Result(),
                                            Lucky16CoinList(),
                                          ],
                                        ),
                                        SizedBox(width: 13),
                                        Lucky16Timer(),
                                      ],
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Lucky16Btn(
                                            title: 'INFO',
                                            onTap: () {
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (
                                                  BuildContext context,
                                                ) {
                                                  return const Lucky16InfoD();
                                                },
                                              );
                                            },
                                          ),
                                          SizedBox(width: screenWidth * 0.01),
                                          Stack(
                                            children: [
                                              Lucky16Btn(
                                                title: 'CLEAR',
                                                onTap: () {
                                                  if (l16c
                                                      .addLucky16Bets
                                                      .isNotEmpty) {
                                                    l16c.clearAllBet(context);
                                                  }
                                                },
                                              ),
                                              if (l16c.addLucky16Bets.isEmpty)
                                                shadowContainer(),
                                            ],
                                          ),
                                          SizedBox(width: screenWidth * 0.01),
                                          Stack(
                                            alignment: Alignment.center,
                                            // clipBehavior: Clip.none,
                                            children: [
                                              Lucky16Btn(
                                                title: 'REMOVE',
                                                onTap: () {
                                                  if (l16c
                                                      .addLucky16Bets
                                                      .isNotEmpty) {
                                                    l16c.setResetOne(true);
                                                  }
                                                },
                                              ),
                                              if (l16c.addLucky16Bets.isEmpty)
                                                shadowContainer(),
                                            ],
                                          ),
                                          SizedBox(width: screenWidth * 0.01),
                                          Stack(
                                            children: [
                                              Lucky16Btn(
                                                title: 'DOUBLE',
                                                onTap: () {
                                                  if (l16c
                                                      .addLucky16Bets
                                                      .isNotEmpty) {
                                                    l16c.doubleAllBets(context);
                                                  }
                                                },
                                              ),
                                              if (l16c.addLucky16Bets.isEmpty)
                                                shadowContainer(),
                                            ],
                                          ),
                                          SizedBox(width: screenWidth * 0.01),

                                          Stack(
                                            children: [
                                              Lucky16Btn(
                                                title: 'PRINT',
                                                onTap: () async {
                                                    if (l16c
                                                        .addLucky16Bets
                                                        .isNotEmpty) {
                                                      if (_isKeyLocked) return;
                                                      setState(() {
                                                        _isKeyLocked = true;
                                                      });
                                                      l16c.lucky16BetViewModel
                                                          .lucky16BetApi(
                                                            l16c.addLucky16Bets,
                                                            context,
                                                          );
                                                      await Future.delayed(Duration(seconds: 1));
                                                      setState(() {
                                                        _isKeyLocked = false;
                                                      });
                                                  }
                                                },
                                              ),
                                              if (l16c.addLucky16Bets.isEmpty)
                                                shadowContainer(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget shadowContainer() {
    return Container(
      height: screenHeight * 0.06,
      width: screenWidth * 0.09,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildVerticalLayout(
    Lucky16Controller l16c,
    Lucky16ResultViewModel lucky16resultViewModel,
  )
  {
    final card = l16c.getCardForIndex(
      lucky16resultViewModel.lucky16ResultList.first.cardIndex!,
    );
    final color = l16c.getColorForIndex(
      lucky16resultViewModel.lucky16ResultList.first.colorIndex!,
    );
    final jackpot = l16c.getJackpotForIndex(
      lucky16resultViewModel.lucky16ResultList.first.jackpot!,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildImageContainer(card), _buildImageContainer(color)],
        ),
        if (jackpot != null) _buildJackpotImage(jackpot),
      ],
    );
  }

  Widget _buildImageContainer(String assetPath) {
    return Container(
      height: screenHeight * 0.1,
      width: screenWidth * 0.04,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(assetPath), fit: BoxFit.fill),
      ),
    );
  }

  Widget _buildJackpotImage(String assetPath) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(assetPath), fit: BoxFit.fill),
      ),
    );
  }
}

BoxDecoration getBoxDecoration(int amount) {
  String assetName;

  if (amount >= 5 && amount < 10) {
    assetName = Assets.lucky16LC5;
  } else if (amount >= 10 && amount < 20) {
    assetName = Assets.lucky16LC10;
  } else if (amount >= 20 && amount < 50) {
    assetName = Assets.lucky16LC20;
  } else if (amount >= 50 && amount < 100) {
    assetName = Assets.lucky16LC50;
  } else if (amount >= 100 && amount < 500) {
    assetName = Assets.lucky16LC100;
  } else {
    assetName = Assets.lucky16LC500;
  }

  return BoxDecoration(
    shape: BoxShape.circle,
    image: DecorationImage(image: AssetImage(assetName), fit: BoxFit.fill),
  );
}
