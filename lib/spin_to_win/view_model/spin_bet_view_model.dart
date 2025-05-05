import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:super_star/spin_to_win/view_model/user_view_model.dart';

import 'package:super_star/utils/utils.dart';

import '../controller/spin_controller.dart';
import '../repo/spin_bet_repo.dart';

class SpinBetViewModel with ChangeNotifier {
  final _spinBetRepo = SpinBetRepository();

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<void> spinBetApi(dynamic betList, context) async {
    final scc=Provider.of<SpinController>(context,listen: false);
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {"user_id": userId, "bets": betList};
    _spinBetRepo.spinBetApi(data).then((value) {
      if (value['success'] == true) {
        scc.repeatBets.clear();
        scc.repeatBets.addAll(betList);
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
