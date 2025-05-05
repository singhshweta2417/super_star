class ApiUrl {
  static const String baseUrl = 'https://npl.fctechteam.org/api/';
  //blue 36 urls
  static const String timer36Bet = '${baseUrl}timer_36_bet';
  static const String timer36LastResult = '${baseUrl}timer_36_last_result';
  static const String time36WinAmount = '${baseUrl}timer_36_win_amount?user_id=';
  static const String timer36GameHistory = '${baseUrl}timer_36_bet_history?limit=5&user_id=';
  //socket api 60s timer
  static const String timer36TimerEndPoint="https://foundercodetech.com";
  static const String eventName='timer';
}