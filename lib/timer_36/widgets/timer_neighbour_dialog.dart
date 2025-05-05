import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_star/timer_36/controller/timer_36_controller.dart';
import 'package:super_star/timer_36/widgets/timer_36_board.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';

class TimerNeighbourDialog extends StatelessWidget {
  const TimerNeighbourDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Timer36Controller>(builder: (context, rbc, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(Assets.timer36Cancel, scale: 2)),
            ],
          ),
          Container(
            alignment: Alignment.center,
            height: screenHeight * 0.3,
            width: screenWidth * 0.8,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Assets.timer36BlueNeighbour),
                    fit: BoxFit.fill)),
            child: Container(
              height: screenHeight * 0.11,
              width: screenWidth * 0.71,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      rbc.activeSingleBet(206, rbc.betValue, context);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: screenWidth * 0.2,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                            ),
                          ),
                        ),
                        if (rbc.bets
                            .where((e) => e['game_id'] == 206)
                            .isNotEmpty)
                          Container(
                            height: screenWidth * 0.03,
                            width: screenWidth * 0.03,
                            alignment: Alignment.center,
                            decoration: getCoinDecoration(206, rbc),
                            child: FittedBox(
                              child: Text(
                                rbc.bets
                                    .where((e) => e['game_id'] == 206)
                                    .first["amount"]
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: rbc.bets
                                                .where(
                                                    (e) => e['game_id'] == 206)
                                                .first["amount"]
                                                .toString()
                                                .length ==
                                            1
                                        ? screenWidth * 0.02
                                        : rbc.bets
                                                    .where((e) =>
                                                        e['game_id'] == 206)
                                                    .first["amount"]
                                                    .toString()
                                                    .length ==
                                                2
                                            ? screenWidth * 0.015
                                            : screenWidth * 0.01),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      rbc.activeSingleBet(207, rbc.betValue, context);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: screenWidth * 0.18,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                            ),
                          ),
                        ),
                        if (rbc.bets
                            .where((e) => e['game_id'] == 207)
                            .isNotEmpty)
                          Container(
                            height: screenWidth * 0.03,
                            width: screenWidth * 0.03,
                            alignment: Alignment.center,
                            decoration: getCoinDecoration(207, rbc),
                            child: FittedBox(
                              child: Text(
                                rbc.bets
                                    .where((e) => e['game_id'] == 207)
                                    .first["amount"]
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: rbc.bets
                                                .where(
                                                    (e) => e['game_id'] == 207)
                                                .first["amount"]
                                                .toString()
                                                .length ==
                                            1
                                        ? screenWidth * 0.02
                                        : rbc.bets
                                                    .where((e) =>
                                                        e['game_id'] == 207)
                                                    .first["amount"]
                                                    .toString()
                                                    .length ==
                                                2
                                            ? screenWidth * 0.015
                                            : screenWidth * 0.01),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      rbc.activeSingleBet(208, rbc.betValue, context);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: screenWidth * 0.2,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                            ),
                          ),
                        ),
                        if (rbc.bets
                            .where((e) => e['game_id'] == 208)
                            .isNotEmpty)
                          Container(
                            height: screenWidth * 0.03,
                            width: screenWidth * 0.03,
                            alignment: Alignment.center,
                            decoration: getCoinDecoration(208, rbc),
                            child: FittedBox(
                              child: Text(
                                rbc.bets
                                    .where((e) => e['game_id'] == 208)
                                    .first["amount"]
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: rbc.bets
                                                .where(
                                                    (e) => e['game_id'] == 208)
                                                .first["amount"]
                                                .toString()
                                                .length ==
                                            1
                                        ? screenWidth * 0.02
                                        : rbc.bets
                                                    .where((e) =>
                                                        e['game_id'] == 208)
                                                    .first["amount"]
                                                    .toString()
                                                    .length ==
                                                2
                                            ? screenWidth * 0.015
                                            : screenWidth * 0.01),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        rbc.activeSingleBet(209, rbc.betValue, context);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: screenWidth * 0.2,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                            ),
                          ),
                          if (rbc.bets
                              .where((e) => e['game_id'] == 209)
                              .isNotEmpty)
                            Container(
                              height: screenWidth * 0.03,
                              width: screenWidth * 0.03,
                              alignment: Alignment.center,
                              decoration: getCoinDecoration(209, rbc),
                              child: FittedBox(
                                child: Text(
                                  rbc.bets
                                      .where((e) => e['game_id'] == 209)
                                      .first["amount"]
                                      .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: rbc.bets
                                                  .where((e) =>
                                                      e['game_id'] == 209)
                                                  .first["amount"]
                                                  .toString()
                                                  .length ==
                                              1
                                          ? screenWidth * 0.02
                                          : rbc.bets
                                                      .where((e) =>
                                                          e['game_id'] == 209)
                                                      .first["amount"]
                                                      .toString()
                                                      .length ==
                                                  2
                                              ? screenWidth * 0.015
                                              : screenWidth * 0.01),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
