import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/main.dart';
import 'package:super_star/triple_chance/controller/triple_chance_controller.dart';

class SingleBetGrid extends StatelessWidget {
  const SingleBetGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TripleChanceController>(builder: (context, tcc, child) {
      return Container(
        height: screenHeight,
        width: screenWidth * 0.2,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [
              Color(0xffc39e38),
              Color(0xfffaf291),
              Color(0xffc39e38),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(5)),
        child: Container(
          height: screenHeight * 0.9,
          width: screenWidth * 0.18,
          color: Colors.black,
          child: GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(2),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: screenHeight * 0.1755,
                crossAxisSpacing: screenHeight * 0.004,
                mainAxisSpacing: screenHeight * 0.004,
            ),
            itemCount: 10,
            itemBuilder: (context, index) {
              int row = index ~/ 2;
              int column = index % 2;
              Color color = tcc.colors[(row + column) % 2];
              return GestureDetector(
                onTap: () {
                  if (tcc.addTripleChanceBets.isEmpty && tcc.resetOne == true) {
                    tcc.setResetOne(false);
                  }
                  tcc.singleAddBet(index, tcc.selectedValue, 1, context);
                },
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: tcc.addTripleChanceBets.isNotEmpty &&
                              tcc.addTripleChanceBets
                                  .where((value) => value["game_id"] == index)
                                  .isNotEmpty
                          ? const DecorationImage(
                              image: AssetImage(Assets.tripleChanceBetBg),fit: BoxFit.fill)
                          : null,
                      color: tcc.addTripleChanceBets.isEmpty ||
                              tcc.addTripleChanceBets
                                  .where((value) => value["game_id"] == index)
                                  .isEmpty
                          ? color
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: tcc.addTripleChanceBets.isEmpty ||
                            tcc.addTripleChanceBets
                                .where((value) => value["game_id"] == index)
                                .isEmpty
                        ? Text(
                            index.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Container(
                                  height: screenHeight*0.08,
                                  alignment: Alignment.center,
                                  child: Text(
                                    index.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "roboto_bl"),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      tcc.addTripleChanceBets
                                          .where((e) => e['game_id'] == index)
                                          .first["amount"]
                                          .toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
              );
            },
          ),
        ),
      );
    });
  }
}
