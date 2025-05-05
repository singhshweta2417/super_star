import 'package:flutter/foundation.dart';
import 'package:super_star/andar_bahar/repo/andar_bahar_bet_repo.dart';
import 'package:super_star/utils/utils.dart';

import '../../spin_to_win/view_model/user_view_model.dart';


class AndarBaharBetViewModel with ChangeNotifier {
  final _andarBaharBetRepo = AndarBaharBetRepository();

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<void> andarBaharBetApi(dynamic betList, context) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {"user_id": userId, "bets": betList};
    _andarBaharBetRepo.andarBaharBetApi(data).then((value) {
      if (value['success'] == true) {
        setLoading(false);
        Utils.show('Bet place successFully!', context);
      } else {
        setLoading(false);
        if (kDebugMode) {
          print('Error when Bet placed!');
        }
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}