import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_star/andar_bahar/controller/andar_bahar_controller.dart';
import 'package:super_star/andar_bahar/view_model/andar_bahar_result_view_model.dart';
import 'package:super_star/andar_bahar/widgets/andar_bahar_exit.dart';
import 'package:super_star/andar_bahar/widgets/andar_bahar_info.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/main.dart';
import 'package:super_star/res/app_constant.dart';
import 'package:super_star/utils/routes/routes_name.dart';

class ResultAndTimer extends StatefulWidget {
  const ResultAndTimer({super.key});

  @override
  State<ResultAndTimer> createState() => _ResultAndTimerState();
}

class _ResultAndTimerState extends State<ResultAndTimer> {
  @override
  Widget build(BuildContext context) {
    final andarBaharResultViewModel =
    Provider.of<AndarBaharResultViewModel>(context);
    return Consumer<AndarBaharController>(builder: (context, abc, child) {
      return SizedBox(
        width: screenWidth,
        height: screenHeight * 0.35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap:(){
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
                    child: Container(
                      height: screenHeight*0.2,
                      width: screenWidth*0.06,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(Assets.andarBBack))),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      // info
                      showDialog(
                        context: context,
                        barrierColor: Colors.transparent,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const GameRules();
                        },
                      );
                    },
                    child: Container(
                      height: screenHeight*0.2,
                      width: screenWidth*0.05,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                              AssetImage(Assets.andarBInfo))),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: screenHeight * 0.35,
              width: screenWidth * 0.55,
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Assets.andarBCardShowBg),
                      fit: BoxFit.fill)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: screenHeight*0.09,
                        width: screenWidth * 0.15,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    Assets.andarBAndarBtn),
                                fit: BoxFit.fill)),
                      ),
                      SizedBox(
                        width: screenWidth * 0.3,
                        height: screenHeight*0.09,
                        child:abc.andarList.isNotEmpty? Stack(
                          children: List.generate(abc.andarList.length,
                                  (index) {
                                List<String> showImages =
                                abc.getCardImages(abc.andarList);
                                return Positioned(
                                  left: index * 12.5,
                                  child: Container(
                                    height: screenWidth * 0.05,
                                    width: screenWidth * 0.03,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            showImages[index]),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ):null,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: screenHeight*0.09,
                        width: screenWidth * 0.15,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    Assets.andarBBaharBtn),
                                fit: BoxFit.fill)),
                      ),
                      SizedBox(
                        width: screenWidth * 0.3,
                        height: screenHeight*0.09,
                        child: abc.baharList.isNotEmpty?Stack(
                          children: List.generate(abc.baharList.length,
                                  (index) {
                                List<String> showImages =
                                abc.getCardImages(abc.baharList);
                                return Positioned(
                                  left: index * 12.5,
                                  child: Container(
                                    height: screenWidth * 0.05,
                                    width: screenWidth * 0.03,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            showImages[index]),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ):null,
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: screenHeight*0.08,
                    width: screenWidth * 0.48,
                    padding:
                    const EdgeInsets.only(left: 5, right: 5),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                Assets.andarBLastResultBg),
                            fit: BoxFit.fill)),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: List.generate(andarBaharResultViewModel.lastResultList.length + 1,
                              (index) {
                            if (index == andarBaharResultViewModel.lastResultList.length) {
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: AppConstant.anBaResSize,
                                  width: AppConstant.anBaResSize,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(Assets
                                              .andarBHistoryArrow))),
                                ),
                              );
                            }
                            return Container(
                              height: AppConstant.anBaResSize,
                              width: AppConstant.anBaResSize,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        andarBaharResultViewModel.lastResultList[index].number == 1
                                            ? Assets.andarBA
                                            : Assets.andarBB,
                                      ))),
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height:screenHeight*0.2,
                width: screenWidth*0.08,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 15, right: 30),
                padding: const EdgeInsets.only(top: 2),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Assets.andarBWatch),
                      fit: BoxFit.fill),
                ),
                child:  Text(abc.timerStatus==1?abc.timerBetTime.toString():'0',
                    style:  TextStyle(
                        color: Colors.black,
                        fontSize: AppConstant.anBaTimerFont,
                        fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      );
    }
    );
  }
}