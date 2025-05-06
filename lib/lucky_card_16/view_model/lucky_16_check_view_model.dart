import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:super_star/lucky_card_16/repo/lucky_16_check_repo.dart';
import 'package:super_star/lucky_card_16/widgets/winner_claim_popup.dart';
import 'package:super_star/spin_to_win/view_model/user_view_model.dart';
import 'package:super_star/utils/utils.dart';
import '../../model/ticket_data_model.dart';
import '../../spin_to_win/view_model/profile_view_model.dart'
    show ProfileViewModel;

class Lucky16CheckViewModel with ChangeNotifier {
  final _lucky16CheckRepo = Lucky16CheckRepository();

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  TicketModel? _ticketData;
  TicketModel? get ticketData => _ticketData;
  setTicketData(TicketModel data, BuildContext context) {
    _ticketData = data;
    notifyListeners();
  }

  Future<void> lucky16CheckApi(context, String ticketId) async {
    try {
      setLoading(true);
      final userId = await UserViewModel().getUser();
      Map<String, dynamic> data = {"ticket_id": ticketId, 'user_id': userId};
      await _lucky16CheckRepo.lucky16CheckApi(data).then((value) {
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
                return WinnerClaimPopup(ticketData: ticket);

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
