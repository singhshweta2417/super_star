import 'package:flutter/foundation.dart';
import 'package:super_star/10_ka_dum/res/api_url.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';
import 'package:super_star/lucky_card_16/model/lucky_16_result_model.dart';

class DusKaDumResultRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<Lucky16ResultModel> dusKaDumResultApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
        DusKaDumApiUrl.dusKaDumResult + data,
      );
      debugPrint("data last result: $response");
      return Lucky16ResultModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during 10 ka dum result: $e');
      }
      rethrow;
    }
  }
}
