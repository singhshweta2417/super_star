import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:super_star/generated/assets.dart';
import 'package:super_star/timer_36/view_model/timer_36_bet_view_model.dart';
import 'package:super_star/timer_36/view_model/timer_36_last_result_view_model.dart';
import '../../spin_to_win/view_model/profile_view_model.dart';
import '../../utils/utils.dart';
import '../../timer_36/res/api_url.dart';


class Timer36Controller with ChangeNotifier {
  late void Function() startWheel;
  late void Function(int index) stopWheel;

  void notifyStart() {
    startWheel();
    notifyListeners();
  }

  void notifyStop(int index) {
    stopWheel(index);
    notifyListeners();
  }

  late void Function() startWheels;
  late void Function(int index) stopWheels;

  void notifyStarts() {
    startWheels();
    notifyListeners();
  }

  void notifyStops(int index) {
    stopWheels(index);
    notifyListeners();
  }

  int _gamesNo = 0;
  int get gamesNo => _gamesNo;

  void setGamesNo(int gamesNo) {
    _gamesNo = gamesNo;
    notifyListeners();
  }


  int _showData = 0;
  int get showData => _showData;

  void notifyData(int index) {
    _showData = index;
    notifyListeners();
  }

  bool _indicateResult = false;
  bool get indicateResult => _indicateResult;

  void indResult(bool value) {
    _indicateResult = value;
    notifyListeners();
  }

  bool _hideDesign = false;
  bool get hideDesign => _hideDesign;

  void isTenSecToResult(bool value) {
    _hideDesign = value;
    notifyListeners();
  }

  bool _hideValue = false;
  bool get hideValue => _hideValue;

  void isHideValue(bool value) {
    _hideValue = value;
    notifyListeners();
  }

  // selected chip value
  int betValue = 0;
  // total bet amount
  int totalBetAmount = 0;
  // added bet list
  List<Map<dynamic, int>> bets = [];
  bool _showButtons = false;
  bool get showButtons => _showButtons;
  void isShowButtons(bool value) {
    _showButtons = value;
    notifyListeners();
  }

  void activeSingleBet(int id, int amount, context) {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);

    if ((timerBetTime <= 10 && timerStatus == 1) ||
        (timerBetTime <= 10 && timerStatus == 2)) {
      Utils.showImage(Assets.timer36WaitToComplete, context);
    } else {
      if (resetOne == false) {
        if (betValue != 0) {
          bool betExists = false;
          for (var bet in bets) {
            if (bet['game_id'] == id) {
              int newAmount = (bet['amount'] ?? 0) + amount;
              if ((id >= 37 && id <= 48) && newAmount < 10) {
                Utils.showImage(Assets.timer36GrThan10, context);
                if (kDebugMode) {
                  print('GREATER THAN 10RS');
                }
                return;
              }
              bet['amount'] = newAmount;
              betExists = true;
              break;
            }
          }

          if (!betExists) {
            if ((id >= 37 && id <= 48) && amount < 10) {
              Utils.showImage(Assets.timer36GrThan10, context);
              if (kDebugMode) {
                print('GREATER THAN 10RS');
              }
              return;
            }
            bets.add({'game_id': id, 'amount': amount});
          }

          if (amount > profileViewModel.balance) {
            if (kDebugMode) {
              print("Not enough wallet balance!");
            }
            return;
          }

          totalBetAmount += betValue;
          profileViewModel.deductBalance(betValue);
        } else {
          Utils.showImage(Assets.timer36PleaseSelectChips, context);
          if (kDebugMode) {
            print('Please select chips');
          }
        }
        notifyListeners();
      } else {
        resetOneByOne(id, context);
      }
    }
  }

  // clear all bets
  void clearAll(context) {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    profileViewModel
        .addBalance(bets.fold(0, (sum, element) => sum + element["amount"]!));
    bets.clear();
    totalBetAmount = 0;
    notifyListeners();
  }

  // clear one by one bets
  bool resetOne = false;
  void resetOneByOne(int number, context) {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    if (bets.where((bet) => bet['game_id'] == number).isNotEmpty) {
      var betToRemove = bets.firstWhere((bet) => bet['game_id'] == number);
      totalBetAmount -= betToRemove['amount']!;
      profileViewModel.addBalance(betToRemove['amount']!);
      bets.removeWhere((e) => e['game_id'] == number);
      notifyListeners();
    } else {
      Utils.showImage(Assets.timer36PleaseSelectChips, context);
      if (kDebugMode) {
        print('Please select chips');
      }
    }
  }

  // double bet amount
  void doubleAllBets(context) {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    int totalRequiredBalance = bets.fold(0, (sum, bet) => sum + bet['amount']!);
    if (totalRequiredBalance > profileViewModel.balance) {
      if (kDebugMode) {
        print("Not enough wallet balance to double all bets!");
      }
      return;
    }

    for (var bet in bets) {
      int currentAmount = bet['amount']!;
      int newAmount = currentAmount * 2;
      bet['amount'] = newAmount;
    }

    totalBetAmount += totalRequiredBalance;
    profileViewModel.deductBalance(totalRequiredBalance);
    notifyListeners();
  }

  List<int> showResult = [
    0,
    26,
    3,
    35,
    12,
    28,
    7,
    29,
    18,
    22,
    9,
    31,
    14,
    20,
    1,
    33,
    16,
    24,
    5,
    10,
    23,
    8,
    30,
    11,
    36,
    13,
    27,
    6,
    34,
    17,
    25,
    2,
    21,
    4,
    19,
    15,
    32
  ];

  List<CoinModel> coinList = [
    CoinModel(
      value: 2,
      viewValue: '2',
      image: Assets.timer36Two,
    ),
    CoinModel(value: 5, viewValue: '5', image: Assets.timer36Five),
    CoinModel(value: 10, viewValue: '10', image: Assets.timer36Ten),
    CoinModel(value: 50, viewValue: '50', image: Assets.timer36Fifty),
    CoinModel(value: 100, viewValue: '100', image: Assets.timer36OneH),
    CoinModel(value: 500, viewValue: '500', image: Assets.timer36FiveH),
    CoinModel(value: 1000, viewValue: '1k', image: Assets.timer36OneK),
    CoinModel(value: 3000, viewValue: '3k', image: Assets.timer36ThreeK),
  ];

  // timer api
  int _timerBetTime = 0;
  int _timerStatus = 0;

  int get timerBetTime => _timerBetTime;
  int get timerStatus => _timerStatus;

  void setData(int betTime, int status) {
    _timerBetTime = betTime;
    _timerStatus = status;
    notifyListeners();
  }

  bool betBool = false;
  bool resultBool = false;

  late IO.Socket _socket;
  Timer36BetViewModel timer36BetViewModel = Timer36BetViewModel();

  void connectToServer(context) async {
    _socket = IO.io(
      ApiUrl.timer36TimerEndPoint,
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
    _socket.on(ApiUrl.eventName, (timerData) {
      final receiveData = jsonDecode(timerData);
      setData(receiveData['timerBetTime'], receiveData['timerStatus']);

      if (receiveData['timerBetTime'] == 60 &&
          receiveData['timerStatus'] == 1) {
        indResult(false);
        isShowButtons(false);
        Utils.showImage(Assets.timer36PaceYourBets, context);
      }

      if (receiveData['timerBetTime'] == 30 &&
          receiveData['timerStatus'] == 1) {
        Utils.showImage(Assets.timer36LastCall, context);
      }
      if (receiveData['timerBetTime'] == 10 &&
          receiveData['timerStatus'] == 1) {
        isTenSecToResult(true);
        isHideValue(true);
        isShowButtons(true);
        betBool = false;
        Utils.showImage(Assets.timer36NoMoreBets, context);
      }
      if (receiveData['timerBetTime'] == 8 &&
          receiveData['timerStatus'] == 1&&betBool == false) {
        //add bet api
        if (bets.isNotEmpty) {
          timer36BetViewModel.timer36BetApi(bets, gamesNo, context);
        }
        betBool = true;
      }
      if (receiveData['timerBetTime'] == 1 &&
          receiveData['timerStatus'] == 1 ) {
        isTenSecToResult(false);
        resultBool = false;
        Future.delayed(const Duration(seconds: 1), () {
          notifyStart();
          notifyStarts();
        });
      }
      if (receiveData['timerBetTime'] == 8 &&
          receiveData['timerStatus'] == 2 &&
          resultBool == false) {
        final lastResultApi =
        Provider.of<Timer36LastResultViewModel>(context, listen: false);
        lastResultApi.timer36LastResultApi(1,context);
        resultBool = true;
        Future.delayed(const Duration(seconds: 7), () {
          totalBetAmount = 0;
          bets.clear();
          notifyListeners();
        });
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
}

class CoinModel {
  final int value;
  final String viewValue;
  final String image;
  CoinModel({
    required this.value,
    required this.viewValue,
    required this.image,
  });
}
