import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/main.dart';
import 'package:super_star/res/app_btn.dart';
import 'package:super_star/res/custom_text_field.dart';

import '../spin_to_win/view_model/auth_view_model.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController passCon = TextEditingController();
  final TextEditingController userNameCon = TextEditingController();
  final FocusNode mobileFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    mobileFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }
  void _handleKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter) {
        Map data = {
          "username": userNameCon.text,
          "password": passCon.text
        };
        Provider.of<AuthViewModel>(context, listen: false).loginApi(data, context);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        SystemNavigator.pop();
      },
      child: KeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        onKeyEvent: _handleKey,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Container(
              height: screenHeight,
              width: screenWidth,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Assets.assetsAuthBg), fit: BoxFit.fill)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight,
                    width: screenWidth * 0.60,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: screenHeight * 0.05, left: screenHeight * 0.10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.centerLeft,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: screenHeight * 0.13,
                                  width: screenWidth * 0.30,
                                  color: const Color(0xff000000),
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'STRICTLY FOR AMUSEMENT ONLY',
                                          style: TextStyle(
                                              color: Color(0xffb61514),
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'You Should be eighteen years and above.',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 7,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: screenWidth * 0.28,
                                child: Container(
                                  height: screenHeight * 0.15,
                                  width: screenHeight * 0.15,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              Assets.assets18Plus))),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: screenHeight * 0.17,
                            width: screenWidth * 0.6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width: 1, color: Colors.white.withValues(alpha: 0.4)),
                              color: const Color(0xff000000),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'FREE TO PLAY',
                                      style: TextStyle(
                                          color: Color(0xffb61514),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Amusement and Social Gaming Site',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '# Register And ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'PLAY FOR FREE',
                                            style: TextStyle(
                                              color: Color(0xffb61514),
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '# Get ',
                                            style: TextStyle(
                                                color: Colors
                                                    .white), // Default text color
                                          ),
                                          TextSpan(
                                            text: '100 Free chips ',
                                            style: TextStyle(color: Colors.green),
                                          ),
                                          TextSpan(
                                            text: 'on every login',
                                            style: TextStyle(
                                                color: Colors
                                                    .white), // Default text color
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Text(
                                      '# NO Roadmaption (or) Cash Winnings',
                                      style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '# NO DEPOSITE ',
                                            style: TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '(or) any Charges required to play \non the site',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: screenHeight * 0.8,
                    width: screenWidth * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomTextField(
                          textCapitalization: TextCapitalization.characters,
                          controller: userNameCon,
                          title: 'User Name',
                          icon: const Icon(Icons.person, color: Colors.grey),
                          keyboardType: TextInputType.text,
                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          focusNode: mobileFocusNode,
                          //onChanged: (val){
                            // if(val.length==10){
                            //   FocusScope.of(context).requestFocus(passwordFocusNode);
                            // }
                          //},
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        CustomTextField(
                          title: 'Password',
                          controller: passCon,
                          focusNode: passwordFocusNode,
                          icon: const Icon(Icons.lock_outline_sharp,
                              color: Colors.grey),
                        ),
                        SizedBox(
                          height: screenHeight * 0.1,
                        ),
                        AppBtn(
                          title: 'Login',
                          loading: authViewModel.loading,
                          onTap: () {
                            Map data = {
                              "username": userNameCon.text,
                              "password": passCon.text
                            };
                            authViewModel.loginApi(data, context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
