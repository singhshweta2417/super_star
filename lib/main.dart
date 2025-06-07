import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';

import 'package:provider/provider.dart';
import 'package:super_star/10_ka_dum/controller/dus_ka_dum_controller.dart';
import 'package:super_star/10_ka_dum/res/sizes_const.dart';
import 'package:super_star/10_ka_dum/view_model/dus_ka_dum_bet_view_model.dart';
import 'package:super_star/andar_bahar/controller/andar_bahar_controller.dart';
import 'package:super_star/andar_bahar/view_model/andar_bahar_history_view_model.dart';
import 'package:super_star/andar_bahar/view_model/andar_bahar_result_view_model.dart';
import 'package:super_star/lucky_card_12/controller/lucky_12_controller.dart';
import 'package:super_star/lucky_card_12/view_model/lucky_12_history_view_model.dart';
import 'package:super_star/lucky_card_12/view_model/lucky_12_result_view_model.dart';
import 'package:super_star/lucky_card_16/controller/lucky_16_controller.dart';
import 'package:super_star/lucky_card_16/view_model/lucky_16_history_view_model.dart';
import 'package:super_star/lucky_card_16/view_model/lucky_16_result_view_model.dart';
import 'package:super_star/res/app_constant.dart';
import 'package:super_star/spin_to_win/controller/spin_controller.dart';
import 'package:super_star/spin_to_win/view_model/auth_view_model.dart';
import 'package:super_star/spin_to_win/view_model/profile_view_model.dart';
import 'package:super_star/spin_to_win/view_model/spin_bet_view_model.dart';
import 'package:super_star/spin_to_win/view_model/spin_history_view_model.dart';
import 'package:super_star/spin_to_win/view_model/spin_result_view_model.dart';
import 'package:super_star/spin_to_win/view_model/user_view_model.dart';
import 'package:super_star/triple_chance/view_model/triple_chance_history_view_model.dart';
import 'package:super_star/triple_chance/view_model/triple_chance_result_view_model.dart';
import 'package:super_star/utils/routes/routes.dart';
import 'package:super_star/utils/routes/routes_name.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:window_manager/window_manager.dart';
import '10_ka_dum/view_model/dus_ka_dum_check_view_model.dart';
import '10_ka_dum/view_model/dus_ka_dum_history_view_model.dart'
    show DusKaDumHistoryViewModel;
import '10_ka_dum/view_model/dus_ka_dum_result_view_model.dart';
import '10_ka_dum/view_model/print_view_10_model.dart';
import '10_ka_dum/view_model/usb_print_10.dart';
import 'lucky_card_16/view_model/claim_winning_view_model.dart';
import 'lucky_card_16/view_model/lucky_16_bet_view_model.dart';
import 'lucky_card_16/view_model/lucky_16_check_view_model.dart';
import 'lucky_card_16/view_model/print_view_model.dart';
import 'lucky_card_16/view_model/usb_print.dart';
import 'timer_36/controller/timer_36_controller.dart';
import 'timer_36/view_model/timer_36_bet_view_model.dart';
import 'timer_36/view_model/timer_36_last_result_view_model.dart';
import 'timer_36/view_model/timer_36_win_a_view_model.dart';
import 'triple_chance/controller/triple_chance_controller.dart';
import 'triple_chance/view_model/triple_chance_bet_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [],
  );
  runApp(const MyApp());
  if (Platform.isIOS) {
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow(
      const WindowOptions(
        fullScreen: true,
        backgroundColor: Colors.transparent,
        titleBarStyle: TitleBarStyle.hidden,
      ),
      () async {
        await windowManager.setFullScreen(true);
        await windowManager.setAlwaysOnTop(true);
        await windowManager.show();
        await windowManager.focus();
      },
    );
  }
}

double screenHeight = 0;
double screenWidth = 0;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width * 0.9;
    screenHeight = MediaQuery.of(context).size.height;
    WakelockPlus.enable();
    Sizes.initSizing(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SpinController()),
        ChangeNotifierProvider(create: (context) => UserViewModel()),
        ChangeNotifierProvider(create: (context) => SpinBetViewModel()),
        ChangeNotifierProvider(create: (context) => SpinResultViewModel()),
        ChangeNotifierProvider(create: (context) => SpinHistoryViewModel()),
        ChangeNotifierProvider(create: (context) => SpinHistoryViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => Lucky16Controller()),
        ChangeNotifierProvider(create: (context) => Lucky16ResultViewModel()),
        ChangeNotifierProvider(create: (context) => Lucky16HistoryViewModel()),
        ChangeNotifierProvider(create: (context) => Lucky16CheckViewModel()),
        ChangeNotifierProvider(create: (context) => Lucky12ResultViewModel()),
        ChangeNotifierProvider(create: (context) => Lucky12Controller()),
        ChangeNotifierProvider(create: (context) => Lucky12HistoryViewModel()),
        ChangeNotifierProvider(create: (context) => AndarBaharController()),
        ChangeNotifierProvider(create: (context) => PrintingController()),
        ChangeNotifierProvider(create: (context) => UsbPrintDusViewModel()),
        ChangeNotifierProvider(create: (context) => ClaimWinningViewModel()),
        ChangeNotifierProvider(
          create: (context) => AndarBaharResultViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AndarBaharHistoryViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => TripleChanceResultViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => TripleChanceHistoryViewModel(),
        ),
        ChangeNotifierProvider(create: (context) => TripleChanceBetViewModel()),
        ChangeNotifierProvider(create: (context) => TripleChanceController()),
        ChangeNotifierProvider(create: (context) => Timer36Controller()),
        ChangeNotifierProvider(create: (context) => Timer36BetViewModel()),
        ChangeNotifierProvider(create: (context) => UsbPrintViewModel()),
        ChangeNotifierProvider(create: (context) => Lucky16BetViewModel()),
        ChangeNotifierProvider(create: (context) => DusKaDumController()),
        ChangeNotifierProvider(create: (context) => DusKaDumBetViewModel()),
        ChangeNotifierProvider(create: (context) => DusKaDumBetViewModel()),
        ChangeNotifierProvider(create: (context) => Printing10Controller()),
        ChangeNotifierProvider(
          create: (context) => Timer36LastResultViewModel(),
        ),
        ChangeNotifierProvider(create: (context) => Timer36WinAViewModel()),
        ChangeNotifierProvider(create: (context) => DusKaDumHistoryViewModel()),
        ChangeNotifierProvider(create: (context) => DusKaDumResultViewModel()),
        ChangeNotifierProvider(create: (context) => DusKaDumCheckViewModel()),
      ],
      child: MaterialApp(
        color: Colors.red,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: Colors.black),
        title: AppConstant.appName,
        initialRoute: RoutesName.splash,
        onGenerateRoute: (settings) {
          if (settings.name != null) {
            return MaterialPageRoute(
              builder: Routers.generateRoute(settings.name!),
              settings: settings,
            );
          }
          return null;
        },
        // home: DusKaDamGameScreen(),
      ),
    );
  }
}
