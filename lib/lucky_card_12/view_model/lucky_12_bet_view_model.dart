import 'package:flutter/foundation.dart';
import 'package:super_star/lucky_card_12/repo/lucky_12_bet_repo.dart';
import 'package:super_star/utils/utils.dart';

import '../../spin_to_win/view_model/user_view_model.dart';


class Lucky12BetViewModel with ChangeNotifier {
  final _lucky12BetRepo = Lucky12BetRepository();

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<void> lucky12BetApi(dynamic betList, context) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {"user_id": userId, "bets": betList};
    _lucky12BetRepo.lucky12BetApi(data).then((value) {
      if (value['success'] == true) {
        setLoading(false);
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
