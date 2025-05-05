import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:super_star/lucky_card_16/repo/lucky_16_bet_repo.dart';
import 'package:super_star/lucky_card_16/view_model/print_view_model.dart';
import 'package:super_star/utils/utils.dart';

import '../../spin_to_win/view_model/profile_view_model.dart';
import '../../spin_to_win/view_model/user_view_model.dart';
import '../controller/lucky_16_controller.dart';

class Lucky16BetViewModel extends ChangeNotifier {
  final _lucky16BetRepo = Lucky16BetRepository();

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> lucky16BetApi(dynamic betList, context) async {
    setLoading(true);
    final profileViewModel = Provider.of<ProfileViewModel>(
      context,
      listen: false,
    );
    final l16c = Provider.of<Lucky16Controller>(context, listen: false);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {
      "user_id": userId,
      "bets": betList,
      'draw_time ': l16c.nextDrawTimeFormatted,
    };
    _lucky16BetRepo
        .lucky16BetApi(data)
        .then((value) {
          if (value['success'] == true) {
            profileViewModel.profileApi(context);
            if(l16c.addLucky16Bets.isNotEmpty && l16c.addLucky16Bets !=[] ){
              Provider.of<PrintingController>(
                context,
                listen: false,
              ).handleReceiptPrinting(value, betList, context);
            }else{
              if (kDebugMode) {
                print("it is found null");
              }
            }
            // setLoading(false);
          } else {
            setLoading(false);
            Utils.show(value['message'].toString(), context);
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
