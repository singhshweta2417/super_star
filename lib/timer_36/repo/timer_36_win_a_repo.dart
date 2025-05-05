
import 'package:flutter/foundation.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';
import '../../timer_36/res/api_url.dart';


class Timer36WinARepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> timer36WinAApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getGetApiResponse(ApiUrl.time36WinAmount+data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during timer36WinAApi: $e');
      }
      rethrow;
    }
  }
}