import 'package:flutter/foundation.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';
import 'package:super_star/lucky_card_12/model/lucky_12_result_model.dart';
import 'package:super_star/lucky_card_12/res/api_url.dart';



class Lucky12ResultRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<Lucky12ResultModel> lucky12ResultApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getGetApiResponse(ApiUrl.lucky12Result+data);
      return Lucky12ResultModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during lucky12ResultApi: $e');
      }
      rethrow;
    }
  }
}
