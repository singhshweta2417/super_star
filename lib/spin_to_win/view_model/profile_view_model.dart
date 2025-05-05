
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:super_star/repo/profile_repo.dart';
import 'package:super_star/spin_to_win/view_model/user_view_model.dart';

class ProfileViewModel with ChangeNotifier {
  final _profileRepo  = ProfileRepository();
  dynamic _balance = 0;

  dynamic get balance => _balance;

  void addBalance(dynamic amount) {
    _balance += amount;
    notifyListeners();
  }

  void deductBalance(dynamic amount) {
    _balance -= amount;
    notifyListeners();
  }

  void setBalance(dynamic amount) {
    _balance = amount;
    notifyListeners();
  }

  String _userName = '';

  String get userName => _userName;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  Future<void> profileApi(context) async {
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    _profileRepo.profileApi(userId).then((value) {
      if (value.success == true) {
        // ProfileModel profileData = ProfileModel.fromJson(value);
        Provider.of<ProfileViewModel>(context, listen: false)
            .setUserName('${value.data?.username}');
        Provider.of<ProfileViewModel>(context, listen: false)
            .setBalance(value.data?.wallet??0);
      } else {
        if (kDebugMode) {
          print('value: ${value.message}');
        }
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print('error: $error');
      }
      });
   }

}

