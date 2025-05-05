import 'package:flutter/foundation.dart';
import 'package:super_star/andar_bahar/model/andar_bahar_history_model.dart';
import 'package:super_star/andar_bahar/repo/andar_bahar_history_repo.dart';

import '../../spin_to_win/view_model/user_view_model.dart';

class AndarBaharHistoryViewModel with ChangeNotifier {
  final _andarBaharHistoryRepo = AndarBaharHistoryRepository();

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  List<AndarBaharData> _lastHistoryList = [];
  List<AndarBaharData> get historyList => _lastHistoryList;
  setListData(List<AndarBaharData> value) {
    _lastHistoryList = value;
    notifyListeners();
  }

  Future<void> andarBaharHistoryApi(context) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    _andarBaharHistoryRepo.anderBaharHistoryApi(userId).then((value) {
      if (value.success == true) {
        setListData(value.data!);
        setLoading(false);
      } else {
        setLoading(false);
        if (kDebugMode) {
          print('Error on Bet History');
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
