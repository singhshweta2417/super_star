import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:super_star/lucky_card_16/repo/lucky_16_bet_repo.dart';
import 'package:super_star/lucky_card_16/view_model/print_view_model.dart';
import 'package:super_star/utils/utils.dart';

import '../../spin_to_win/view_model/profile_view_model.dart';
import '../../spin_to_win/view_model/user_view_model.dart';
import '../controller/lucky_16_controller.dart';
import '../repo/claim_winning_repo.dart';

class ClaimWinningViewModel extends ChangeNotifier {
  final _claimWinRepo = ClaimWinningRepository();

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> claimWinningApi(context) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {"user_id": userId};
    _claimWinRepo
        .claimWinningApi(data)
        .then((value) {
          if (value['success'] == true) {
            Utils.show(value['message'].toString(), context);
            setLoading(false);
          } else {
            setLoading(false);
            Utils.show(value['message'].toString(), context);
          }
        })
        .onError((error, stackTrace) {
          setLoading(false);
          if (kDebugMode) {
            print('error: $error');
          }
        });
  }
}
