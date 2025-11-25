import 'package:flutter/foundation.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';

import '../res/api_url.dart';


class ClaimWinningDKDRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> claimWinningDApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
        DusKaDumApiUrl.claimWinningD,
        data,
      );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during claimWinningDApi: $e');
      }
      rethrow;
    }
  }
}
