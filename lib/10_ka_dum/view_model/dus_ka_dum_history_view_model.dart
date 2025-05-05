
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:super_star/10_ka_dum/repo/dus_ka_dum_his_repo.dart';
import 'package:super_star/lucky_card_16/model/lucky_16_history_model.dart';
import 'package:super_star/lucky_card_16/model/report_history_model.dart';
import '../../lucky_card_16/model/today_result_model.dart';
import '../../spin_to_win/view_model/user_view_model.dart';
import '../widget/ticket_10_preview.dart';

class DusKaDumHistoryViewModel with ChangeNotifier {

  final _dusKaDumHistoryRepo = DusKaDumHistoryRepository();

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Lucky16HistoryModel? _dusKaDumHistoryModel;

  Lucky16HistoryModel? get dusKaDumHistoryModel => _dusKaDumHistoryModel;

  setListData(Lucky16HistoryModel value) {
    _dusKaDumHistoryModel = value;
    notifyListeners();
  }

  TodayResultDataModel? _dusKaDumTodayResultList;
  TodayResultDataModel? get dusKaDumTodayResultList => _dusKaDumTodayResultList;
  setTodayResultData(TodayResultDataModel value) {
    _dusKaDumTodayResultList = value;
    notifyListeners();
  }

  Future<void> dusKaDumHistoryApi(context) async {
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    _dusKaDumHistoryRepo
        .dusKaDumHistoryApi(userId)
        .then((value) {
          if (value.success == true) {
            setListData(value);
          } else {
            if (kDebugMode) {
              print('value: ${value.message}');
            }
          }
        })
        .onError((error, stackTrace) {
          if (kDebugMode) {
            print('error: $error');
          }
        });
  }

  Future<void> dusKaDumTodayResultApi() async {
    _dusKaDumHistoryRepo
        .dusKaDumTodayResultApi()
        .then((value) {
          if (value.status == true) {
            setLoading(false);
            setTodayResultData(value);
          } else {
            setLoading(false);
          }
        })
        .onError((error, stackTrace) {
          setLoading(false);
          if (kDebugMode) {
            print('error: $error');
          }
        });
  }

  dynamic _previewData;
  dynamic get previewData => _previewData;
  setPreviewData(dynamic data) {
    _previewData = data;
    notifyListeners();
  }

  Future<void> dusKaDumHistoryPreviewApi(context, dynamic tktId) async {
    final data = {"ticket_id": tktId};
    print('cdjsb${tktId}');
    _dusKaDumHistoryRepo
        .dusKaDumHistoryPreviewApi(data)
        .then((value) {
          setPreviewData(value);
          List<dynamic> betData = [];

          for (var data in value['data']['bets']) {
            betData.add({'game_id': data['game_id'], 'amount': data['amount']});
          }
          final bets = value['data']['bets'][0];
          final resData = {
            'period_no': bets['period_no'],
            'ticket_id': bets['ticket_id'],
            'ticket_time': bets['ticket_time'],
            'betData': betData,
          };
          showDialog(
            context: context,
            builder: (_) {
              return Ticket10Preview(gameData: resData, betData: betData);
            },
          );
          setListData(value);
        })
        .onError((error, stackTrace) {
          if (kDebugMode) {
            print('error: $error');
          }
        });
  }

  ReportDetailsModel? _reportDetailsData;
  ReportDetailsModel? get reportDetailsData => _reportDetailsData;

  setReportDetails(ReportDetailsModel? data) {
    _reportDetailsData = data;
    notifyListeners();
  }

  bool _reportLoading = false;
  bool get reportLoading => _reportLoading;

  setReportLoading(bool v) {
    _reportLoading = v;
    notifyListeners();
  }

  Future<void> dusKaDumGameReportApi(dynamic startDate, dynamic endDate) async {
    setReportLoading(true);
    setReportDetails(null);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    final body = {
      "user_id": userId,
      "start_date": startDate,
      "end_date": endDate,
    };
    _dusKaDumHistoryRepo
        .dusKaDumGameReportApi(body)
        .then((value) {
          setReportDetails(value);
          setReportLoading(false);
        })
        .onError((error, stackTrace) {
          setReportLoading(false);
          if (kDebugMode) {
            print('error: $error');
          }
        });
  }
}
