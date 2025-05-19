class Last6JackPotResult {
  bool? success;
  String? message;
  List<Result16>? result16;

  Last6JackPotResult({this.success, this.message, this.result16});

  Last6JackPotResult.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['result_16'] != null) {
      result16 = <Result16>[];
      json['result_16'].forEach((v) {
        result16!.add(Result16.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (result16 != null) {
      data['result_16'] = result16!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result16 {
  dynamic id;
  dynamic periodNo;
  dynamic winNumber;
  dynamic cardIndex;
  dynamic colorIndex;
  dynamic jackpot;
  dynamic status;
  dynamic time;

  Result16(
      {this.id,
        this.periodNo,
        this.winNumber,
        this.cardIndex,
        this.colorIndex,
        this.jackpot,
        this.status,
        this.time});

  Result16.fromJson(Map<String, dynamic> json) {
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
