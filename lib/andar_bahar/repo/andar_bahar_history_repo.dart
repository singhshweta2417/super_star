import 'package:flutter/foundation.dart';
import 'package:super_star/andar_bahar/model/andar_bahar_history_model.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';

import '../res/api_urls.dart';


class AndarBaharHistoryRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<AndarBaharHistoryModel> anderBaharHistoryApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getGetApiResponse(ApiUrl.andarBaharHistoryUrl+data);
      return AndarBaharHistoryModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during anderBaharHistoryApi: $e');
      }
      rethrow;
    }
  }
}