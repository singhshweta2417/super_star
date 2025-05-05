import 'dart:convert';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:super_star/spin_to_win/res/utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../generated/assets.dart';
import '../res/api_url.dart';
import '../view_model/profile_view_model.dart';
import '../view_model/spin_bet_view_model.dart';
import '../view_model/spin_result_view_model.dart';


class SpinController with ChangeNotifier {

  late void Function() spinStartWheel;
  late void Function(int index) spinStopWheel;

  void firstStart() {
    spinStartWheel();
    notifyListeners();
  }

  void firstStop(int index) {
    spinStopWheel(index);
    notifyListeners();
  }

  List<Map<String, int>> spinBets = [];
  List<Map<String, int>> repeatBets = [];


  bool _toastShown = false;
  bool _betTimeStartShown = false;

  bool isPlayAllowed(BuildContext context) {
    if ((timerStatus == 1 && timerBetTime <= 5) || timerStatus == 2) {
      if (!_toastShown) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          SpinUtils.showSpiToast('NO MORE PLAY', context);
        });
        _toastShown = true;
      }
      _betTimeStartShown = false;
      return false;
    }
    _toastShown = false;
    if (!_betTimeStartShown && timerStatus == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SpinUtils.showSpiToast('PLACE YOUR BETS', context);
      });
      _betTimeStartShown = true;
    }
    return true;
  }

  void spinRepeatBet(context) {
    if (!isPlayAllowed(context)) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    int totalRequiredBalance =
        repeatBets.fold(0, (sum, bet) => sum + bet['amount']!);

    if (totalRequiredBalance > profileViewModel.balance) {
      SpinUtils.showSpiToast('INSUFFICIENT BALANCE', context);
      return;
    }

    for (var data in repeatBets) {
      spinBets.add({'game_id': data['game_id']!, 'amount': data['amount']!});
    }
    repeatBets.clear();
    totalBetAmount += totalRequiredBalance;
    profileViewModel.deductBalance(totalRequiredBalance);
    notifyListeners();
  }

  void spinAddBet(int id, int amount, context) {
    if (!isPlayAllowed(context)) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    if (amount > profileViewModel.balance) {
      SpinUtils.showSpiToast('INSUFFICIENT BALANCE', context);
      return;
    }

    bool betExists = false;
    betExists = false;
    for (var bet in spinBets) {
      if (bet['game_id'] == id) {
        bet['amount'] = (bet['amount'] ?? 0) + amount;
        betExists = true;
        break;
      }
    }

    if (!betExists) {
      spinBets.add({'game_id': id, 'amount': amount});
    }
    totalBetAmount += selectedValue;
    profileViewModel.deductBalance(selectedValue);
    notifyListeners();
  }

  void clearAllBet(context) {
    if (!isPlayAllowed(context)) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    profileViewModel.addBalance(
        spinBets.fold(0, (sum, element) => sum + element["amount"]!));

    spinBets.clear();
    totalBetAmount = 0;

    notifyListeners();
  }

  void doubleAllBets(context) {
    if (!isPlayAllowed(context)) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    int totalRequiredBalance =
        spinBets.fold(0, (sum, bet) => sum + bet['amount']!);
    if (totalRequiredBalance > profileViewModel.balance) {
      SpinUtils.showSpiToast('INSUFFICIENT BALANCE', context);
      return;
    }
    for (var bet in spinBets) {
      int currentAmount = bet['amount']!;
      int newAmount = currentAmount * 2;
      bet['amount'] = newAmount;
    }
    totalBetAmount += totalRequiredBalance;
    profileViewModel.deductBalance(totalRequiredBalance);
    notifyListeners();
  }

  void oddBets(BuildContext context) {
    if (!isPlayAllowed(context)) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    int totalRequiredBalance =
        spinViewBetList.where((bet) => bet % 2 != 0).length * selectedValue;
    if (totalRequiredBalance > profileViewModel.balance) {
      SpinUtils.showSpiToast('INSUFFICIENT BALANCE', context);
      return;
    }
    for (var e in spinViewBetList) {
      if (e % 2 != 0) {
        var existingBet = spinBets.firstWhere(
          (bet) => bet['game_id'] == e,
          orElse: () => <String, int>{},
        );

        if (existingBet.isNotEmpty) {
          existingBet['amount'] = (existingBet['amount'] ?? 0) + selectedValue;
        } else {
          spinBets.add({'game_id': e, 'amount': selectedValue});
        }
      }
    }
    totalBetAmount += totalRequiredBalance;
    profileViewModel.deductBalance(totalRequiredBalance);
    notifyListeners();
  }

  void evenBets(BuildContext context) {
    if (!isPlayAllowed(context)) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    int totalRequiredBalance =
        spinViewBetList.where((bet) => bet % 2 == 0).length * selectedValue;
    if (totalRequiredBalance > profileViewModel.balance) {
      SpinUtils.showSpiToast('INSUFFICIENT BALANCE', context);
      return;
    }
    for (var e in spinViewBetList) {
      if (e % 2 == 0) {
        var existingBet = spinBets.firstWhere(
          (bet) => bet['game_id'] == e,
          orElse: () => <String, int>{},
        );

        if (existingBet.isNotEmpty) {
          existingBet['amount'] = (existingBet['amount'] ?? 0) + selectedValue;
        } else {
          spinBets.add({'game_id': e, 'amount': selectedValue});
        }
      }
    }
    totalBetAmount += totalRequiredBalance;
    profileViewModel.deductBalance(totalRequiredBalance);
    notifyListeners();
  }

  int _selectedIndex = 0;
  int _selectedValue = 5;
  int get selectedIndex => _selectedIndex;
  int get selectedValue => _selectedValue;

  bool _isDialogOpen = false;

  bool get isDialogOpen => _isDialogOpen;

  setIsDialogOpen(bool value) {
    _isDialogOpen = value;
    notifyListeners();
  }

  bool _isAnimationOpen = false;
  bool get isAnimationOpen => _isAnimationOpen;
  setIsAnimationOpen(bool value) {
    _isAnimationOpen = value;
    notifyListeners();
  }

  void selectIndex(int idx, int value) {
    _selectedIndex = idx;
    _selectedValue = value;
    notifyListeners();
  }

  int totalBetAmount = 0;

  List<CoinSpinWheel> coinSpinList = [
    CoinSpinWheel(
      image: Assets.spinSC5,
      value: 5,
    ),
    CoinSpinWheel(
      image: Assets.spinSC10,
      value: 10,
    ),
    CoinSpinWheel(
      image: Assets.spinSC50,
      value: 50,
    ),
    CoinSpinWheel(
      image: Assets.spinSC100,
      value: 100,
    ),
    CoinSpinWheel(
      image: Assets.spinSC500,
      value: 500,
    ),
  ];

  List<int> spinViewBetList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
  List<HistoryModel> resultList = [
    HistoryModel(color: const Color(0xffb4a104), value: 1),
    HistoryModel(color: const Color(0xff0467c2), value: 0),
    HistoryModel(color: const Color(0xffd67004), value: 9),
    HistoryModel(color: const Color(0xff300964), value: 8),
    HistoryModel(color: const Color(0xff098d9c), value: 7),
    HistoryModel(color: const Color(0xffdb6b07), value: 6),
    HistoryModel(color: const Color(0xffd80b06), value: 5),
    HistoryModel(color: const Color(0xff6c4f9f), value: 4),
    HistoryModel(color: const Color(0xffee0f6a), value: 3),
    HistoryModel(color: const Color(0xff32b939), value: 2),
  ];

  Color getColorForNumber(int number) {
    try {
      return resultList.firstWhere((result) => result.value == number).color;
    } catch (e) {
      return Colors.transparent; // Default color if no match found
    }
  }

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
  late IO.Socket _socket;
  SpinBetViewModel spinBetViewModel = SpinBetViewModel();
  void connectToServer(context) async {
    _socket = IO.io(
      SpinApiUrl.timerSpinUrl,
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
    _socket.on(SpinApiUrl.timerEvent, (timerData) {
      final receiveData = jsonDecode(timerData);
      setData(receiveData['timerBetTime'], receiveData['timerStatus']);
      // bet api
      if (receiveData['timerStatus'] == 1 && receiveData['timerBetTime'] == 5) {
        betBool = false;
        if (isDialogOpen) {
          setIsDialogOpen(false);
          Navigator.pop(context);
        }
        if (spinBets.isNotEmpty && betBool == false) {
          spinBetViewModel.spinBetApi(spinBets, context);
          betBool = true;
        }
      }
      // start wheel
      if (receiveData['timerStatus'] == 2 &&
          receiveData['timerBetTime'] == 15) {
        firstStart();
        spinBets.clear();
        totalBetAmount = 0;
      }
      // result api
      if (receiveData['timerStatus'] == 2 &&
          receiveData['timerBetTime'] == 13) {
        final spinResultViewModel =
            Provider.of<SpinResultViewModel>(context, listen: false);
        spinResultViewModel.spinResultApi(context, 0);
      }

      if (kDebugMode) {
        print('Time: ${receiveData['timerBetTime']}');
        print('Status: ${receiveData['timerStatus']}');
      }
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

  List<JackpotModel> jackpotList = [
    JackpotModel(img: Assets.jackpot2x, id: 2),
    JackpotModel(img: Assets.jackpot3x, id: 3),
    JackpotModel(img: Assets.jackpot4x, id: 4),
    JackpotModel(img: Assets.jackpot5x, id: 5),
    JackpotModel(img: Assets.jackpot6x, id: 6),
    JackpotModel(img: Assets.jackpot7x, id: 7),
    JackpotModel(img: Assets.jackpot8x, id: 8),
    JackpotModel(img: Assets.jackpot9x, id: 9),
    JackpotModel(img: Assets.jackpot10x, id: 10),
    JackpotModel(img: Assets.jackpot11x, id: 11),
    JackpotModel(img: Assets.jackpot12x, id: 12),
  ];

  String? getJackpotForIndex(int jackpot) {
    final jackpotModel = jackpotList.firstWhere(
          (e) => e.id == jackpot,
      orElse: () => JackpotModel(img: '', id: 1),
    );
    return jackpotModel.id == 1 ? null : jackpotModel.img;
  }


}

class HistoryModel {
  final Color color;
  final int value;

  HistoryModel({
    required this.color,
    required this.value,
  });
}

class CoinSpinWheel {
  final String image;
  final int value;
  CoinSpinWheel({
    required this.image,
    required this.value,
  });
}
class JackpotModel {
  final String img;
  final int id;

  JackpotModel({
    required this.img,
    required this.id,
  });
}