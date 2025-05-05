import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:super_star/andar_bahar/controller/andar_bahar_controller.dart';
import 'package:super_star/andar_bahar/model/andar_bahar_result_model.dart';
import 'package:super_star/andar_bahar/repo/andar_bahar_result_repo.dart';

import 'package:super_star/utils/utils.dart';

import '../../spin_to_win/view_model/profile_view_model.dart';
import '../../spin_to_win/view_model/user_view_model.dart';

class AndarBaharResultViewModel with ChangeNotifier {
  final _andarBaharResultRepo = AndarBaharResultRepository();

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  List<LastResult> _lastResultList = [];
  List<LastResult> get lastResultList => _lastResultList;
  setListData(List<LastResult> value) {
    _lastResultList = value;
    notifyListeners();
  }

  int _winAmount = 0;
  int get winAmount => _winAmount;
  setWinAmount(int value) {
    _winAmount = value;
    notifyListeners();
  }

  Future<void> anderBaharResultApi(context, int status) async {
    final abc = Provider.of<AndarBaharController>(context, listen: false);
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    _andarBaharResultRepo.anderBaharResultApi(userId).then((value) {
      if (value.success == true) {
        if (status == 1) {
          setListData(value.lastResult!);
          if(abc.timerStatus!=2){
            abc.setShowCardData(value.showResult!.randomCard['value'],
                value.showResult!.randomCard['card_color']);
            abc.setShowBetCard(true);
          }
        } else if (status == 2) {
          abc.setShowCardData(value.showResult!.randomCard['value'],
              value.showResult!.randomCard['card_color']);
          abc.setShowBetCard(true);
        } else {
          if (value.showResult!.andarBaharCard!.isNotEmpty) {
            final andarBaharCard = value.showResult!.andarBaharCard!;
            for (var i = 0; i < andarBaharCard.length; i++) {
              Future.delayed(Duration(seconds: i + 1), () {
                if (andarBaharCard[i]['listData'] == 1) {
                  abc.andarList.add({
                    'cardColor': andarBaharCard[i]['card_color'],
                    'value': andarBaharCard[i]['value']
                  });
                } else {
                  abc.baharList.add({
                    'cardColor': andarBaharCard[i]['card_color'],
                    'value': andarBaharCard[i]['value']
                  });
                }
              });
            }
            Future.delayed(Duration(seconds: andarBaharCard.length), () {
              setListData(value.lastResult!);
              profileViewModel.profileApi(context);
              setWinAmount(value.winAmount!);
              if(value.winAmount!=0){
                Utils.show('Congratulations! YOU WIN ${value.winAmount}₹', context);
              }
            });
            notifyListeners();
          }

        }
        setLoading(false);
      } else {
        setLoading(false);
       if (kDebugMode) {
         print('Error in andar bahar result api');
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
