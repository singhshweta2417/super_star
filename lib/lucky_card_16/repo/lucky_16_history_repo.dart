import 'package:flutter/foundation.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';
import 'package:super_star/lucky_card_16/model/lucky_16_history_model.dart';
import 'package:super_star/lucky_card_16/model/report_history_model.dart';
import 'package:super_star/lucky_card_16/res/api_url.dart';

import '../model/today_result_model.dart';

class Lucky16HistoryRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<Lucky16HistoryModel> lucky16HistoryApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getGetApiResponse(ApiUrl.lucky16history+ data);
      debugPrint("lucky 16 history data: $response");
      return Lucky16HistoryModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during lucky16HistoryApi: $e');
      }
      rethrow;
    }
  }

  Future<TodayResultDataModel> lucky16TodayResultApi() async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
        ApiUrl.todayResult,
      );
      return TodayResultDataModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during lucky16ResultApi: $e');
      }
      rethrow;
    }
  }

  Future<dynamic> lucky16HistoryPreviewApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse(ApiUrl.previewResult, data);
      debugPrint("lucky 16 history preview data: $response");
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during lucky16HistoryPreviewApi: $e');
      }
      rethrow;
    }
  }


  Future<ReportDetailsModel> lucky16GameReportApi(dynamic body) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
        ApiUrl.gameReport,body
      );
      // print("data $response");
      return ReportDetailsModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during lucky 16 report: $e');
      }
      rethrow;
    }
  }
}