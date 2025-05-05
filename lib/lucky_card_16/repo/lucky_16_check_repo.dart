import 'package:flutter/foundation.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';
import 'package:super_star/lucky_card_16/res/api_url.dart';


class Lucky16CheckRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> lucky16CheckApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse(ApiUrl.checkTicket, data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during lucky16CheckApi: $e');
      }
      rethrow;
    }
  }
}