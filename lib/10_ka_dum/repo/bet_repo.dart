import 'package:flutter/foundation.dart';
import 'package:super_star/10_ka_dum/res/api_url.dart';

import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';

class DusKaDumRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> dusKaDumBetApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
        DusKaDumApiUrl.dusKaDumBet,
        data,
      );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during dusKaDumBetApi: $e');
      }
      rethrow;
    }
  }
}
