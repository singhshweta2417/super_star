// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:super_star/helper/app_exception.dart';

import 'package:super_star/helper/network/base_api_services.dart';
import 'package:http/http.dart'as http;
class NetworkApiServices extends BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 30));
      if (kDebugMode) {
        print('Api Url : $url');
      }
      responseJson = returnRequest(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(Uri.parse(url),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(data))
          .timeout(const Duration(seconds: 30));
      if (kDebugMode) {
        print('Api Url : $url');
      }
      responseJson = returnRequest(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnRequest(response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        if (kDebugMode) {
          print('response 200: $responseJson');
        }
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error accrued while communicating with server with status code${response.statusCode}');
    }
  }
}
