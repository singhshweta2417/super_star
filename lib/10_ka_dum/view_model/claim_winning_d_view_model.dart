import 'package:flutter/foundation.dart';
import 'package:super_star/utils/utils.dart';
import '../../spin_to_win/view_model/user_view_model.dart';
import '../repo/claim_winning_d_repo.dart';

class ClaimWinningDKDViewModel extends ChangeNotifier {
  final _claimWinDRepo = ClaimWinningDKDRepository();

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> claimWinningDApi(context) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {"user_id": userId};
    _claimWinDRepo
        .claimWinningDApi(data)
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
