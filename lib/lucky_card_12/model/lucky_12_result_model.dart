class Lucky12ResultModel {
  bool? success;
  String? message;
  int? winAmount;
  List<Result12>? result12;

  Lucky12ResultModel(
      {this.success, this.message, this.winAmount, this.result12});

  Lucky12ResultModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    winAmount = json['win_amount'];
    if (json['result_12'] != null) {
      result12 = <Result12>[];
      json['result_12'].forEach((v) {
        result12!.add(Result12.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['win_amount'] = winAmount;
    if (result12 != null) {
      data['result_12'] = result12!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result12 {
  int? id;
  int? periodNo;
  int? winNumber;
  int? cardIndex;
  int? colorIndex;
  int? jackpot;
  int? status;
  String? time;

  Result12(
      {this.id,
      this.periodNo,
      this.winNumber,
      this.cardIndex,
      this.colorIndex,
      this.jackpot,
      this.status,
      this.time});

  Result12.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    periodNo = json['period_no'];
    winNumber = json['win_number'];
    cardIndex = json['card_index'];
    colorIndex = json['color_index'];
    jackpot = json['jackpot'];
    status = json['status'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['period_no'] = periodNo;
    data['win_number'] = winNumber;
    data['card_index'] = cardIndex;
    data['color_index'] = colorIndex;
    data['jackpot'] = jackpot;
    data['status'] = status;
    data['time'] = time;
    return data;
  }
}
