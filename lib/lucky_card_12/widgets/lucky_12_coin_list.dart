import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:super_star/lucky_card_12/controller/lucky_12_controller.dart';
import 'package:super_star/main.dart';
import 'package:super_star/res/app_constant.dart';

class Lucky12CoinList extends StatelessWidget {
  const Lucky12CoinList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Lucky12Controller>(builder: (context, l12c, child) {
      return SizedBox(
          height: screenHeight * 0.12,
          width: screenWidth * 0.35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              l12c.coinList.length,
              (index) => GestureDetector(
                onTap: () {
                  l12c.setResetOne(false);
                  l12c.chipSelectIndex(index, l12c.coinList[index].value);
                },
                child: Container(
                  height: screenHeight * 0.09,
                  width: screenHeight * 0.09,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.5,
                        color: l12c.selectedIndex == index &&
                                l12c.resetOne == false
                            ? Colors.yellow
                            : Colors.transparent),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    height: screenHeight * 0.09,
                    width: screenHeight * 0.09,
                    padding: const EdgeInsets.only(top: 2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage(l12c.coinList[index].image),
                          fit: BoxFit.fill
                        ),
                    ),
                    child: Text(
                      l12c.coinList[index].value.toString(),
                      style:  TextStyle(
                        fontSize: AppConstant.luckyCoinFont,
                        fontFamily: 'dangrek',
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ));
    });
  }
}
