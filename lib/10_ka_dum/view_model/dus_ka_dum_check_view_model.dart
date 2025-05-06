import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:super_star/10_ka_dum/repo/dus_ka_dum_check_repo.dart';
import 'package:super_star/spin_to_win/view_model/user_view_model.dart';
import 'package:super_star/utils/utils.dart';
import '../../model/ticket_data_model.dart';
import '../../spin_to_win/view_model/profile_view_model.dart'
    show ProfileViewModel;
import '../widget/winner_claim_popup.dart';

class DusKaDumCheckViewModel with ChangeNotifier {
  final _dusKaDumCheckRepo = DusKaDumCheckRepository();

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  TicketModel? _ticketData;
  TicketModel? get ticketData => _ticketData;

  setTicketData(TicketModel data) {
    _ticketData = data;
    notifyListeners();
  }

  Future<void> dusKaDumCheckApi(context, String ticketId) async {
    try {
      setLoading(true);
      final userId = await UserViewModel().getUser();
      Map<String, dynamic> data = {"ticket_id": ticketId, 'user_id': userId};
      await _dusKaDumCheckRepo.dusKaDumCheckApi(data).then((value) {
        final ticket = value;
        if (ticket['data'] != null) {
          Provider.of<ProfileViewModel>(
            context,
            listen: false,
          ).profileApi(context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showCupertinoDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) {
                return WinnerDusClaimPopup(ticketData: ticket);
              },
            );
          });
        } else {
          setLoading(false);
          Utils.show(value['message'].toString(), context);
        }
      });
    } catch (error) {
      setLoading(false);
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat("d MMM 'at' h:mm a").format(dateTime);
  }
}
