import 'package:flutter/material.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/main.dart';


class GameRules extends StatefulWidget {
  const GameRules({super.key});

  @override
  State<GameRules> createState() => _GameRulesState();
}

class _GameRulesState extends State<GameRules> {
  List ruleList = [
    "On an Andar Bahar table, there are two sets of boxes, these are labeled Andar and Bahar.",
    "It is played with a single set of cards that the dealer shuffles before every round.",
    "The game begins when the dealer reveals the first card known as Joker and places it at the center of the table.",
    "Next, all players on the table place their bets by choosing whether the Joker will land on the Andar set or Bahar box.",
    "These initial bets are placed on the box labeled 1st bet for both the box.",
    "After every player has placed their 1st bet, the dealer calls no more bets and begins drawing cards for each box in an alternating pattern In essence, the dealer first reveals one card for Bahar followed by one card for Andar.",
    "If the Joker appears on the first card drawn for the Andar set, all players betting on Andar are paid even money, and all players betting on Bahar lose.",
    "If the Joker appears on the first card drawn on Bahar, then 25% of the betting amount is paid to all players betting on Bahar. Consequently, all players betting on Andar lose.",
    "If the Joker does not appear in the first two cards, the players have another opportunity to place the 2nd bet. This bet is placed on the box labeled 2nd bet for both sets.",
    "After all, players have placed their 2nd bet, the dealer calls no more bets and starts drawing cards again. These cards are placed alternatingly, first on Bahar and then on Andar until the Joker is revealed.",
    "If the first card drawn on the 2nd bet is the Joker, the 2nd bet is paid 25% of the betting amount and the first bet is paid even money.",
    "The payout for winning after this stage is even money or 1x the initial bets.",
    "Super Bahar bet is an optional bet you can place by putting your chips on the box labeled super bahar on the table. This bet can be placed during the 1st bet and the 2nd bet but only for the Bahar box.",
    "If you place a Super Bahar bet and the first card drawn is the Joker, the payout is 11x the betting amount.",
  ];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Container(
        height: screenHeight*0.6,
        width: screenWidth*0.8,
        padding: const EdgeInsets.fromLTRB(15, 3, 15, 5),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Assets.andarBBgHelp),
                fit: BoxFit.fill
            )),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: screenWidth*0.7,
                  height:35,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10))
                  ),
                  child: const Text(
                    "GAME RULES!",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 35,
                        decoration: const BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10))
                        ),
                      )),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(22, 5, 22, 15),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            alignment: Alignment.center,
                            height: screenHeight*0.26,
                            width: screenWidth*0.25,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(Assets.andarBRuleImg),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          "A lot of luck is necessary to succeed at the well-known Indian card game Andar Bahar, which can be played online.",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "However, you have a chance to win some real money if you consider using any of our Andar Bahar strategy listed below.",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          "The game of Andar Bahar moves quickly,so the rush of adrenaline when winning a multiplier bet will surely keep you glued to your seat, asking for more. ",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Basic Rules of Andar Bahar Game :-",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),

                        const Text(
                          "Some basic rules for playing the casino game Andar Bahar :-",
                          style: TextStyle(fontSize: 16, color: Colors.blue,fontWeight: FontWeight.w600),
                        ),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ruleList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, int index) {
                              return Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 25,
                                        child: Text(
                                          "${index + 1}.",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${ruleList[index]}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              );
                            })
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}