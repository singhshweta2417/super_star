
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:super_star/spin_to_win/view_model/user_view_model.dart';
import '../../utils/routes/routes_name.dart';

class SplashServices {
  Future<String?> getUserData() => UserViewModel().getUser();
  void checkAuthentication(context) async {
    getUserData().then((value) async {
      // UserViewModel().remove();
      if (kDebugMode) {
        print(value.toString());
        print('valueId');
      }
      if (value.toString() == 'null' || value.toString() == '') {
        await Future.delayed(const Duration(seconds: 3));
        Navigator.pushNamed(context, RoutesName.login);
      } else {
        await Future.delayed(const Duration(seconds: 3));
        Navigator.pushNamed(context, RoutesName.dashboard);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
