import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/main.dart';
import 'package:super_star/triple_chance/controller/triple_chance_controller.dart';

class TripleBetGrid extends StatefulWidget {
  const TripleBetGrid({super.key});

  @override
  State<TripleBetGrid> createState() => _TripleBetGridState();
}

class _TripleBetGridState extends State<TripleBetGrid> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TripleChanceController>(builder: (context, tcc, child) {
      return Container(
        height: screenHeight,
        width: screenWidth * 0.5,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.tripleChanceTripleGridBg),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: screenWidth * 0.39,
              margin: EdgeInsets.only(left: screenWidth * 0.043),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  tcc.intList.length,
                  (index) => GestureDetector(
                    onTap: () {
                      tcc.updateGrid(int.parse(tcc.intList[index]), index);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: screenHeight * 0.05,
                      width: screenWidth * 0.037,
                      decoration: BoxDecoration(
                        color: tcc.nextIds == int.parse(tcc.intList[index])
                            ? const Color(0xfff9f803)
                            : const Color(0xffcf0b00),
                      ),
                      child: Text(
                        tcc.intList[index],
                        style: TextStyle(
                          color: tcc.nextIds == int.parse(tcc.intList[index])
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.025,
                  margin: EdgeInsets.only(
                      right: screenWidth * 0.006, top: screenWidth * 0.01),
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
                          tcc.tripleRowAddBets(index, tcc.selectedValue, 3,
                              tcc.intList[tcc.selectIndex], context);
                        },
                        child: Container(
                          margin:  EdgeInsets.only(bottom: screenHeight*0.008),
                          height: screenHeight * 0.070,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.tripleChanceSHBtnBg),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth * 0.398,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 2, color: Colors.yellow),
                  ),
                  margin: const EdgeInsets.only(top: 2),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(1.5),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10,
                      mainAxisExtent: screenHeight * 0.075,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                    ),
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
                          tcc.singleAddBet(
                              tcc.gridValues[index].toString().padLeft(3, '0'),
                              tcc.selectedValue,
                              3,
                              context);
                        },
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              image: tcc.addTripleChanceBets.isNotEmpty &&
                                      tcc.addTripleChanceBets
                                          .where((value) =>
                                              value["game_id"] ==
                                              tcc.gridValues[index]
                                                  .toString()
                                                  .padLeft(3, '0'))
                                          .isNotEmpty
                                  ? const DecorationImage(
                                      image:
                                          AssetImage(Assets.tripleChanceBetBg),fit: BoxFit.fill)
                                  : null,
                              color: tcc.addTripleChanceBets.isEmpty ||
                                      tcc.addTripleChanceBets
                                          .where((value) =>
                                              value["game_id"] ==
                                              tcc.gridValues[index]
                                                  .toString()
                                                  .padLeft(3, '0'))
                                          .isEmpty
                                  ? color
                                  : null,
                            ),
                            child: tcc.addTripleChanceBets.isEmpty ||
                                    tcc.addTripleChanceBets
                                        .where((value) =>
                                            value["game_id"] ==
                                            tcc.gridValues[index]
                                                .toString()
                                                .padLeft(3, '0'))
                                        .isEmpty
                                ? Text(
                                    tcc.gridValues[index]
                                        .toString()
                                        .padLeft(3, '0'),
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 16,
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
                                            tcc.gridValues[index]
                                                .toString()
                                                .padLeft(3, '0'),
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
                                                      tcc.gridValues[index]
                                                          .toString()
                                                          .padLeft(3, '0'))
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
                SizedBox(
                  width: screenWidth * 0.047,
                  height: screenWidth * 0.38,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      tcc.commonListAll.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            tcc.setRenT(index);
                            tcc.randomTripleBets(
                                tcc.commonListAll[index],
                                tcc.selectedValue,
                                3,
                                tcc.intList[tcc.selectIndex],
                                context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: screenHeight * 0.06,
                            width: screenWidth * 0.04,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: tcc.ranTripleTrackList.any(
                                (bet) =>
                                    bet['cat_id'] ==
                                        tcc.intList[tcc.selectIndex] &&
                                    tcc.selectRenTriple == index,
                              )
                                  ? const Color(0xfffeb400)
                                  : const Color(0xffc30c09),
                            ),
                            child: Text(
                              tcc.commonListAll[index].toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
                      tcc.tripleColumnAddBets(index, tcc.selectedValue, 3,
                          tcc.intList[tcc.selectIndex], context);
                    },
                    child: Container(
                      height: screenHeight * 0.05,
                      width: screenWidth * 0.034,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.tripleChanceSBtnBg),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
