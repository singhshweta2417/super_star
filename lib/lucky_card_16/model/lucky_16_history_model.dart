class Lucky16HistoryModel {
  String? message;
  bool? success;
  dynamic resultCount;
  List<Data>? data;

  Lucky16HistoryModel(
      {this.message, this.success, this.resultCount, this.data});

  Lucky16HistoryModel.fromJson(Map<String, dynamic> json) {
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
  dynamic periodNo;
  dynamic amount;
  dynamic winAmount;
  dynamic ticketId;

  Data({this.periodNo, this.amount, this.winAmount});

  Data.fromJson(Map<String, dynamic> json) {
    periodNo = json['period_no'];
    amount = json['amount'];
    winAmount = json['win_amount'];
    ticketId = json['ticket_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['period_no'] = periodNo;
    data['amount'] = amount;
    data['win_amount'] = winAmount;
    data['ticket_id'] = ticketId;
    return data;
  }
}
