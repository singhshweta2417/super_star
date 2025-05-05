import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:super_star/andar_bahar/controller/andar_bahar_controller.dart';
import 'package:super_star/andar_bahar/widgets/andar_bahar_history.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/main.dart';

import '../../spin_to_win/view_model/profile_view_model.dart';

class BottomCoinList extends StatelessWidget {
  const BottomCoinList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    return Consumer<AndarBaharController>(builder: (context, abc, child) {
      return Container(
        height: screenHeight * 0.2,
        width: screenWidth * 0.8,
        alignment: Alignment.center,
        padding:  EdgeInsets.only(top: screenHeight*0.05),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Assets.andarBBottomStripBg),
                fit: BoxFit.fill)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    height: screenHeight * 0.08,
                    width: screenWidth * 0.2,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(Assets.andarBPlayerWallet))),
                    child: FittedBox(
                      child: Text(
                        profileViewModel.balance.toStringAsFixed(2),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -10,
                    child: Container(
                      height: screenHeight*0.13,
                      width: screenHeight*0.13,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(Assets.andarBABPro),
                              fit: BoxFit.fill)),
                    ),
                  ),
                  Positioned(
                    right: -30,
                    child: GestureDetector(
                      onTap: () {
                        // Add Balance
                      },
                      child: Container(
                        height: screenHeight*0.06,
                        width: screenWidth*0.09,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(Assets.andarBAddIcon),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                // history popup
                showDialog(
                  context: context,
                  barrierColor: Colors.transparent,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const AndarBaharHistory();
                  },
                );
              },
              child: Container(
                height: screenHeight*0.11,
                width: screenWidth*0.06,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Assets.andarBBetHistory),
                        fit: BoxFit.fill)),
              ),
            ),
            Expanded(
              // width: screenWidth * 0.38,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(abc.coinList.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      // add bet
                      abc.andarBaharAddBet(abc.betSetPosition,
                          abc.coinList[index].value, context);
                    },
                    child: Stack(
                      children: [
                        Container(
                          // key: abc.globalKey[index],
                          height: screenHeight*0.11,
                          width: screenHeight*0.11,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image:
                                      AssetImage(abc.coinList[index].image))),
                        ),
                        if (!abc.isPlayAllowed() )
                          Container(
                            height: screenHeight*0.11,
                            width: screenHeight*0.11,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                          )
                      ],
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      );
    });
  }
}
