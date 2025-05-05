import 'package:flutter/foundation.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';
import '../../triple_chance/res/api_url.dart';
import '../model/triple_chance_result_model.dart';


class TripleChanceResultRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<TripleChanceResultModel> tripleChanceResultApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getGetApiResponse(ApiUrl.tripleChanceResult+data);
      return TripleChanceResultModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during tripleChanceResultApi: $e');
      }
      rethrow;
    }
  }
}
