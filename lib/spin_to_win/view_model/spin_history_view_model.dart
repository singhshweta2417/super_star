import 'package:flutter/foundation.dart';
import 'package:super_star/spin_to_win/model/spin_history_model.dart';
import 'package:super_star/spin_to_win/repo/spin_history_repo.dart';
import 'package:super_star/spin_to_win/view_model/user_view_model.dart';

class SpinHistoryViewModel with ChangeNotifier {
  final _spinHistoryRepo = SpinHistoryRepository();

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  SpinHistoryModel? _spinHistoryModel;

  SpinHistoryModel? get spinHistoryModel => _spinHistoryModel;

  setListData(SpinHistoryModel value) {
    _spinHistoryModel = value;
    notifyListeners();
  }

  Future<void> spinHistoryApi(context) async {
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    _spinHistoryRepo.spinHistoryApi(userId).then((value) {
      if (value.success == true) {
        setListData(value);
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
