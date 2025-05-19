import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:super_star/10_ka_dum/controller/dus_ka_dum_controller.dart';
import 'package:super_star/10_ka_dum/repo/dus_ka_dum_result_repo.dart';
import 'package:super_star/lucky_card_16/model/lucky_16_result_model.dart';
import 'package:super_star/utils/utils.dart';

import '../../spin_to_win/view_model/profile_view_model.dart';
import '../../spin_to_win/view_model/user_view_model.dart';
import '../model/last_6_jackpot_model.dart' show Last6JackPotResult;

class DusKaDumResultViewModel with ChangeNotifier {
  final _dusKaDumResultRepo = DusKaDumResultRepository();

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  List<Result16> _dusKaDumResultList = [];
  List<Result16> get dusKaDumResultList => _dusKaDumResultList;
  setListData(List<Result16> value) {
    _dusKaDumResultList = value;
    notifyListeners();
  }

  int _winAmount = 0;
  int get winAmount => _winAmount;
  setWinAmount(int value) {
    _winAmount = value;
    notifyListeners();
  }

  Last6JackPotResult? _last6jackPotResult;
  Last6JackPotResult? get last6jackPotResult => _last6jackPotResult;

  setLas6JackPot(Last6JackPotResult value) {
    _last6jackPotResult = value;
    notifyListeners();
  }

  Future<void> dusKaDumResultApi(context) async {
    final dusKDCont = Provider.of<DusKaDumController>(context, listen: false);
    final profileViewModel = Provider.of<ProfileViewModel>(
      context,
      listen: false,
    );
    dusKaDumLast6JackpotApi(context);
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    _dusKaDumResultRepo
        .dusKaDumResultApi(userId)
        .then((value) {
          if (value.success == true) {
            setListData(value.result16!);
            Future.delayed(const Duration(seconds: 4), () {
              setListData(value.result16!);
              dusKDCont.setResultShowTime(false);
              profileViewModel.profileApi(context);
              setWinAmount(int.parse(value.winAmount.toString()));
              Provider.of<DusKaDumController>(
                context,
                listen: false,
              ).getJokerJackPot(value.result16!.first.jackpot ?? 0, context);
            });
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

  Future<void> dusKaDumLast6JackpotApi(context) async {
    final dusKDCont = Provider.of<DusKaDumController>(context, listen: false);
    final profileViewModel = Provider.of<ProfileViewModel>(
      context,
      listen: false,
    );
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    _dusKaDumResultRepo
        .dusKaDumJackpotApi()
        .then((value) {
          if (value.success == true) {
            Future.delayed(const Duration(seconds: 4), () {
              // setListData(value.result16!);
              setLas6JackPot(value);
              // dusKDCont.setResultShowTime(false);
              // profileViewModel.profileApi(context);
              Provider.of<DusKaDumController>(
                context,
                listen: false,
              ).getJokerJackPot(value.result16!.first.jackpot ?? 0, context);
            });
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
