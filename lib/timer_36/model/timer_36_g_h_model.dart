class Timer36GHModel {
  String? message;
  bool? success;
  int? resultCount;
  List<Data>? data;

  Timer36GHModel({this.message, this.success, this.resultCount, this.data});

  Timer36GHModel.fromJson(Map<String, dynamic> json) {
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
  int? gamesNo;
  int? number;
  String? gameId;
  String? amount;
  String? winAmount;

  Data({this.gamesNo, this.number, this.gameId, this.amount, this.winAmount});

  Data.fromJson(Map<String, dynamic> json) {
    gamesNo = json['games_no'];
    number = json['number'];
    gameId = json['game_id'];
    amount = json['amount'];
    winAmount = json['win_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['games_no'] = gamesNo;
    data['number'] = number;
    data['game_id'] = gameId;
    data['amount'] = amount;
    data['win_amount'] = winAmount;
    return data;
  }
}
