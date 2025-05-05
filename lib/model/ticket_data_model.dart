class Ticket {
  bool? success;
  int? id;
  int? userId;
  int? periodNo;
  int? gameId;
  int? amount;
  int? winNumber;
  int? winAmount;
  String? ticketId;
  String? ticketTime;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? message;

  Ticket(
      {this.success,
        this.id,
        this.userId,
        this.periodNo,
        this.gameId,
        this.amount,
        this.winNumber,
        this.winAmount,
        this.ticketId,
        this.ticketTime,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.message});

  Ticket.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    id = json['id'];
    userId = json['user_id'];
    periodNo = json['period_no'];
    gameId = json['game_id'];
    amount = json['amount'];
    winNumber = json['win_number'];
    winAmount = json['win_amount'];
    ticketId = json['ticket_id'];
    ticketTime = json['ticket_time'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['id'] = id;
    data['user_id'] = userId;
    data['period_no'] = periodNo;
    data['game_id'] = gameId;
    data['amount'] = amount;
    data['win_number'] = winNumber;
    data['win_amount'] = winAmount;
    data['ticket_id'] = ticketId;
    data['ticket_time'] = ticketTime;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['message'] = message;
    return data;
  }
}
