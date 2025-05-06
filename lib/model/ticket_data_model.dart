class TicketModel {
  bool? success;
  String? message;
  Data? data;

  TicketModel({this.success, this.message, this.data});

  TicketModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  int? periodNo;
  int? gameId;
  int? amount;
  String? drawTime;
  int? winNumber;
  int? winAmount;
  String? ticketId;
  String? ticketTime;
  int? status;
  int? claimStatus;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.userId,
        this.periodNo,
        this.gameId,
        this.amount,
        this.drawTime,
        this.winNumber,
        this.winAmount,
        this.ticketId,
        this.ticketTime,
        this.status,
        this.claimStatus,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    periodNo = json['period_no'];
    gameId = json['game_id'];
    amount = json['amount'];
    drawTime = json['draw_time'];
    winNumber = json['win_number'];
    winAmount = json['win_amount'];
    ticketId = json['ticket_id'];
    ticketTime = json['ticket_time'];
    status = json['status'];
    claimStatus = json['claim_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['period_no'] = periodNo;
    data['game_id'] = gameId;
    data['amount'] = amount;
    data['draw_time'] = drawTime;
    data['win_number'] = winNumber;
    data['win_amount'] = winAmount;
    data['ticket_id'] = ticketId;
    data['ticket_time'] = ticketTime;
    data['status'] = status;
    data['claim_status'] = claimStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
