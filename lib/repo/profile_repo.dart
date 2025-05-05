import 'package:flutter/foundation.dart';
import 'package:super_star/helper/network/base_api_services.dart';
import 'package:super_star/helper/network/network_api_services.dart';
import 'package:super_star/model/profile_model.dart';

import '../res/api_url.dart';


class ProfileRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<ProfileModel> profileApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getGetApiResponse(ApiUrl.profileUrl + data);
      return ProfileModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during profileApi: $e');
      }
      rethrow;
    }
  }
}