import 'package:flutter/foundation.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';
import 'package:super_star/spin_to_win/model/spin_history_model.dart';
import 'package:super_star/spin_to_win/res/api_url.dart';

class SpinHistoryRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<SpinHistoryModel> spinHistoryApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse(SpinApiUrl.spinHistoryUrl + data);
      return SpinHistoryModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during spinHistoryApi: $e');
      }
      rethrow;
    }
  }
}
