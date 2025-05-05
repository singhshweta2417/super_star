import 'package:flutter/foundation.dart';
import 'package:super_star/triple_chance/repo/triple_chance_bet_repo.dart';

import '../../spin_to_win/view_model/user_view_model.dart';
import '../../utils/utils.dart';


class TripleChanceBetViewModel with ChangeNotifier {
  final _tripleChanceBetRepo = TripleChanceBetRepository();

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<void> tripleChanceBetApi(dynamic betList, context) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {"user_id": userId, "bets": betList};
    _tripleChanceBetRepo.tripleChanceBetApi(data).then((value) {
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
