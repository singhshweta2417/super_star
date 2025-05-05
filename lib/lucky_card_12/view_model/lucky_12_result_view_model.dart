import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:super_star/lucky_card_12/controller/lucky_12_controller.dart';
import 'package:super_star/lucky_card_12/model/lucky_12_result_model.dart';
import 'package:super_star/lucky_card_12/repo/lucky_12_result_repo.dart';

import 'package:super_star/utils/utils.dart';

import '../../spin_to_win/view_model/profile_view_model.dart';
import '../../spin_to_win/view_model/user_view_model.dart';

class Lucky12ResultViewModel with ChangeNotifier {
  final _lucky12ResultRepo = Lucky12ResultRepository();

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  List<Result12> _lucky12ResultList = [];
  List<Result12> get lucky12ResultList => _lucky12ResultList;
  setListData(List<Result12> value) {
    _lucky12ResultList = value;
    notifyListeners();
  }

  int _winAmount = 0;
  int get winAmount => _winAmount;
  setWinAmount(int value) {
    _winAmount = value;
    notifyListeners();
  }

  Future<void> lucky12ResultApi(context, int status) async {
    final lucky12Controller =
        Provider.of<Lucky12Controller>(context, listen: false);
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    _lucky12ResultRepo.lucky12ResultApi(userId).then((value) {
      if (value.success == true) {
        if (status == 1) {
          setListData(value.result12!);
        } else {
          lucky12Controller.firstStop(value.result12!.first.cardIndex!);
          lucky12Controller.secondStop(value.result12!.first.colorIndex!);
          Future.delayed(const Duration(seconds: 4), () {
            setListData(value.result12!);
            lucky12Controller.setResultShowTime(false);
            profileViewModel.profileApi(context);
            setWinAmount(value.winAmount!);
          });
        }
        setLoading(false);
      } else {
        setLoading(false);
        Utils.show(value.message.toString(), context);
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
