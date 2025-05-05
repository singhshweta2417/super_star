import 'package:flutter/foundation.dart';
import 'package:super_star/10_ka_dum/res/api_url.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';
import 'package:super_star/lucky_card_16/model/lucky_16_history_model.dart';
import 'package:super_star/lucky_card_16/model/report_history_model.dart';
import '../../lucky_card_16/model/today_result_model.dart';

class DusKaDumHistoryRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<Lucky16HistoryModel> dusKaDumHistoryApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
        DusKaDumApiUrl.dusKaDumHistory + data,
      );
      debugPrint("10 ka dum history data: $response");
      return Lucky16HistoryModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during 10 ka dum history api: $e');
      }
      rethrow;
    }
  }

  Future<TodayResultDataModel> dusKaDumTodayResultApi() async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
        DusKaDumApiUrl.dusKaDumTodayResult,
      );
      return TodayResultDataModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during 10 ka dum today result: $e');
      }
      rethrow;
    }
  }

  Future<dynamic> dusKaDumHistoryPreviewApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
        DusKaDumApiUrl.dusKaDumPreviewResult,
        data,
      );
      debugPrint("10 ka dum history preview data: $response");
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during 10 ka dum: $e');
      }
      rethrow;
    }
  }

  Future<ReportDetailsModel> dusKaDumGameReportApi(dynamic body) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
        DusKaDumApiUrl.dusKaDumGameReport,
        body,
      );
      return ReportDetailsModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during 10 ka dum report: $e');
      }
      rethrow;
    }
  }

}
