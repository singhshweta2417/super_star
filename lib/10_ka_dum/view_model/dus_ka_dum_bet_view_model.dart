import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:super_star/10_ka_dum/controller/dus_ka_dum_controller.dart';
import 'package:super_star/10_ka_dum/repo/bet_repo.dart';
import 'package:super_star/10_ka_dum/view_model/print_view_10_model.dart';
import '../../spin_to_win/view_model/profile_view_model.dart';
import '../../spin_to_win/view_model/user_view_model.dart';
import '../../utils/utils.dart';

class DusKaDumBetViewModel extends ChangeNotifier {
  final _dusKaDumBetRepo = DusKaDumRepository();

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> dusKaDumBetApi(dynamic betList, context) async {
    setLoading(true);
    final profileViewModel = Provider.of<ProfileViewModel>(
      context,
      listen: false,
    );
    final dkdCon = Provider.of<DusKaDumController>(context, listen: false);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {
      "user_id": userId,
      "bets": betList,
      'draw_time ': dkdCon.nextDrawTimeFormatted,
    };
    _dusKaDumBetRepo
        .dusKaDumBetApi(data)
        .then((value) {
          Utils.show(value['message'], context);
          if (value['success'] == true) {
            profileViewModel.profileApi(context);
            // Provider.of<DusKaDumController>(
            //   context,
            //   listen: false,
            // ).setLastBetData();
            if(dkdCon.dusKaDumBets.isNotEmpty && dkdCon.dusKaDumBets !=[] ){
              Provider.of<Printing10Controller>(
                context,
                listen: false,
              ).handleReceiptPrinting(value, betList, context);
              // dkdCon.dusKaDumBets.clear();
            setLoading(false);
          } else {
            setLoading(false);
            Utils.show(value['message'].toString(), context);
          }
        }})
        .onError((error, stackTrace) {
          setLoading(false);
          if (kDebugMode) {
            print('error: $error');
          }
        });
  }
}
