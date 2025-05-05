class SpinResultModel {
  bool? success;
  String? message;
  int? winAmount;
  List<Data>? data;

  SpinResultModel({this.success, this.message, this.winAmount, this.data});

  SpinResultModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    winAmount = json['win_amount'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['win_amount'] = winAmount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? periodNo;
  int? winNumber;
  int? winIndex;
  int? jackpot;

  Data(
      {this.id,
      this.periodNo,
      this.winNumber,
      this.winIndex,
      this.jackpot,
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    periodNo = json['period_no'];
    winNumber = json['win_number'];
    winIndex = json['win_index'];
    jackpot = json['jackpot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['period_no'] = periodNo;
    data['win_number'] = winNumber;
    data['win_index'] = winIndex;
    data['jackpot'] = jackpot;
    return data;
  }
}
