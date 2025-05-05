import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/timer_36/repo/timer_36_bet_repo.dart';

import '../../spin_to_win/view_model/profile_view_model.dart';
import '../../spin_to_win/view_model/user_view_model.dart';
import '../../utils/utils.dart';

class Timer36BetViewModel with ChangeNotifier {
  final _timer36BetRepo = Timer36BetRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> timer36BetApi(dynamic betList, dynamic gamesNo, context) async {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {
      "user_id": userId,
      "games_no": gamesNo.toString(),
      "bets": betList
    };
    _timer36BetRepo.timer36BetApi(data).then((value) {
      if (value['success'] == true) {
        setLoading(false);
        profileViewModel.profileApi(context);
        Utils.showImage(Assets.timer36BetAccepted, context);
      } else {
        setLoading(false);
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
