import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:super_star/triple_chance/controller/triple_chance_controller.dart';
import 'package:super_star/triple_chance/repo/triple_chance_result_repo.dart';


import '../../spin_to_win/view_model/profile_view_model.dart';
import '../../spin_to_win/view_model/user_view_model.dart';
import '../model/triple_chance_result_model.dart';
import '../res/utils.dart';

class TripleChanceResultViewModel with ChangeNotifier {
  final _tripleChanceResultRepo = TripleChanceResultRepository();

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  List<ResultTripleChance> _tripleChanceResultList = [];
  List<ResultTripleChance> get tripleChanceResultList => _tripleChanceResultList;
  setListData(List<ResultTripleChance> value) {
    _tripleChanceResultList = value;
    notifyListeners();
  }

  int _winAmount = 0;
  int get winAmount => _winAmount;
  int _fiWheelWinAmount = 0;
  int get fiWheelWinAmount => _fiWheelWinAmount;
  int _seWheelWinAmount = 0;
  int get seWheelWinAmount => _seWheelWinAmount;
  int _thWheelWinAmount = 0;
  int get thWheelWinAmount => _thWheelWinAmount;
  setWinAmount(int value , int fValue , int sValue , int tValue) {
    _winAmount = value;
    _fiWheelWinAmount = fValue;
    _seWheelWinAmount = sValue;
    _thWheelWinAmount = tValue;
    notifyListeners();
  }

  Future<void> tripleChanceResultApi(context, int status) async {
    final tripleChanceController =
        Provider.of<TripleChanceController>(context, listen: false);
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    _tripleChanceResultRepo.tripleChanceResultApi(userId).then((value) {
      if (value.success == true) {
        if (status == 1) {
          setListData(value.resultTripleChance!);
        } else {
          tripleChanceController.firstStop(value.resultTripleChance!.first.wheel1Index!);
          tripleChanceController.secondStop(value.resultTripleChance!.first.wheel2Index!);
          tripleChanceController.thirdStop(value.resultTripleChance!.first.wheel3Index!);
          Future.delayed(const Duration(seconds: 4), () {
            setListData(value.resultTripleChance!);
            tripleChanceController.setResultShowTime(false);
            profileViewModel.profileApi(context);
            setWinAmount(value.winAmount,value.firstWheelAmount,
                value.secWheelAmount, value.thirdWheelAmount);
            // pop up code
            if(value.winAmount!=0){
              // show win pop up
              Utils.showTrChWinToast(value.winAmount.toString(),value.firstWheelAmount.toString(),
                  value.secWheelAmount.toString(), value.thirdWheelAmount.toString(),context);
            }
          });
        }
        setLoading(false);
      } else {
        setLoading(false);
        if (kDebugMode) {
          print('error: ${value.message}');
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
