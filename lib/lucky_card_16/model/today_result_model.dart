class TodayResultDataModel {
  bool? status;
  String? message;
  List<Data>? data;

  TodayResultDataModel({this.status, this.message, this.data});

  TodayResultDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
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
  int? cardIndex;
  int? colorIndex;
  int? jackpot;
  int? status;
  String? time;

  Data(
      {this.id,
        this.periodNo,
        this.winNumber,
        this.cardIndex,
        this.colorIndex,
        this.jackpot,
        this.status,
        this.time});

  Data.fromJson(Map<String, dynamic> json) {
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
