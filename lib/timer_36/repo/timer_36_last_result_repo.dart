
import 'package:flutter/foundation.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';
import 'package:super_star/timer_36/model/timer_36_last_result_model.dart';
import '../../timer_36/res/api_url.dart';


class Timer36LastResultRepo {
  final BaseApiServices _apiServices = NetworkApiServices();
  Future<Timer36LastResultModel> timer36LastResultApi() async {
    try {
      dynamic response =
      await _apiServices.getGetApiResponse(ApiUrl.timer36LastResult);
      return Timer36LastResultModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during timer36LastResultApi: $e');
      }
      rethrow;
    }
  }
}