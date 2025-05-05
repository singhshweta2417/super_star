import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:super_star/timer_36/controller/timer_36_controller.dart';
import 'package:super_star/timer_36/model/timer_36_last_result_model.dart';
import 'package:super_star/timer_36/repo/timer_36_last_result_repo.dart';
import 'package:super_star/timer_36/view_model/timer_36_win_a_view_model.dart';

import '../../spin_to_win/view_model/profile_view_model.dart';
import '../../utils/utils.dart';

class Timer36LastResultViewModel with ChangeNotifier {
  final _timer36LastResultRepo = Timer36LastResultRepo();

  List<TimerData> _timer36LastResultList = [];
  List<TimerData> get timer36LastResultList => _timer36LastResultList;

  setResultData(List<TimerData> value) {
    _timer36LastResultList = value;
    notifyListeners();
  }

  Future<void> timer36LastResultApi(int status,context) async {
    final timer36Con=Provider.of<Timer36Controller>(context,listen: false);
    final profileViewModel=Provider.of<ProfileViewModel>(context,listen: false);
    final timer36WinAViewModel = Provider.of<Timer36WinAViewModel>(context,listen: false);
    _timer36LastResultRepo.timer36LastResultApi().then((value) {
      if (value.success == true) {
        if(status==0){
          timer36Con.setGamesNo(value.data!.first.gamesNo!+1);
          timer36Con.notifyData(value.data!.first.gameIndex!);
          setResultData(value.data!);
        }else{
          timer36Con.notifyStop(value.data!.first.gameIndex!);
          timer36Con.notifyStops(value.data!.first.gameIndex!);
          Future.delayed(const Duration(seconds: 5),(){
            timer36Con.setGamesNo(value.data!.first.gamesNo!+1);
            timer36Con.notifyData(value.data!.first.gameIndex!);
            timer36Con.isHideValue(false);
            timer36Con.indResult(true);
            setResultData(value.data!);
            timer36WinAViewModel.timer36WinAApi(context);
            profileViewModel.profileApi(context);
          });
        }
      } else {
        Utils.show(value.message.toString(), context);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
