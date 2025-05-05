import 'package:flutter/foundation.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';
import 'package:super_star/spin_to_win/res/api_url.dart';


class SpinBetRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> spinBetApi(dynamic data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(SpinApiUrl.spinBetUrl, data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during spinBetApi: $e');
      }
      rethrow;
    }
  }
}

