import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_star/andar_bahar/controller/andar_bahar_controller.dart';
import 'package:super_star/andar_bahar/view_model/andar_bahar_result_view_model.dart';
import 'package:super_star/andar_bahar/widgets/result_and_timer.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/main.dart';
import 'package:super_star/res/app_constant.dart';
import 'package:super_star/utils/routes/routes_name.dart';

import 'widgets/andar_bahar_exit.dart';
import 'widgets/andar_bahar_loading.dart';
import 'widgets/bottom_coin_list.dart';
import 'widgets/fade_animation.dart';
import 'widgets/glory_border.dart';

class AnderBahar extends StatefulWidget {
  const AnderBahar({super.key});

  @override
  State<AnderBahar> createState() => _AnderBaharState();
}

class _AnderBaharState extends State<AnderBahar> {
  late Function(GlobalKey<CartIconKey>) runAddToCartAnimation;
  GlobalKey<CartIconKey> andarThrowCoin = GlobalKey<CartIconKey>();
  GlobalKey<CartIconKey> baharThrowCoin = GlobalKey<CartIconKey>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final abc = Provider.of<AndarBaharController>(context, listen: false);
      abc.connectToServer(context);
      final andarBaharResultViewModel =
          Provider.of<AndarBaharResultViewModel>(context, listen: false);
      andarBaharResultViewModel.anderBaharResultApi(context, 1);
      abc.randomPerValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AndarBaharController>(builder: (context, abc, child) {
      return AddToCartAnimation(
          cartKey: abc.betSetPosition == 1 ? andarThrowCoin : baharThrowCoin,
          height: 15,
          width: 15,
          opacity: 0.85,
          dragAnimation: const DragToCartAnimationOptions(
            rotation: false,
          ),
          jumpAnimation: const JumpAnimationOptions(),
          createAddToCartAnimation: (runAddToCartAnimation) {
            this.runAddToCartAnimation = runAddToCartAnimation;
          },
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (bool didPop, Object? result) {
              showDialog(
                context: context,
                barrierColor: Colors.transparent,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AndarBaharExit(
                    onTap: () {
                      abc.disConnectToServer(context);
                      abc.setPageLoading(false);
                      Navigator.pushReplacementNamed(
                          context, RoutesName.dashboard);
                    },
                  );
                },
              );
            },
            child: Scaffold(
              body: !abc.pageLoading
                  ? const AndarBaharLoading()
                  : Center(
                    child: Container(
                        height: screenHeight,
                        width: screenWidth,
                        alignment: Alignment.bottomCenter,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(Assets.andarBAndarBaharBg),
                                fit: BoxFit.fill)),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              height: screenHeight * 0.8,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(Assets.andarBAndarBaharTable),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const ResultAndTimer(),
                                SizedBox(
                                  height: screenHeight * 0.45,
                                  width: screenWidth,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 50),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                height: 50,
                                                width: 50,
                                                decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(Assets
                                                            .andarBOnlineUsers))),
                                              ),
                                               Text(
                                                 abc.renVal!=null?abc.renVal.toString():'',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: screenHeight * 0.45,
                                        width: screenWidth * 0.7,
                                        padding: EdgeInsets.only(top: screenHeight*0.1),
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    Assets.andarBChipsBg),
                                                fit: BoxFit.fill)),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: screenHeight*0.09,
                                                  width: screenWidth * 0.15,
                                                  decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(Assets
                                                              .andarBAndarBtn),
                                                          fit: BoxFit.fill)),
                                                ),
                                                if (abc.showBetCard)
                                                  AnimatedGradientBorder(
                                                      borderSize: 3,
                                                      gradientColors: const [
                                                        Color(0xfffaee72),
                                                        Colors.transparent,
                                                        Color(0xfffaee72),
                                                      ],
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                        Radius.circular(5),
                                                      ),
                                                      child: Container(
                                                        height: screenWidth*0.045,
                                                        width: screenWidth*0.03,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(abc
                                                                    .cardMatchList
                                                                    .firstWhere((card) =>
                                                                        card.cardColor ==
                                                                            abc
                                                                                .showCardColor &&
                                                                        card.value ==
                                                                            abc.showCardValue)
                                                                    .image),
                                                                fit: BoxFit.fill)),
                                                      ))
                                                else
                                                  FadeInUpBig(
                                                      child: Container(
                                                    height: screenWidth*0.05,
                                                    width: screenWidth*0.035,
                                                    decoration: const BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                Assets
                                                                    .cardFireCard),
                                                            fit: BoxFit.fill)),
                                                  )),
                                                Container(
                                                  height: screenHeight*0.09,
                                                  width: screenWidth * 0.15,
                                                  decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(Assets
                                                              .andarBBaharBtn),
                                                          fit: BoxFit.fill)),
                                                ),
                                              ],
                                            ),
                                             SizedBox(height: AppConstant.anBaCoinConCe),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    abc.setBetPosition(1);
                                                  },
                                                  child: Container(
                                                    key: andarThrowCoin,
                                                    height: screenHeight * 0.19,
                                                    width: screenWidth * 0.3,
                                                    decoration: BoxDecoration(
                                                        color: Colors.blue
                                                            .withValues(alpha: 0.5),
                                                        border: Border.all(
                                                            width: 3,
                                                            color: abc.betSetPosition ==
                                                                    1
                                                                ? Colors.green
                                                                : Colors
                                                                    .transparent),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5)),
                                                    child: Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Positioned(
                                                          left: -80,
                                                          top: 10,
                                                          child: Stack(
                                                            children: abc
                                                                .anderRandomCoins,
                                                          ),
                                                        ),
                                                        Stack(
                                                          children: [
                                                            for (var data in abc
                                                                .anderUserCoins)
                                                              data,
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    abc.setBetPosition(2);
                                                  },
                                                  child: Container(
                                                    key: baharThrowCoin,
                                                    height: screenHeight * 0.19,
                                                    width: screenWidth * 0.3,
                                                    decoration: BoxDecoration(
                                                        color: Colors.blue
                                                            .withValues(alpha: 0.5),
                                                        border: Border.all(
                                                            width: 3,
                                                            color: abc.betSetPosition !=
                                                                    1
                                                                ? Colors.green
                                                                : Colors
                                                                    .transparent),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5)),
                                                    child: Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Positioned(
                                                          left: -80,
                                                          top: 10,
                                                          child: Stack(
                                                            children: abc
                                                                .baharRandomCoins,
                                                          ),
                                                        ),
                                                        Stack(
                                                          children: [
                                                            for (var data in abc
                                                                .baharUserCoins)
                                                              data,
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: screenHeight*0.146,
                                          width: screenWidth*0.1,
                                          padding: const EdgeInsets.all(5),
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      Assets.andarBBetCountBg),
                                                  fit: BoxFit.fill)),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              BetAmountWidget(
                                                  img: Assets.andarBA,
                                                  amount: abc.andarTotalBetAmount
                                                      .toString()),
                                              BetAmountWidget(
                                                img: Assets.andarBB,
                                                amount: abc.baharTotalBetAmount
                                                    .toString(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const BottomCoinList(),
                              ],
                            )
                          ],
                        ),
                      ),
                  ),
            ),
          ));
    });
  }
}

class BetAmountWidget extends StatelessWidget {
  const BetAmountWidget({super.key, required this.img, this.amount});
  final String img;
  final String? amount;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: screenHeight*0.04,
          width: screenHeight*0.04,
          margin: const EdgeInsets.only(right: 3),
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(img), fit: BoxFit.fill)),
        ),
        Expanded(
            child: Text(
          amount ?? '0',
          style:
               TextStyle(color: Colors.white, fontWeight: FontWeight.w900,fontSize: screenHeight*0.035),
        ))
      ],
    );
  }
}
