
import 'package:flutter/foundation.dart';
import 'package:super_star/helper/response/api_response.dart';
import 'package:super_star/timer_36/model/timer_36_g_h_model.dart';
import 'package:super_star/timer_36/repo/timer_36_g_h_repo.dart';

import '../../spin_to_win/view_model/user_view_model.dart';


class Timer36GHViewModel with ChangeNotifier {
  final _timer36GHRepo = Timer36GHRepository();
  ApiResponse<Timer36GHModel>timer36GHList = ApiResponse.loading();
  setAllRecordList(ApiResponse<Timer36GHModel> response) {
    timer36GHList = response;
    notifyListeners();
  }

  Future<void> timer36GHApi(context) async {
    setAllRecordList(ApiResponse.loading());
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    _timer36GHRepo.timer36GHApi(userId).then((value) {
      if (value.success == true) {
        setAllRecordList(ApiResponse.completed(value));
      } else {
        setAllRecordList(ApiResponse.completed(value));
      }
    }).onError((error, stackTrace) {
      setAllRecordList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
