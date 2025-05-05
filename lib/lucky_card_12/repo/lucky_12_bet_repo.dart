import 'package:flutter/foundation.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';
import 'package:super_star/lucky_card_12/res/api_url.dart';



class Lucky12BetRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> lucky12BetApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse(ApiUrl.lucky12Bet, data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during lucky12BetApi: $e');
      }
      rethrow;
    }
  }
}