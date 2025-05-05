import 'package:flutter/foundation.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';


import '../../triple_chance/res/api_url.dart';
import '../model/triple_chance_history_model.dart';



class TripleChanceHistoryRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<TripleChanceHistoryModel> tripleChanceHistoryApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getGetApiResponse(ApiUrl.tripleChanceHistory+ data);
      return TripleChanceHistoryModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during tripleChanceHistoryApi: $e');
      }
      rethrow;
    }
  }
}