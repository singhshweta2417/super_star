import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/main.dart';
import 'package:super_star/triple_chance/controller/triple_chance_controller.dart';

class DoubleBetGrid extends StatelessWidget {
  const DoubleBetGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TripleChanceController>(builder: (context, tcc, child) {
      return Container(
        height: screenHeight,
        width: screenWidth * 0.5,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Assets.tripleChanceDoubleSlideBg),
                fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: screenWidth * 0.025,
                  margin: EdgeInsets.only(
                      left: screenWidth * 0.01,
                      right: screenWidth * 0.006,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        10,
                        (index) => GestureDetector(
                              onTap: () {
                                if (tcc.addTripleChanceBets.isEmpty &&
                                    tcc.resetOne == true) {
                                  tcc.setResetOne(false);
                                }
                                tcc.doubleRowAddBets(
                                    index, tcc.selectedValue, 2, context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: screenHeight*0.008),
                                height: screenHeight * 0.070,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            Assets.tripleChanceSHBtnBg))),
                              ),
                            )),
                  ),
                ),
                Container(
                  width: screenWidth * 0.398,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 2, color: Colors.yellow)),
                  margin: const EdgeInsets.only(top: 2),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(1.5),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 10,
                        mainAxisExtent: screenHeight * 0.075,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1),
                    itemCount: 100,
                    itemBuilder: (context, index) {
                      int row = index ~/ 10;
                      int column = index % 10;
                      Color color = tcc.colors[(row + column) % 2];
                      return GestureDetector(
                        onTap: () {
                          if (tcc.addTripleChanceBets.isEmpty &&
                              tcc.resetOne == true) {
                            tcc.setResetOne(false);
                          }
                          tcc.singleAddBet(index.toString().padLeft(2, '0'),
                              tcc.selectedValue, 2, context);
                        },
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              image: tcc.addTripleChanceBets.isNotEmpty &&
                                      tcc.addTripleChanceBets
                                          .where((value) =>
                                              value["game_id"] ==
                                              index.toString().padLeft(2, '0'))
                                          .isNotEmpty
                                  ? const DecorationImage(
                                      image:
                                          AssetImage(Assets.tripleChanceBetBg),fit: BoxFit.fill)
                                  : null,
                              color: tcc.addTripleChanceBets.isEmpty ||
                                      tcc.addTripleChanceBets
                                          .where((value) =>
                                              value["game_id"] ==
                                              index.toString().padLeft(2, '0'))
                                          .isEmpty
                                  ? color
                                  : null,
                            ),
                            child: tcc.addTripleChanceBets.isEmpty ||
                                    tcc.addTripleChanceBets
                                        .where((value) =>
                                            value["game_id"] ==
                                            index.toString().padLeft(2, '0'))
                                        .isEmpty
                                ? Text(
                                    index.toString().padLeft(2, '0'),
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: screenHeight*0.035,
                                          alignment: Alignment.center,
                                          child: Text(
                                            index.toString().padLeft(2, '0'),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "roboto_bl"),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              tcc.addTripleChanceBets
                                                  .where((e) =>
                                                      e['game_id'] ==
                                                      index
                                                          .toString()
                                                          .padLeft(2, '0'))
                                                  .first["amount"]
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: screenWidth * 0.047,
                  height: screenWidth * 0.40,
                  margin: EdgeInsets.only(
                    left: screenWidth * 0.003,
                  ),
                  decoration: const BoxDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        tcc.commonListAll.length,
                        (index) => GestureDetector(
                              onTap: () {
                                tcc.setRenD(index);
                                tcc.randomDoubleBets(tcc.commonListAll[index],
                                    tcc.selectedValue, 2, context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: screenHeight * 0.06,
                                width: screenWidth * 0.04,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: tcc.ranDoubleTrackList.isNotEmpty &&
                                          tcc.selectRenDouble == index
                                      ? const Color(0xfffeb400)
                                      : const Color(0xffc30c09),
                                ),
                                child: Text(
                                  tcc.commonListAll[index].toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                  ),
                ),
              ],
            ),
            Container(
              width: screenWidth * 0.39,
              margin: EdgeInsets.only(
                  left: screenWidth * 0.043, bottom: screenWidth * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    10,
                    (index) => GestureDetector(
                          onTap: () {
                            if (tcc.addTripleChanceBets.isEmpty &&
                                tcc.resetOne == true) {
                              tcc.setResetOne(false);
                            }
                            tcc.doubleColumnAddBets(
                                index, tcc.selectedValue, 2, context);
                          },
                          child: Container(
                            height: screenHeight * 0.05,
                            width: screenWidth * 0.034,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage(Assets.tripleChanceSBtnBg),
                                    fit: BoxFit.fill)),
                          ),
                        )),
              ),
            ),
          ],
        ),
      );
    });
  }
}
