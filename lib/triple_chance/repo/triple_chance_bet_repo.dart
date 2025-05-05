import 'package:flutter/foundation.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';

import '../../triple_chance/res/api_url.dart';


class TripleChanceBetRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> tripleChanceBetApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse(ApiUrl.tripleChanceBet, data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during tripleChanceBetApi: $e');
      }
      rethrow;
    }
  }
}