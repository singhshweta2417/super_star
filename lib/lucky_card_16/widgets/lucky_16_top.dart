import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/lucky_card_12/widgets/lucky_12_btn.dart';
import 'package:super_star/lucky_card_16/controller/lucky_16_controller.dart';
import 'package:super_star/lucky_card_16/view_model/lucky_16_check_view_model.dart';
import 'package:super_star/lucky_card_16/view_model/lucky_16_result_view_model.dart';
import 'package:super_star/lucky_card_16/widgets/luck_16_exit_pop_up.dart';
import 'package:super_star/main.dart';
import 'package:super_star/res/app_constant.dart';
import 'package:super_star/utils/routes/routes_name.dart';

import '../../spin_to_win/view_model/profile_view_model.dart';

class Lucky16Top extends StatefulWidget {
  const Lucky16Top({super.key});

  @override
  State<Lucky16Top> createState() => _Lucky16TopState();
}

class _Lucky16TopState extends State<Lucky16Top> {
  final TextEditingController ticketController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    final lucky16ResultViewModel = Provider.of<Lucky16ResultViewModel>(context);
    final balanceWithWinAmount =
        double.parse(profileViewModel.balance.toString());
    return Consumer<Lucky16Controller>(
      builder: (context, l16c, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              height: screenHeight * 0.08,
              width: screenWidth * 0.2,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.lucky16LBgBlue),
                  fit: BoxFit.fill,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'GAME ID :',
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppConstant.luckyKaFont,
                      fontFamily: 'kalam',
                    ),
                  ),
                  Text(
                    lucky16ResultViewModel.lucky16ResultList.isNotEmpty
                        ? (lucky16ResultViewModel
                                    .lucky16ResultList
                                    .first
                                    .periodNo! +
                                1)
                            .toString()
                        : '',
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppConstant.luckyKaFont,
                      fontFamily: 'kalam',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              height: screenHeight * 0.08,
              width: screenWidth * 0.2,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Assets.lucky16LBgBlue),
                      fit: BoxFit.fill)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'DRAW TIME :',
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: AppConstant.luckyKaFont,
                        fontFamily: 'kalam'),
                  ),
                  Text(
                    l16c.nextDrawTimeFormatted,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: AppConstant.luckyKaFont,
                        fontFamily: 'kalam'),
                  ),
                ],
              ),
            ),
            Container(
              height: screenHeight * 0.08,
              width: screenWidth * 0.2,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.lucky16LBgBlue),
                  fit: BoxFit.fill,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'BALANCE:',
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppConstant.luckyKaFont,
                      fontFamily: 'kalam',
                    ),
                  ),
                  Text(
                    balanceWithWinAmount.toStringAsFixed(2),
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppConstant.luckyKaFont,
                      fontFamily: 'kalam',
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                claimPopUp(context);
              },
              child: Image.asset(
                Assets.assetsClaim,
                height: screenHeight * 0.06,
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return Luck16ExitPopUp(
                      yes: () {
                        l16c.disConnectToServer(context);
                        Navigator.pushReplacementNamed(
                          context,
                          RoutesName.dashboard,
                        );
                      },
                    );
                  },
                );
              },
              child: Container(
                height: screenWidth * 0.03,
                width: screenWidth * 0.03,
                margin: EdgeInsets.only(right: screenWidth * 0.01),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.lucky12Close),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool showTicketData = false;

  void claimPopUp(BuildContext context) {
    final checkData = Provider.of<Lucky16CheckViewModel>(
      context,
      listen: false,
    );
    showCupertinoDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Claim Ticket Id"),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.clear_circled,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            content: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    CupertinoTextField(
                      controller: ticketController,
                      autofocus: true,
                      placeholder: "Enter your Ticket I'd",
                      padding: EdgeInsets.all(10),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Lucky12Btn(
                      title: 'CHECK',
                      onTap: () async {
                        await checkData.lucky16CheckApi(
                          context,
                            ticketController.text
                        );
                        // Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  viewTicketData(context) {
    showCupertinoDialog(
      context: context,
      builder:
          (context) => Consumer<Lucky16CheckViewModel>(
            builder: (context, ticketCon, _) {
              final ticket = ticketCon.ticketData;
              return CupertinoAlertDialog(
                title: Text("Claim Ticket Id"),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text('Ticket ID'),
                          subtitle: Text(ticket!.data?.ticketId.toString()??''),
                        ),
                        ListTile(
                          title: Text('User ID'),
                          subtitle: Text(ticket.data?.userId.toString()??''),
                        ),
                        ListTile(
                          title: Text('Period Number'),
                          subtitle: Text(ticket.data?.periodNo.toString()??''),
                        ),
                        ListTile(
                          title: Text('Game ID'),
                          subtitle: Text(ticket.data?.gameId.toString()??''),
                        ),
                        ListTile(
                          title: Text('Amount'),
                          subtitle: Text(ticket.data?.amount.toString()??''),
                        ),
                        ListTile(
                          title: Text('Win Number'),
                          subtitle: Text(ticket.data?.winNumber.toString()??''),
                        ),
                        ListTile(
                          title: Text('Win Amount'),
                          subtitle: Text(ticket.data?.winAmount.toString()??''),
                        ),
                        ListTile(
                          title: Text('Ticket Time'),
                          subtitle: Text(ticket.data?.ticketTime.toString()??''),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }
}
