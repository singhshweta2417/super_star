import 'package:flutter/foundation.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';

// import '../../andar_bahar/res/api_urls.dart';
import '../../timer_36/res/api_url.dart';

class Timer36BetRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> timer36BetApi(dynamic data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(ApiUrl.timer36Bet, data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during timer36BetApi: $e');
      }
      rethrow;
    }
  }
}
