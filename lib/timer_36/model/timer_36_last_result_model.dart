class Timer36LastResultModel {
  String? message;
  bool? success;
  List<TimerData>? data;

  Timer36LastResultModel({this.message, this.success, this.data});

  Timer36LastResultModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    if (json['data'] != null) {
      data = <TimerData>[];
      json['data'].forEach((v) {
        data!.add(TimerData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimerData {
  int? id;
  int? gameId;
  int? gamesNo;
  int? number;
  int? gameIndex;
  int? status;
  String? time;

  TimerData(
      {this.id,
      this.gameId,
      this.gamesNo,
      this.number,
      this.gameIndex,
      this.status,
      this.time});

  TimerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gameId = json['game_id'];
    gamesNo = json['games_no'];
    number = json['number'];
    gameIndex = json['index'];
    status = json['status'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['game_id'] = gameId;
    data['games_no'] = gamesNo;
    data['number'] = number;
    data['index'] = gameIndex;
    data['status'] = status;
    data['time'] = time;
    return data;
  }
}
