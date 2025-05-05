import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_star/repo/auth_repo.dart';
import 'package:super_star/spin_to_win/view_model/user_view_model.dart';
import 'package:super_star/utils/routes/routes_name.dart';
import 'package:super_star/utils/utils.dart';

class AuthViewModel with ChangeNotifier {
  final _authRepo = AuthRepository();

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> loginApi(dynamic data, context) async {
    setLoading(true);
    final userPref = Provider.of<UserViewModel>(context, listen: false);
    _authRepo.loginApi(data).then((value) {
      if (value['success'] == true) {

        userPref.saveUser(value['id'].toString());
        setLoading(false);
        Navigator.pushReplacementNamed(context, RoutesName.dashboard);
      } else {
        setLoading(false);
        Utils.show(value['message'].toString(), context);
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
