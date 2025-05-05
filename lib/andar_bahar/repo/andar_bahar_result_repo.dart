import 'package:flutter/foundation.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';

import '../model/andar_bahar_result_model.dart';
import '../res/api_urls.dart';


class AndarBaharResultRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<AndarBaharResultModel> anderBaharResultApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getGetApiResponse(ApiUrl.anderBaharResult+data);
      return AndarBaharResultModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during anderBaharResultApi: $e');
      }
      rethrow;
    }
  }
}