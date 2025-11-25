class ApiUrlTriple {
  static const baseUrl = "https://npl.fctechteam.org/api/triple_chance/";
  static const tripleChanceBet = "${baseUrl}bet";
  static const tripleChanceResult = "${baseUrl}result?user_id=";
  static const tripleChanceHistory = "${baseUrl}bet_history?limit=5&user_id=";
  static const claimWinningTriple =
      "https://superstar.fctechteam.org/api/claim_winning";
 // socket api
  static const timerTripleChanceUrl = "https://foundercodetech.com";
  static const timerEvent = 'npl_triple';

}