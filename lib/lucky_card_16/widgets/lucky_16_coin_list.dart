import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_star/lucky_card_16/controller/lucky_16_controller.dart';
import 'package:super_star/main.dart';
import 'package:super_star/res/app_constant.dart';

class Lucky16CoinList extends StatelessWidget {
  const Lucky16CoinList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Lucky16Controller>(builder: (context, l16c, child) {
      return  SizedBox(
            height: screenHeight * 0.12,
            width: screenWidth * 0.356,
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: List.generate(
                l16c.coinList.length,
                    (index) => GestureDetector(
                  onTap: () {
                    l16c.selectIndex(
                        index,
                        l16c
                            .coinList[index].value);
                  },
                  child: Container(
                    height: screenHeight * 0.08,
                    width: screenHeight * 0.08,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.5,
                          color:
                          l16c.selectedIndex ==
                              index
                              ? Colors.yellow
                              : Colors
                              .transparent),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      height: screenHeight * 0.08,
                      width: screenHeight * 0.08,
                      padding: const EdgeInsets.only(top: 2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(l16c
                                  .coinList[index]
                                  .image))),
                      child: Text(
                        l16c.coinList[index].value.toString(),
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
      }
    );
  }
}