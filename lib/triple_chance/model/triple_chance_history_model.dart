class TripleChanceHistoryModel {
  bool? success;
  String? message;
  int? totalAbBets;
  List<Data>? data;

  TripleChanceHistoryModel(
      {this.success, this.message, this.totalAbBets, this.data});

  TripleChanceHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    totalAbBets = json['total_ab_bets'];
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
    data['total_ab_bets'] = totalAbBets;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? amount;
  int? commission;
  int? tradeAmount;
  int? winAmount;
  int? number;
  int? winNumber;
  int? periodNo;
  int? gameId;
  int? userId;
  String? orderId;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? gameName;
  String? name;

  Data(
      {this.id,
        this.amount,
        this.commission,
        this.tradeAmount,
        this.winAmount,
        this.number,
        this.winNumber,
        this.periodNo,
        this.gameId,
        this.userId,
        this.orderId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.gameName,
        this.name});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    commission = json['commission'];
    tradeAmount = json['trade_amount'];
    winAmount = json['win_amount'];
    number = json['number'];
    winNumber = json['win_number'];
    periodNo = json['period_no'];
    gameId = json['game_id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    gameName = json['game_name'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['commission'] = commission;
    data['trade_amount'] = tradeAmount;
    data['win_amount'] = winAmount;
    data['number'] = number;
    data['win_number'] = winNumber;
    data['period_no'] = periodNo;
    data['game_id'] = gameId;
    data['user_id'] = userId;
    data['order_id'] = orderId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['game_name'] = gameName;
    data['name'] = name;
    return data;
  }
}
