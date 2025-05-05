import 'dart:convert';

class AndarBaharResultModel {
  bool? success;
  String? message;
  int? winAmount;
  ShowResult? showResult;
  List<LastResult>? lastResult;

  AndarBaharResultModel(
      {this.success,
      this.message,
      this.winAmount,
      this.showResult,
      this.lastResult});

  AndarBaharResultModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    winAmount = json['win_amount'];
    showResult = json['show_result'] != null
        ? ShowResult.fromJson(json['show_result'])
        : null;
    if (json['last_result'] != null) {
      lastResult = <LastResult>[];
      json['last_result'].forEach((v) {
        lastResult!.add(LastResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['win_amount'] = winAmount;
    if (showResult != null) {
      data['show_result'] = showResult!.toJson();
    }
    if (lastResult != null) {
      data['last_result'] = lastResult!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShowResult {
  dynamic randomCard;
  List<dynamic>? andarBaharCard;
  int? periodNo;

  ShowResult({this.randomCard, this.andarBaharCard, this.periodNo});

  ShowResult.fromJson(Map<String, dynamic> json) {
    randomCard = jsonDecode(json['random_card']);
    andarBaharCard = jsonDecode(json['andar_bahar_card']);
    periodNo = json['period_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['random_card'] = randomCard;
    data['andar_bahar_card'] = andarBaharCard;
    data['period_no'] = periodNo;
    return data;
  }
}

class LastResult {
  int? number;

  LastResult({this.number});

  LastResult.fromJson(Map<String, dynamic> json) {
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    return data;
  }
}
