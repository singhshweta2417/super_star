import 'package:flutter/material.dart';
import 'package:super_star/10_ka_dum/game_screen.dart';
import 'package:super_star/andar_bahar/ander_bahar.dart';
import 'package:super_star/lucky_card_12/lucky_card_12.dart';
import 'package:super_star/lucky_card_16/lucky_card_16.dart';
import 'package:super_star/splash_screen.dart';
import 'package:super_star/timer_36/timer_36.dart';
import 'package:super_star/timer_36/widgets/game_36_rules.dart';
import 'package:super_star/triple_chance/triple_chance.dart';
import 'package:super_star/utils/routes/routes_name.dart';

import '../../auth/login_screen.dart';
import '../../dash_board_screen.dart';
import '../../spin_to_win/spin_to_win.dart';


class Routers {
  static WidgetBuilder generateRoute(String routeName) {
    switch (routeName) {
      case RoutesName.splash:
        return (context) => const SplashScreen();
      case RoutesName.spin2Win:
        return (context) => const SpinToWin();
      case RoutesName.login:
        return (context) => const LoginScreen();
      case RoutesName.dashboard:
        return (context) => const DashBoardScreen();
      case RoutesName.tripleChance:
        return (context) => const TripleChance();
      case RoutesName.lucky16:
        return (context) =>  LuckyCard16();
      case RoutesName.dusKaDum:
        return (context) =>  DusKaDamGameScreen();
      case RoutesName.game36View:
        return (context) => const Timer36View();
      case RoutesName.game36Rules:
        return (context) => const Game36Rules();
      case RoutesName.lucky12:
        return (context) => const LuckyCard12();
      case RoutesName.anderBahar:
        return (context) => const AnderBahar();
      default:
        return (context) => const Scaffold(
              body: Center(
                child: Text(
                  'No Route Found!',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            );
    }
  }
}
