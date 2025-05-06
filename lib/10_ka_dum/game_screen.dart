import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:super_star/10_ka_dum/res/sizes_const.dart';
import 'package:super_star/10_ka_dum/res/text_const.dart';
import 'package:super_star/10_ka_dum/view_model/dus_ka_dum_bet_view_model.dart';
import 'package:super_star/10_ka_dum/view_model/dus_ka_dum_check_view_model.dart';
import 'package:super_star/10_ka_dum/view_model/dus_ka_dum_result_view_model.dart';
import 'package:super_star/10_ka_dum/view_model/usb_print_10.dart';
import 'package:super_star/10_ka_dum/widget/dus_ka_dum_history.dart';
import 'package:super_star/main.dart';
import '../generated/assets.dart';
import '../lucky_card_12/controller/lucky_12_controller.dart';
import '../lucky_card_12/widgets/lucky_12_btn.dart';
import '../lucky_card_16/widgets/luck_16_exit_pop_up.dart';
import '../spin_to_win/view_model/profile_view_model.dart';
import '../utils/routes/routes_name.dart';
import 'controller/dus_ka_dum_controller.dart';

class DusKaDamGameScreen extends StatefulWidget {
  const DusKaDamGameScreen({super.key});

  @override
  State<DusKaDamGameScreen> createState() => _DusKaDamGameScreenState();
}

class _DusKaDamGameScreenState extends State<DusKaDamGameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keyboardFocusNode.requestFocus();
      final usb10Print = Provider.of<UsbPrintDusViewModel>(
        context,
        listen: false,
      );
      usb10Print.scan(context);
      Provider.of<DusKaDumController>(
        context,
        listen: false,
      ).connectToServer(context);
      Provider.of<DusKaDumResultViewModel>(
        context,
        listen: false,
      ).dusKaDumResultApi(context);
    });
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isKeyLocked = false;
  Future<void> _handleKey(KeyEvent event) async {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter) {
        if (_isKeyLocked) return; // prevent duplicate action
        _isKeyLocked = true;
        final dusCon = Provider.of<DusKaDumController>(context, listen: false);
        final dkdBetC = Provider.of<DusKaDumBetViewModel>(
          context,
          listen: false,
        );
        if (dusCon.dusKaDumBets.isNotEmpty && dusCon.dusKaDumBets != []) {
          dkdBetC.dusKaDumBetApi(dusCon.dusKaDumBets, context);
        }
        await Future.delayed(Duration(seconds: 1));
        _isKeyLocked = false; // unlock after API call completes
      } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
        Navigator.pop(context);
      }
    }
  }

  final FocusNode _keyboardFocusNode = FocusNode();
  final TextEditingController ticketController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Sizes.initSizing(context);
    return Scaffold(
      body: Center(
        child: Container(
          height: Sizes.screenHeight,
          width: Sizes.screenWidth,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            border: Border.all(width: 5, color: Colors.grey),
            image: DecorationImage(
              image: AssetImage('assets/dus_ka_dum/game_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [sectionOne(), bottomActionBar()],
          ),
        ),
      ),
    );
  }

  Widget sectionOne() {
    return SizedBox(
      height: Sizes.screenHeight / 1.15,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [gameSection(), historySection(), dummyPolygon()],
      ),
    );
  }

  Widget gameSection() {
    return Consumer<DusKaDumController>(
      builder: (context, dkdCon, _) {
        return Container(
          padding: EdgeInsets.only(top: 5, left: 0, right: 0, bottom: 0),
          width: Sizes.screenWidth / 1.6,
          child: Column(
            children: [
              gameName(),
              Sizes.spaceH10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bettingNumberGrid(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(dkdCon.rowBetList.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          if (dkdCon.dusKaDumBets.isEmpty &&
                              dkdCon.resetOne == true) {
                            dkdCon.setResetOne(false);
                          }
                          dkdCon.addRowBet(context, index);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: screenWidth * 0.05),
                          color: Colors.red,
                          alignment: Alignment.center,
                          height: screenHeight * 0.085,
                          width: screenWidth * 0.025,
                        ),
                      );
                    }),
                  ),
                  Sizes.spaceW15,
                  gameInfo(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget historySection() {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
      width: Sizes.screenWidth / 3.5,
      child: dummyTableWidget(),
    );
  }

  Widget gameName() {
    return Container(
      width: Sizes.screenWidth / 2,
      height: screenHeight / 13,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(Assets.dusKaDumGameName)),
      ),
    );
  }

  Widget bettingNumberGrid() {
    return Consumer<DusKaDumController>(
      builder: (context, dkdCon, _) {
        return SizedBox(
          height: Sizes.screenHeight / 1.3,
          width: Sizes.screenWidth / 2.9,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(dkdCon.columnBetList.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      if (dkdCon.dusKaDumBets.isEmpty &&
                          dkdCon.resetOne == true) {
                        dkdCon.setResetOne(false);
                      }
                      dkdCon.addColumnBet(context, index);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        left: screenWidth * 0.01,
                        right: screenWidth * 0.01,
                      ),
                      height: screenHeight * 0.045,
                      width: screenWidth * 0.05,
                      color: Colors.red,
                    ),
                  );
                }),
              ),
              Expanded(
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: dkdCon.bettingNumberList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 17,
                    crossAxisSpacing: 17,
                  ),
                  itemBuilder: (context, int numberIndex) {
                    final number = dkdCon.bettingNumberList[numberIndex];
                    return bettingNumTile(number);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget gameInfo() {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    return Consumer3<
      DusKaDumController,
      DusKaDumResultViewModel,
      DusKaDumCheckViewModel
    >(
      builder: (context, dkdCon, result, check, _) {
        double size = Sizes.screenWidth / 12;
        return Container(
          width: Sizes.screenWidth / 4.2,
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: Sizes.screenHeight / 12,
                width: Sizes.screenWidth / 10,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: CText(
                  dkdCon.timerBetTime.toString(),
                  size: Sizes.fontSize10,
                  weight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Sizes.spaceH10,
              Container(
                padding: EdgeInsets.only(left: 8),
                alignment: Alignment.centerLeft,
                height: Sizes.screenHeight / 28,
                width: Sizes.screenWidth / 9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    topLeft: Radius.circular(5),
                  ),
                  border: Border.all(width: 2, color: Colors.black),
                ),
                child: CText(
                  dkdCon.showMessage,
                  size: Sizes.fontSize4,
                  weight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    height: Sizes.screenHeight / 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        labelTile('Balance', "${profileViewModel.balance}"),
                        labelTile('Draw time', dkdCon.nextDrawTimeFormatted),
                        labelTile('terminal id', profileViewModel.userName),
                        labelTile(
                          'game id',
                          result.dusKaDumResultList.isNotEmpty
                              ? (result.dusKaDumResultList.first.periodNo! + 1)
                                  .toString()
                              : '',
                        ),
                      ],
                    ),
                  ),
                  Sizes.spaceW20,
                  SizedBox(
                    height: Sizes.screenHeight / 3.2,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        KeyboardListener(
                          focusNode: _keyboardFocusNode,
                          onKeyEvent: _handleKey,
                          child: InkWell(
                            onTap: () async {
                              if (dkdCon.dusKaDumBets.isNotEmpty) {
                                if (_isKeyLocked) return;
                                setState(() {
                                  _isKeyLocked = true;
                                });
                                Provider.of<DusKaDumBetViewModel>(
                                  context,
                                  listen: false,
                                ).dusKaDumBetApi(dkdCon.dusKaDumBets, context);
                                await Future.delayed(Duration(seconds: 1));
                                setState(() {
                                  _isKeyLocked = false;
                                });
                              } else {
                                debugPrint("There is not bet placed");
                              }
                            },
                            child: Container(
                              height: Sizes.screenWidth / 18,
                              width: Sizes.screenWidth / 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.yellow,
                                image: DecorationImage(
                                  image: AssetImage(Assets.dusKaDumPrintIcon),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return const DusKaDumHistoryScreen();
                              },
                            );
                          },
                          child: Container(
                            height: Sizes.screenWidth / 18,
                            width: Sizes.screenWidth / 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow,
                              image: DecorationImage(
                                image: AssetImage(Assets.dusKaDumInfoIcon),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size,
                width: size,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: Sizes.screenWidth / 14,
                      width: Sizes.screenWidth / 14,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.dusKaDumCircleButton),
                          fit: BoxFit.fill,
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (_, child) {
                        return Transform.rotate(
                          angle: _controller.value * 2 * pi,
                          child: child,
                        );
                      },
                      child: Image.asset(
                        Assets.dusKaDumCircleBorder,
                        fit: BoxFit.cover,
                        width: size,
                        height: size,
                      ),
                    ),
                    result.dusKaDumResultList.isNotEmpty &&
                            !dkdCon.resultShowTime
                        ? CText(
                          result.dusKaDumResultList.first.winNumber.toString(),
                          size: Sizes.fontSize12,
                          color: Colors.white,
                          weight: FontWeight.bold,
                        )
                        : CText(
                          '0',
                          size: Sizes.fontSize12,
                          color: Colors.white,
                          weight: FontWeight.bold,
                        ),
                  ],
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     claimPopUp(context);
              //   },
              //   child: Container(
              //     height: Sizes.screenWidth / 22,
              //     width: Sizes.screenWidth / 10,
              //     padding: EdgeInsets.only(bottom: 3),
              //     alignment: Alignment.center,
              //     decoration: BoxDecoration(
              //       image: DecorationImage(
              //         image: AssetImage(Assets.dusKaDumClaimBtnBg),
              //         fit: BoxFit.fitWidth,
              //       ),
              //     ),
              //     child: CText(
              //       "claim".toUpperCase(),
              //       weight: FontWeight.bold,
              //       color: Color(0xffc70202),
              //       size: Sizes.fontSize6,
              //     ),
              //   ),
              // ),
              Sizes.spaceH5,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textField(ticketController),
                  SizedBox(
                    width: screenWidth * 0.07,
                    child: Lucky12Btn(
                      height: screenHeight * 0.07,
                      title: 'CHECK',
                      onTap: () async {
                        await check
                            .dusKaDumCheckApi(context, ticketController.text)
                            .then((_) {
                              ticketController.clear();
                            });
                      },
                    ),
                  ),
                ],
              ),
              Sizes.spaceH10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  labelTile(
                    "play",
                    "${dkdCon.playBetAmount}",
                    textColor: Color(0xffc70202),
                    width: 10,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5),
                    ),
                  ),
                  labelTile(
                    "win",
                    "0",
                    textColor: Color(0xffc70202),
                    width: 10,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget textField(ticketController) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(width: 3, color: Color(0xffc70202)),
    );
    return TextField(
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        constraints: BoxConstraints(
          maxHeight: 35,
          maxWidth: Sizes.screenWidth / 7,
        ),
        contentPadding: EdgeInsets.only(
          left: 10,
          top: 0,
          right: 10,
          bottom: 14,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
      ),
      controller: ticketController,
      textAlignVertical: TextAlignVertical.top,
    );
  }

  Widget bettingNumTile(int number) {
    return Consumer<DusKaDumController>(
      builder: (context, dkdCon, _) {
        final betData = dkdCon.getBetDataForNumber(number);
        return GestureDetector(
          onTap: () {
            dkdCon.addBetOnNumber(number);
          },
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: Sizes.screenWidth / 17,
                width: Sizes.screenWidth / 17,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 3),
                  shape: BoxShape.circle,
                  color: Colors.yellow,
                ),
                clipBehavior: Clip.none,
                alignment: Alignment.center,
              ),
              Container(
                height: Sizes.screenWidth / 14,
                width: Sizes.screenWidth / 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(Assets.dusKaDumCircleBorder),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              CText("$number", size: Sizes.fontSize12, weight: FontWeight.bold),
              if (betData != null)
                Container(
                  height: Sizes.screenWidth / 28,
                  width: Sizes.screenWidth / 28,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: getCoinImageAsPerUserBet(betData['amount']),
                      fit: BoxFit.fill,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: CText(
                    "${betData['amount']}",
                    color: Colors.black,
                    weight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget labelTile(
    String key,
    String value, {
    Color color = Colors.white,
    Color textColor = Colors.black,
    BorderRadiusGeometry? borderRadius,
    double? width,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 8),
      alignment: Alignment.centerLeft,
      height: Sizes.screenHeight / 20,
      width: Sizes.screenWidth / (width ?? 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius ?? BorderRadius.circular(3),
        border: Border.all(width: 2, color: textColor),
      ),
      child: CText(
        '${key.toUpperCase()} - $value',
        size: Sizes.fontSize4,
        weight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget dummyTableWidget() {
    return Consumer<DusKaDumResultViewModel>(
      builder: (context, dkdResultCon, _) {
        final resultData = dkdResultCon.dusKaDumResultList;
        return Table(
          border: TableBorder.all(color: Colors.grey),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1.5),
            2: FlexColumnWidth(2),
          },
          children: [
            // Table Header
            TableRow(
              decoration: BoxDecoration(color: Colors.blue.shade200),
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Time'.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: Sizes.fontSize4P5,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Result'.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: Sizes.fontSize4P5,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Jackpot'.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: Sizes.fontSize4P5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Table Rows
            for (int i = 0; i < resultData.length; i++)
              TableRow(
                decoration: BoxDecoration(
                  color: i % 2 == 0 ? Colors.grey.shade200 : Colors.white,
                ),
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 7,
                      ),
                      child: Text(
                        resultData[i].time.toString().substring(11, 16),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: Sizes.fontSize4,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 7,
                      ),
                      child: Text(
                        resultData[i].winNumber.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: Sizes.fontSize4,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color:
                        resultData[i].jackpot > 1
                            ? Colors.red
                            : Colors.transparent,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 7,
                        ),
                        child: Text(
                          resultData[i].jackpot > 1
                              ? "${resultData[i].jackpot}x"
                              : 'No',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: Sizes.fontSize4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget dummyPolygon() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                barrierColor: Colors.transparent,
                builder: (BuildContext context) {
                  return Luck16ExitPopUp(
                    yes: () {
                      final dkdCon = Provider.of<DusKaDumController>(
                        context,
                        listen: false,
                      );
                      dkdCon.disConnectToServer(context);
                      Navigator.pushReplacementNamed(
                        context,
                        RoutesName.dashboard,
                      );
                    },
                  );
                },
              );
            },
            child: Container(
              height: screenWidth * 0.03,
              width: screenWidth * 0.03,
              margin: EdgeInsets.only(right: screenWidth * 0.01),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.lucky12Close),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Column(
            children: List.generate(6, (i) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: Sizes.screenWidth / 20,
                width: Sizes.screenWidth / 20,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: AssetImage(Assets.dusKaDum8Side),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget bottomActionBar() {
    return Consumer<DusKaDumController>(
      builder: (context, dkdCon, _) {
        return Container(
          width: Sizes.screenWidth,
          height: Sizes.screenHeight / 9,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(right: 15, left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Sizes.spaceW15,
              radialButton(
                height: 10,
                radius: 30,
                bColor: Color(0xffEFC978),
                child: Row(
                  children: List.generate(dkdCon.coinList.length, (coinIndex) {
                    final coin = dkdCon.coinList[coinIndex];
                    return coinData(coin);
                  }),
                ),
              ),
              actionButtons(
                'Rebate',
                onTap: () {
                  dkdCon.rebate();
                },
              ),
              actionButtons(
                'Double Up',
                onTap: () {
                  dkdCon.doubleUpBet();
                },
              ),
              actionButtons(
                'Clear',
                onTap: () {
                  dkdCon.clearBet();
                },
              ),
              actionButtons(
                'Exit',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  radialButton({
    Color bColor = Colors.blue,
    Widget? child,
    double radius = 15,
    double width = 2.7,
    double height = 8,
  })
  {
    return Container(
      height: Sizes.screenHeight / (height),
      width: Sizes.screenWidth / (width),
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: bColor, width: 2),
          left: BorderSide(color: bColor, width: 2),
          right: BorderSide(color: bColor, width: 2),
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(radius),
          topLeft: Radius.circular(radius),
        ),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  Widget coinData(LuckyCoinModel coin) {
    return Consumer<DusKaDumController>(
      builder: (context, dkdCon, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: () {
              dkdCon.selectChip(coin.value);
            },
            child: Container(
              height: Sizes.screenWidth / 28,
              width: Sizes.screenWidth / 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    dkdCon.selectedChip == coin.value
                        ? Border.all(color: Color(0xffEFC978), width: 2.5)
                        : null,
                image: DecorationImage(
                  image: AssetImage(coin.image),
                  fit: BoxFit.fill,
                ),
              ),
              alignment: Alignment.center,
              child: CText(
                "${coin.value}",
                color: Colors.black,
                weight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget actionButtons(
    String label, {
    void Function()? onTap,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: Sizes.screenHeight / 13,
        width: Sizes.screenWidth / 10,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.dusKaDumSquriBtnBg),
            fit: BoxFit.fill,
          ),
        ),
        child: CText(
          label,
          size: Sizes.fontSize6,
          color: enabled ? Color(0xffEFC978) : CupertinoColors.systemGrey2,
          weight: FontWeight.bold,
        ),
      ),
    );
  }

  AssetImage getCoinImageAsPerUserBet(int amount) {
    switch (amount) {
      case < 2:
        return AssetImage(Assets.lucky16LC20);
      case < 5:
        return AssetImage(Assets.lucky16LC10);
      case < 10:
        return AssetImage(Assets.lucky16LC50);
      case < 100:
        return AssetImage(Assets.lucky16LC5);
      case < 500:
        return AssetImage(Assets.lucky16LC20);
      case < 1000:
        return AssetImage(Assets.lucky16LC10);
      default:
        return AssetImage(Assets.lucky16LC50);
    }
  }

  ///Claim
  // void claimPopUp(BuildContext context) {
  //   final checkData = Provider.of<DusKaDumCheckViewModel>(
  //     context,
  //     listen: false,
  //   );
  //   showCupertinoDialog(
  //     context: context,
  //     builder:
  //         (context) => AlertDialog(
  //       title: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text("Claim Ticket Id"),
  //           InkWell(
  //             onTap: () {
  //               Navigator.pop(context);
  //             },
  //             child: Container(
  //               padding: EdgeInsets.all(3),
  //               decoration: BoxDecoration(
  //                 color: Colors.red,
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Icon(
  //                 CupertinoIcons.clear_circled,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //       content: Stack(
  //         clipBehavior: Clip.none,
  //         alignment: Alignment.topCenter,
  //         children: [
  //           Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               SizedBox(height: 10),
  //               CupertinoTextField(
  //                 controller: ticketController,
  //                 autofocus: true,
  //                 placeholder: "Enter your Ticket I'd",
  //                 padding: EdgeInsets.all(10),
  //                 keyboardType: TextInputType.number,
  //               ),
  //               SizedBox(height: screenHeight * 0.02),
  //               Lucky12Btn(
  //                 title: 'CHECK',
  //                 onTap: () async {
  //                   await checkData.dusKaDumCheckApi(
  //                       context,
  //                       ticketController.text
  //                   );
  //                   // Navigator.pop(context);
  //                 },
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
