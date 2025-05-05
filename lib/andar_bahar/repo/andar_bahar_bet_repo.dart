import 'package:flutter/foundation.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';

import '../res/api_urls.dart';


class AndarBaharBetRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> andarBaharBetApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse(ApiUrl.andarBaharBet, data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during andarBaharBetApi: $e');
      }
      rethrow;
    }
  }
}