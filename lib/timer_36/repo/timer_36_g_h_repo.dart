import 'package:flutter/foundation.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';
import 'package:super_star/timer_36/model/timer_36_g_h_model.dart';
import '../../timer_36/res/api_url.dart';


class Timer36GHRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<Timer36GHModel> timer36GHApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getGetApiResponse(ApiUrl.timer36GameHistory+data);
      return Timer36GHModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during timer36GHApi: $e');
      }
      rethrow;
    }
  }
}