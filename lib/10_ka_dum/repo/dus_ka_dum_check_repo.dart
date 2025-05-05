import 'package:flutter/foundation.dart';
import 'package:super_star/10_ka_dum/res/api_url.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';

class DusKaDumCheckRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> dusKaDumCheckApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
        DusKaDumApiUrl.dusKaDumCheckTicket,
        data,
      );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during lucky16CheckApi: $e');
      }
      rethrow;
    }
  }
}
