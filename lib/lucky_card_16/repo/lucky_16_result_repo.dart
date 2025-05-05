import 'package:flutter/foundation.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';
import 'package:super_star/lucky_card_16/model/lucky_16_result_model.dart';
import 'package:super_star/lucky_card_16/res/api_url.dart';

class Lucky16ResultRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<Lucky16ResultModel> lucky16ResultApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
        ApiUrl.lucky16Result + data,
      );
      debugPrint("data last result: $response");
      return Lucky16ResultModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during lucky16ResultApi: $e');
      }
      rethrow;
    }
  }


}
