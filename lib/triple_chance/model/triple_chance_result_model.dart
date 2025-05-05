class TripleChanceResultModel {
  bool? success;
  String? message;
  dynamic winAmount;
  dynamic firstWheelAmount;
  dynamic secWheelAmount;
  dynamic thirdWheelAmount;
  List<ResultTripleChance>? resultTripleChance;

  TripleChanceResultModel(
      {this.success, this.message, this.winAmount, this.resultTripleChance});

  TripleChanceResultModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    winAmount = json['win_amount'];
    firstWheelAmount = json['first_wheel_amount'];
    secWheelAmount = json['second_wheel_amount'];
    thirdWheelAmount = json['third_wheel_amount'];
    if (json['result_triple_chance'] != null) {
      resultTripleChance = <ResultTripleChance>[];
      json['result_triple_chance'].forEach((v) {
        resultTripleChance!.add(ResultTripleChance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['win_amount'] = winAmount;
    data['first_wheel_amount'] = firstWheelAmount;
    data['second_wheel_amount'] = secWheelAmount;
    data['third_wheel_amount'] = thirdWheelAmount;
    if (resultTripleChance != null) {
      data['result_triple_chance'] =
          resultTripleChance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResultTripleChance {
  int? id;
  int? gamesNo;
  int? wheel1Index;
  int? wheel1Result;
  int? wheel2Index;
  int? wheel2Result;
  int? wheel3Index;
  int? wheel3Result;
  int? status;
  String? time;

  ResultTripleChance(
      {this.id,
        this.gamesNo,
        this.wheel1Index,
        this.wheel1Result,
        this.wheel2Index,
        this.wheel2Result,
        this.wheel3Index,
        this.wheel3Result,
        this.status,
        this.time});

  ResultTripleChance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gamesNo = json['games_no'];
    wheel1Index = json['wheel1_index'];
    wheel1Result = json['wheel1_result'];
    wheel2Index = json['wheel2_index'];
    wheel2Result = json['wheel2_result'];
    wheel3Index = json['wheel3_index'];
    wheel3Result = json['wheel3_result'];
    status = json['status'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['games_no'] = gamesNo;
    data['wheel1_index'] = wheel1Index;
    data['wheel1_result'] = wheel1Result;
    data['wheel2_index'] = wheel2Index;
    data['wheel2_result'] = wheel2Result;
    data['wheel3_index'] = wheel3Index;
    data['wheel3_result'] = wheel3Result;
    data['status'] = status;
    data['time'] = time;
    return data;
  }
}
