class ReportDetailsModel {
  List<Data>? data;

  ReportDetailsModel({this.data});

  ReportDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  dynamic userId;
  dynamic totalWinAmount;
  dynamic totalBetAmount;
  dynamic totalClaimAmount;
  dynamic totalUnclaimAmount;
  dynamic totalPercent;
  dynamic totalProfit;
  List<Bets>? bets;

  Data(
      {this.userId,
        this.totalWinAmount,
        this.totalBetAmount,
        this.totalClaimAmount,
        this.totalUnclaimAmount,
        this.totalPercent,
        this.totalProfit,
        this.bets});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    totalWinAmount = json['total_win_amount'];
    totalBetAmount = json['total_bet_amount'];
    totalClaimAmount = json['total_claim_amount'];
    totalUnclaimAmount = json['total_unclaim_amount'];
    totalPercent = json['total_percent'];
    totalProfit = json['total_profit'];
    if (json['bets'] != null) {
      bets = <Bets>[];
      json['bets'].forEach((v) {
        bets!.add(Bets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['total_win_amount'] = totalWinAmount;
    data['total_bet_amount'] = totalBetAmount;
    data['total_claim_amount'] = totalClaimAmount;
    data['total_unclaim_amount'] = totalUnclaimAmount;
    data['total_percent'] = totalPercent;
    data['total_profit'] = totalProfit;
    if (bets != null) {
      data['bets'] = bets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Bets {
  String? betDate;
  String? ticketId;
  dynamic periodNo;
  dynamic gameId;
  dynamic winNumber;
  String? ticketTime;
  dynamic claimStatus;
  dynamic betAmount;
  dynamic winAmount;

  Bets(
      {this.betDate,
        this.ticketId,
        this.periodNo,
        this.gameId,
        this.winNumber,
        this.ticketTime,
        this.claimStatus,
        this.betAmount,
        this.winAmount});

  Bets.fromJson(Map<String, dynamic> json) {
    betDate = json['bet_date'];
    ticketId = json['ticket_id'];
    periodNo = json['period_no'];
    gameId = json['game_id'];
    winNumber = json['win_number'];
    ticketTime = json['ticket_time'];
    claimStatus = json['claim_status'];
    betAmount = json['bet_amount'];
    winAmount = json['win_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bet_date'] = betDate;
    data['ticket_id'] = ticketId;
    data['period_no'] = periodNo;
    data['game_id'] = gameId;
    data['win_number'] = winNumber;
    data['ticket_time'] = ticketTime;
    data['claim_status'] = claimStatus;
    data['bet_amount'] = betAmount;
    data['win_amount'] = winAmount;
    return data;
  }
}
