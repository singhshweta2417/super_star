import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:super_star/lucky_card_16/controller/lucky_16_controller.dart';
import 'package:super_star/lucky_card_16/model/lucky_16_result_model.dart';
import 'package:super_star/lucky_card_16/repo/lucky_16_result_repo.dart';
import 'package:super_star/utils/utils.dart';

import '../../spin_to_win/view_model/profile_view_model.dart';
import '../../spin_to_win/view_model/user_view_model.dart';

class Lucky16ResultViewModel with ChangeNotifier {
  final _lucky16ResultRepo = Lucky16ResultRepository();

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  List<Result16> _lucky16ResultList = [];
  List<Result16> get lucky16ResultList => _lucky16ResultList;
  setListData(List<Result16> value) {
    _lucky16ResultList = value;
    notifyListeners();
  }



  int _winAmount = 0;
  int get winAmount => _winAmount;
  setWinAmount(int value) {
    _winAmount = value;
    notifyListeners();
  }

  Future<void> lucky16ResultApi(context, int status) async {
    final lucky16Controller = Provider.of<Lucky16Controller>(
      context,
      listen: false,
    );
    final profileViewModel = Provider.of<ProfileViewModel>(
      context,
      listen: false,
    );
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    _lucky16ResultRepo
        .lucky16ResultApi(userId)
        .then((value) {
          if (value.success == true) {
            if (status == 1) {
              setListData(value.result16!);
            } else {
              lucky16Controller.firstStop(value.result16!.first.cardIndex!);
              lucky16Controller.secondStop(value.result16!.first.colorIndex!);
              Future.delayed(const Duration(seconds: 4), () {
                setListData(value.result16!);
                lucky16Controller.setResultShowTime(false);
                profileViewModel.profileApi(context);
                setWinAmount(int.parse(value.winAmount.toString()));
                Provider.of<Lucky16Controller>(
                  context,
                  listen: false,
                ).getJokerJackPot(value.result16!.first.jackpot ?? 0, context);
              });
            }
            setLoading(false);
          } else {
            setLoading(false);
            Utils.show(value.message.toString(), context);
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
