class Lucky12HistoryModel {
  String? message;
  bool? success;
  int? resultCount;
  List<Data>? data;

  Lucky12HistoryModel(
      {this.message, this.success, this.resultCount, this.data});

  Lucky12HistoryModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    resultCount = json['result_count'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['success'] = success;
    data['result_count'] = resultCount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? periodNo;
  int? amount;
  int? winAmount;

  Data({this.periodNo, this.amount, this.winAmount});

  Data.fromJson(Map<String, dynamic> json) {
    periodNo = json['period_no'];
    amount = json['amount'];
    winAmount = json['win_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['period_no'] = periodNo;
    data['amount'] = amount;
    data['win_amount'] = winAmount;
    return data;
  }
}
