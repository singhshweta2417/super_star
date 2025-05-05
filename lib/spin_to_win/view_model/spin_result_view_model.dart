import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:super_star/spin_to_win/controller/spin_controller.dart';
import 'package:super_star/spin_to_win/model/spin_result_model.dart';
import 'package:super_star/spin_to_win/res/utils.dart';
import 'package:super_star/spin_to_win/view_model/profile_view_model.dart';
import 'package:super_star/spin_to_win/view_model/user_view_model.dart';
import 'package:super_star/spin_to_win/repo/spin_result_repo.dart';


class SpinResultViewModel with ChangeNotifier {
  final _spinResultRepo = SpinResultRepository();

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  List<Data> _spinResultList = [];
  List<Data> get spinResultList => _spinResultList;
  setListData(List<Data> value) {
    _spinResultList = value;
    notifyListeners();
  }

  int _winAmount = 0;
  int get winAmount => _winAmount;
  setWinAmount(int value) {
    _winAmount = value;
    notifyListeners();
  }

  Future<void> spinResultApi(context,int status) async {
    setLoading(true);
    final spinController = Provider.of<SpinController>(context, listen: false);
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    _spinResultRepo.spinResultApi(userId).then((value) {
      if (value.success == true) {
        if(status==1){
          setListData(value.data!);
        }else{
          spinController.spinStopWheel(value.data!.first.winIndex!);
          Future.delayed(const Duration(seconds: 4), () {
            spinController.setIsAnimationOpen(true);
            setListData(value.data!);
            profileViewModel.profileApi(context);
            setWinAmount(value.winAmount!);
            if(value.winAmount!=0){
              // show win pop up
              SpinUtils.showSpiWinToast(value.winAmount.toString(),context);
            }
          });
          Future.delayed(const Duration(seconds: 8), () {
            spinController.setIsAnimationOpen(false);
          });
        }
        setLoading(false);
      } else {
        setLoading(false);
        if (kDebugMode) {
          print("spinResultApi error");
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
