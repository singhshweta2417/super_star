
import 'package:flutter/foundation.dart';
import 'package:super_star/timer_36/repo/timer_36_win_a_repo.dart';

import '../../spin_to_win/view_model/user_view_model.dart';


class Timer36WinAViewModel with ChangeNotifier {
  final _timer36WinARepo = Timer36WinARepository();
  dynamic _winAmount;

  dynamic get winAmount => _winAmount;

  void setWinAmount(dynamic val) {
    _winAmount = val;
    notifyListeners();
  }

  Future<void> timer36WinAApi(context) async {
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    _timer36WinARepo.timer36WinAApi(userId).then((value) {
      if (value['success'] == true) {
        //   "win_amount": 0,
        // "bet_amount": 0
        setWinAmount(value['win_amount']);
      } else {
        if (kDebugMode) {
          print('value: ${value['message']}');
        }
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
