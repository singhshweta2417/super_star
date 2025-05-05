import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:super_star/andar_bahar/view_model/andar_bahar_bet_view_model.dart';
import 'package:super_star/andar_bahar/view_model/andar_bahar_result_view_model.dart';
import 'package:super_star/andar_bahar/widgets/animated_coin.dart';
import 'package:super_star/generated/assets.dart';

import '../../spin_to_win/view_model/profile_view_model.dart';
import '../res/api_urls.dart';

class AndarBaharController with ChangeNotifier {
  bool _pageLoading = false;
  bool get pageLoading => _pageLoading;

  void setPageLoading(bool value) {
    _pageLoading = value;
    notifyListeners();
  }

  bool _showBetCard = false;
  bool get showBetCard => _showBetCard;

  void setShowBetCard(bool value) {
    _showBetCard = value;
    notifyListeners();
  }

  int _betSetPosition = 1;
  int get betSetPosition => _betSetPosition;

  void setBetPosition(int value) {
    _betSetPosition = value;
    notifyListeners();
  }

  // add user coin
  List<Widget> anderUserCoins = [];
  List<Widget> baharUserCoins = [];
  randomPosition(int min, int max) {
    Random random = Random();
    return double.parse((min + random.nextInt(max - min + 1)).toString());
  }

  // show card list
  List<Map<String, dynamic>> andarList = [];
  List<Map<String, dynamic>> baharList = [];

  // add bet function
  List<Map<String, int>> addAndarBaharBets = [];
  int andarTotalBetAmount = 0;
  int baharTotalBetAmount = 0;

  bool _toastShown = false;
  bool _betTimeStartShown = false;

  // random person value
  int? renVal;
  void randomPerValue() {
    final random = Random();
    int randomValue = 60 + random.nextInt(751 - 60);
    renVal = randomValue;
    notifyListeners();
  }

  bool isPlayAllowed() {
    if ((timerStatus == 1 && timerBetTime <= 5) || timerStatus == 2) {
      if (!_toastShown) {
        if (kDebugMode) {
          print('Wait for next round!');
        }
        _toastShown = true;
      }
      _betTimeStartShown = false;
      return false;
    }
    _toastShown = false;
    if (!_betTimeStartShown && timerStatus == 1) {
      if (kDebugMode) {
        print('Place our bets!');
      }
      _betTimeStartShown = true;
    }
    return true;
  }

  void andarBaharAddBet(int number, int amount, context) {
    if (!isPlayAllowed()) return;
    // bet condition
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    if (amount > profileViewModel.balance) {
      if (kDebugMode) {
        print('INSUFFICIENT BALANCE');
      }
      return;
    }

    bool betExists = false;
    for (var bet in addAndarBaharBets) {
      if (bet['number'] == number) {
        bet['amount'] = (bet['amount'] ?? 0) + amount;
        betExists = true;
        break;
      }
    }
    if (!betExists) {
      addAndarBaharBets.add({'number': number, 'amount': amount});
    }
    if (number == 1) {
      andarTotalBetAmount += amount;
      anderUserCoins.add(Positioned(
          left: randomPosition(1, 150),
          top: randomPosition(1, 50),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    coinList.firstWhere((coin) => coin.value == amount).image,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          )));
    } else {
      baharTotalBetAmount += amount;
      baharUserCoins.add(Positioned(
          left: randomPosition(1, 150),
          top: randomPosition(1, 50),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    coinList.firstWhere((coin) => coin.value == amount).image,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          )));
    }

    profileViewModel.deductBalance(amount);
    notifyListeners();
  }

  void clearBet(context) {
    addAndarBaharBets.clear();
    andarTotalBetAmount = 0;
    baharTotalBetAmount = 0;
    anderRandomCoins.clear();
    baharRandomCoins.clear();
    anderUserCoins.clear();
    baharUserCoins.clear();
  }

  List<AndarBCoinModel> coinList = [
    AndarBCoinModel(image: Assets.andarB5, value: 5),
    AndarBCoinModel(image: Assets.andarB10, value: 10),
    AndarBCoinModel(image: Assets.andarB50, value: 50),
    AndarBCoinModel(image: Assets.andarB100, value: 100),
    AndarBCoinModel(image: Assets.andarB500, value: 500),
    AndarBCoinModel(image: Assets.andarB1000, value: 1000),
  ];

  List<CardMatchModel> cardMatchList = [
    //A
    CardMatchModel(image: Assets.cardRsa, cardColor: 'D', value: 1),
    CardMatchModel(image: Assets.cardRpa, cardColor: 'H', value: 1),
    CardMatchModel(image: Assets.cardBpa, cardColor: 'S', value: 1),
    CardMatchModel(image: Assets.cardBla, cardColor: 'C', value: 1),
    //2
    CardMatchModel(image: Assets.cardRs2, cardColor: 'D', value: 2),
    CardMatchModel(image: Assets.cardRp2, cardColor: 'H', value: 2),
    CardMatchModel(image: Assets.cardBp2, cardColor: 'S', value: 2),
    CardMatchModel(image: Assets.cardBl2, cardColor: 'C', value: 2),
    //3
    CardMatchModel(image: Assets.cardRs3, cardColor: 'D', value: 3),
    CardMatchModel(image: Assets.cardRp3, cardColor: 'H', value: 3),
    CardMatchModel(image: Assets.cardBp3, cardColor: 'S', value: 3),
    CardMatchModel(image: Assets.cardBl3, cardColor: 'C', value: 3),
    //4
    CardMatchModel(image: Assets.cardRs4, cardColor: 'D', value: 4),
    CardMatchModel(image: Assets.cardRp4, cardColor: 'H', value: 4),
    CardMatchModel(image: Assets.cardBp4, cardColor: 'S', value: 4),
    CardMatchModel(image: Assets.cardBl4, cardColor: 'C', value: 4),
    //5
    CardMatchModel(image: Assets.cardRs5, cardColor: 'D', value: 5),
    CardMatchModel(image: Assets.cardRp5, cardColor: 'H', value: 5),
    CardMatchModel(image: Assets.cardBp5, cardColor: 'S', value: 5),
    CardMatchModel(image: Assets.cardBl5, cardColor: 'C', value: 5),
    //6
    CardMatchModel(image: Assets.cardRs6, cardColor: 'D', value: 6),
    CardMatchModel(image: Assets.cardRp6, cardColor: 'H', value: 6),
    CardMatchModel(image: Assets.cardBp6, cardColor: 'S', value: 6),
    CardMatchModel(image: Assets.cardBl6, cardColor: 'C', value: 6),
    //7
    CardMatchModel(image: Assets.cardRs7, cardColor: 'D', value: 7),
    CardMatchModel(image: Assets.cardRp7, cardColor: 'H', value: 7),
    CardMatchModel(image: Assets.cardBp7, cardColor: 'S', value: 7),
    CardMatchModel(image: Assets.cardBl7, cardColor: 'C', value: 7),
    //8
    CardMatchModel(image: Assets.cardRs8, cardColor: 'D', value: 8),
    CardMatchModel(image: Assets.cardRp8, cardColor: 'H', value: 8),
    CardMatchModel(image: Assets.cardBp8, cardColor: 'S', value: 8),
    CardMatchModel(image: Assets.cardBl8, cardColor: 'C', value: 8),
    //9
    CardMatchModel(image: Assets.cardRs9, cardColor: 'D', value: 9),
    CardMatchModel(image: Assets.cardRp9, cardColor: 'H', value: 9),
    CardMatchModel(image: Assets.cardBp9, cardColor: 'S', value: 9),
    CardMatchModel(image: Assets.cardBl9, cardColor: 'C', value: 9),
    //10
    CardMatchModel(image: Assets.cardRs10, cardColor: 'D', value: 10),
    CardMatchModel(image: Assets.cardRp10, cardColor: 'H', value: 10),
    CardMatchModel(image: Assets.cardBp10, cardColor: 'S', value: 10),
    CardMatchModel(image: Assets.cardBl10, cardColor: 'C', value: 10),
    //J
    CardMatchModel(image: Assets.cardRsj, cardColor: 'D', value: 11),
    CardMatchModel(image: Assets.cardRpj, cardColor: 'H', value: 11),
    CardMatchModel(image: Assets.cardBpj, cardColor: 'S', value: 11),
    CardMatchModel(image: Assets.cardBlj, cardColor: 'C', value: 11),
    //Q
    CardMatchModel(image: Assets.cardRsq, cardColor: 'D', value: 12),
    CardMatchModel(image: Assets.cardRpq, cardColor: 'H', value: 12),
    CardMatchModel(image: Assets.cardBpq, cardColor: 'S', value: 12),
    CardMatchModel(image: Assets.cardBlq, cardColor: 'C', value: 12),
    //K
    CardMatchModel(image: Assets.cardRsk, cardColor: 'D', value: 13),
    CardMatchModel(image: Assets.cardRpk, cardColor: 'H', value: 13),
    CardMatchModel(image: Assets.cardBpk, cardColor: 'S', value: 13),
    CardMatchModel(image: Assets.cardBlk, cardColor: 'C', value: 13),
  ];

  List<String> getCardImages(dynamic givenList) {
    List<String> images = [];
    for (var cardValue in givenList) {
      for (var cardImage in cardMatchList) {
        if (cardValue['cardColor'] == cardImage.cardColor &&
            cardValue['value'] == cardImage.value) {
          images.add(cardImage.image);
          break;
        }
      }
    }
    return images;
  }

  List<Widget> anderRandomCoins = [];
  List<Widget> baharRandomCoins = [];
  void addRandomCoins(int count) {
    anderRandomCoins.clear();
    baharRandomCoins.clear();
    for (int i = 0; i < count; i++) {
      Timer(Duration(milliseconds: i * 200), () {
        anderRandomCoins.add(
          const AnimatedCoin(
            type: 0,
          ),
        );
        baharRandomCoins.add(
          const AnimatedCoin(
            type: 1,
          ),
        );
        notifyListeners();
      });
    }
  }

  // timer data
  int _timerBetTime = 0;
  int _timerStatus = 0;

  int get timerBetTime => _timerBetTime;
  int get timerStatus => _timerStatus;
  void setTimerData(int betTime, int status) {
    _timerBetTime = betTime;
    _timerStatus = status;
    notifyListeners();
  }

  bool betBool = false;
  late IO.Socket _socket;
  AndarBaharBetViewModel andarBaharBetViewModel = AndarBaharBetViewModel();
  void connectToServer(context) async {
    _socket = IO.io(
      ApiUrl.timerAnderBaharUrl,
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );
    _socket.on('connect', (_) {
      if (kDebugMode) {
        print('Connected');
      }
    });
    _socket.onConnectError((errorData) {
      if (kDebugMode) {
        print('Connection error: $errorData');
      }
    });
    _socket.on(ApiUrl.timerEvent, (timerData) {
      final receiveData = jsonDecode(timerData);
      setTimerData(receiveData['timerBetTime'], receiveData['timerStatus']);
      // bet api
      if (receiveData['timerStatus'] == 1 &&
          receiveData['timerBetTime'] == 30) {
        andarList.clear();
        baharList.clear();
        addRandomCoins(50);
        randomPerValue();
        final andarBaharResultViewModel =
            Provider.of<AndarBaharResultViewModel>(context, listen: false);
        // first time hit result api
        andarBaharResultViewModel.anderBaharResultApi(context, 2);
      }
      // bet api
      if (receiveData['timerStatus'] == 1 && receiveData['timerBetTime'] == 5) {
        betBool = false;
        if (addAndarBaharBets.isNotEmpty && betBool == false) {
          andarBaharBetViewModel.andarBaharBetApi(addAndarBaharBets, context);
          betBool = true;
        }
      }
      // result api
      if (receiveData['timerStatus'] == 2 &&
          receiveData['timerBetTime'] == 15) {
        final andarBaharResultViewModel =
            Provider.of<AndarBaharResultViewModel>(context, listen: false);
        andarBaharResultViewModel.anderBaharResultApi(context, 0);
      }
      if (receiveData['timerStatus'] == 2 && receiveData['timerBetTime'] == 2) {
        clearBet(context);
        setShowBetCard(false);
      }

      // if (kDebugMode) {
      //   print('Time: ${receiveData['timerBetTime']}');
      //   print('Status: ${receiveData['timerStatus']}');
      // }
    });
    _socket.connect();
  }

  void disConnectToServer(context) async {
    _socket.disconnect();
    _socket.clearListeners();
    _socket.close();
    if (kDebugMode) {
      print('SOCKET DISCONNECT');
    }
  }

  int _showCardValue = 0;
  int get showCardValue => _showCardValue;
  String _showCardColor = '';
  String get showCardColor => _showCardColor;
  setShowCardData(int cardValue, String cardColor) {
    _showCardValue = cardValue;
    _showCardColor = cardColor;
    notifyListeners();
  }
}

class AndarBCoinModel {
  final String image;
  final int value;
  AndarBCoinModel({required this.image, required this.value});
}

class CardMatchModel {
  final String image;
  final String cardColor;
  final int value;
  CardMatchModel({
    required this.image,
    required this.cardColor,
    required this.value,
  });
}
