import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:super_star/10_ka_dum/res/sizes_const.dart';
import 'package:super_star/main.dart';
import 'package:super_star/res/app_exit_pop_up.dart';
import 'package:super_star/spin_to_win/view_model/profile_view_model.dart';
import 'package:super_star/spin_to_win/view_model/user_view_model.dart';
import 'package:super_star/utils/routes/routes_name.dart';
import 'package:super_star/utils/utils.dart';
import '../generated/assets.dart';
import 'lucky_card_16/widgets/luck_16_exit_pop_up.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final FocusNode _keyboardFocusNode = FocusNode();

  @override
  void initState() {
    final profileViewModel = Provider.of<ProfileViewModel>(
      context,
      listen: false,
    );
    _keyboardFocusNode.requestFocus();
    profileViewModel.profileApi(context);
    super.initState();
  }

  void _handleKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter) {
        Navigator.pushNamed(context, RoutesName.lucky16);
      } else if (event.logicalKey == LogicalKeyboardKey.backspace ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter) {
        showDialog(
          context: context,
          barrierColor: Colors.transparent,
          builder: (BuildContext context) {
            return AppExitPopUp(
              yes: () {
                // App Exit
                UserViewModel().remove();
                SystemNavigator.pop();
              },
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // List<DashBoardModel> dashBoardList = [
    //   DashBoardModel(
    //       onTap: () {
    //         Navigator.pushNamed(context, RoutesName.tripleChance);
    //       },
    //       title: 'Triple Chance',
    //       img: Assets.assetsDTripleChance),
    //   DashBoardModel(
    //       onTap: () {
    //         Navigator.pushNamed(context, RoutesName.spin2Win);
    //       },
    //       title: 'Spin To Win',
    //       img: Assets.assetsDSpin2Win),
    //   DashBoardModel(
    //       onTap: () {
    //         Navigator.pushNamed(context, RoutesName.lucky16);
    //       },
    //       title: 'Lucky 16',
    //       img: Assets.assetsDLucky16),
    //   DashBoardModel(
    //       onTap: () {
    //         Navigator.pushNamed(context, RoutesName.lucky12);
    //       },
    //       title: 'Lucky 12',
    //       img: Assets.assetsDLucky12),
    //   DashBoardModel(
    //       onTap: () {
    //         Navigator.pushNamed(context, RoutesName.game36View);
    //       },
    //       title: '36 Timer',
    //       img: Assets.assetsD36Timer),
    //   DashBoardModel(
    //       onTap: () {
    //         Navigator.pushNamed(context, RoutesName.anderBahar);
    //       },
    //       title: 'Ander Bahar',
    //       img: Assets.assetsDAndarBahar),
    // ];
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        showDialog(
          context: context,
          barrierColor: Colors.transparent,
          builder: (BuildContext context) {
            return AppExitPopUp(
              yes: () {
                // App Exit
                UserViewModel().remove();
                SystemNavigator.pop();
              },
            );
          },
        );
      },
      child:KeyboardListener(
        focusNode: _keyboardFocusNode,
        onKeyEvent: _handleKey,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierColor: Colors.transparent,
                builder: (BuildContext context) {
                  return Luck16ExitPopUp(
                    yes: () {
                      UserViewModel().remove();
                      exit(0);
                    },
                  );
                },
              );
            },
            child: Icon(Icons.exit_to_app),
          ),
          body: Center(
            child: Container(
              height: screenHeight,
              width: screenWidth,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.assetsDashBg),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.075),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.17,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xff57400f),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              'V 2.0',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Hi!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              profileViewModel.userName.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.12),
                      Container(
                        alignment: Alignment.center,
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.17,
                        padding: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xff00402c),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Balance:',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 8),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  maxLines: 1,
                                  profileViewModel.balance.toStringAsFixed(2),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          UserViewModel().remove();
                          Utils.show("User logged out successfully", context);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RoutesName.login,
                            (context) => false,
                          );
                        },
                        child: Container(
                          height: screenHeight * 0.07,
                          width: screenWidth * 0.04,
                          decoration: const BoxDecoration(
                            color: Color(0xff790dd5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_sharp,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: screenHeight * 0.1),
                  Text("SuperStar".toUpperCase(), style: TextStyle(color: Colors.red, fontSize: Sizes.fontSize12, fontWeight:FontWeight.bold),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RoutesName.lucky16);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: screenHeight * 0.6,
                          width: screenWidth * 0.35,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.assetsDLucky16),
                              fit: BoxFit.fill,
                            ),
                          ),
                          // child: Center(
                          //   child:
                          //   GridView.builder(
                          //     physics: const NeverScrollableScrollPhysics(),
                          //     shrinkWrap: true,
                          //     padding: const EdgeInsets.all(16.0),
                          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          //       crossAxisCount: 3, // Number of columns in the grid
                          //       crossAxisSpacing: 4,
                          //       mainAxisSpacing: 4,
                          //     ),
                          //     itemCount: dashBoardList.length,
                          //     itemBuilder: (context, index) {
                          //       return GestureDetector(
                          //         onTap: dashBoardList[index].onTap,
                          //         child: Container(
                          //           alignment: Alignment.bottomCenter,
                          //           decoration: BoxDecoration(
                          //               image: DecorationImage(
                          //                   image: AssetImage(dashBoardList[index].img),
                          //                   fit: BoxFit.fill,)),
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RoutesName.dusKaDum);
                        },
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          height: screenHeight * 0.57,
                          width: screenWidth * 0.35,
                          decoration: BoxDecoration(
                            border: Border.all(color: CupertinoColors.systemYellow, width: 5),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(Assets.dusKaDumImg),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            width: screenWidth * 0.35,
                            height: screenHeight/8,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              image: DecorationImage(
                                image: AssetImage(Assets.dusKaDumGameName),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text('Play For Amusement only', style: TextStyle(color: Colors.black, fontSize: Sizes.fontSize8, fontWeight: FontWeight.w600),),

                  // Container(
                  //   alignment: Alignment.center,
                  //   height: screenHeight * 0.75,
                  //   width: screenWidth * 0.53,
                  //   // color: Colors.red,
                  //   child:
                  //   GridView.builder(
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     shrinkWrap: true,
                  //     padding: const EdgeInsets.all(16.0),
                  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //       crossAxisCount: 3, // Number of columns in the grid
                  //       crossAxisSpacing: 4,
                  //       mainAxisSpacing: 4,
                  //       childAspectRatio: 0.9
                  //     ),
                  //     itemCount: dashBoardList.length, // Number of containers
                  //     itemBuilder: (context, index) {
                  //       return GestureDetector(
                  //         onTap: dashBoardList[index].onTap,
                  //         child: Container(
                  //           alignment: Alignment.bottomCenter,
                  //           decoration: BoxDecoration(
                  //               image: DecorationImage(
                  //                   image: AssetImage(dashBoardList[index].img),
                  //                   fit: BoxFit.fill)),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashBoardModel {
  final String title;
  final VoidCallback onTap;
  final String img;
  DashBoardModel({required this.onTap, required this.title, required this.img});
}
