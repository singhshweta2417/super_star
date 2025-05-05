import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:super_star/lucky_card_16/model/lucky_16_history_model.dart';
import 'package:super_star/lucky_card_16/model/report_history_model.dart';
import 'package:super_star/lucky_card_16/repo/lucky_16_history_repo.dart';

import '../../spin_to_win/view_model/user_view_model.dart';
import '../../utils/printing/ticket_preview.dart';
import '../model/today_result_model.dart';

class Lucky16HistoryViewModel with ChangeNotifier {
  final _lucky16HistoryRepo = Lucky16HistoryRepository();

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Lucky16HistoryModel? _lucky16HistoryModel;

  Lucky16HistoryModel? get lucky16HistoryModel => _lucky16HistoryModel;

  setListData(Lucky16HistoryModel value) {
    _lucky16HistoryModel = value;
    notifyListeners();
  }

  TodayResultDataModel? _lucky16TodayResultList;
  TodayResultDataModel? get lucky16TodayResultList => _lucky16TodayResultList;
  setTodayResultData(TodayResultDataModel value) {
    _lucky16TodayResultList = value;
    notifyListeners();
  }

  Future<void> lucky16HistoryApi(context) async {
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    _lucky16HistoryRepo
        .lucky16HistoryApi(userId)
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

  Future<void> lucky16TodayResultApi() async {
    _lucky16HistoryRepo
        .lucky16TodayResultApi()
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

  Future<void> lucky16HistoryPreviewApi(context, dynamic tktId) async {
    final data = {"ticket_id": tktId};
    _lucky16HistoryRepo
        .lucky16HistoryPreviewApi(data)
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
              return TicketPreview(gameData: resData, betData: betData);
            },
          );
          setListData(value);
          // } else {
          //   if (kDebugMode) {
          //     print('value: ${value.message}');
          //   }
          // }
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

  Future<void> lucky16GameReportApi(dynamic startDate, dynamic endDate) async {
    setReportLoading(true);
    setReportDetails(null);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    final body = {
      "user_id": userId,
      "start_date": startDate,
      "end_date": endDate,
    };
    _lucky16HistoryRepo
        .lucky16GameReportApi(body)
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
