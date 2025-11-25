import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:super_star/generated/assets.dart';
import 'package:super_star/lucky_card_12/res/api_url.dart';
import 'package:super_star/lucky_card_12/view_model/lucky_12_bet_view_model.dart';
import 'package:super_star/lucky_card_12/view_model/lucky_12_result_view_model.dart';

import '../../spin_to_win/view_model/profile_view_model.dart';

class Lucky12Controller with ChangeNotifier {
  late void Function() lucky12StartWheel;
  late void Function(int index) lucky12StopWheel;

  void firstStart() {
    lucky12StartWheel();
    notifyListeners();
  }

  void firstStop(int index) {
    lucky12StopWheel(index);
    notifyListeners();
  }

  late void Function() lucky12secondStartWheel;
  late void Function(int index) lucky12secondStopWheel;

  void secondStart() {
    lucky12secondStartWheel();
    notifyListeners();
  }

  void secondStop(int index) {
    lucky12secondStopWheel(index);
    notifyListeners();
  }

  String _showMessage = '';
  String get showMessage => _showMessage;

  void setMessage(String value) {
    _showMessage = value;
    notifyListeners();
    Future.delayed(const Duration(seconds: 2), () {
      _showMessage = '';
      notifyListeners();
    });
  }

  bool isPlayAllowed() {
    if ((timerStatus == 1 && timerBetTime <= 10) || timerStatus == 2) {
      if (kDebugMode) {
        print('NO MORE PLAY');
      }
      setMessage('NO MORE PLAY');
      return false;
    }
    return true;
  }

  bool _resetOne = false;
  bool get resetOne => _resetOne;
  void setResetOne(bool val) {
    _resetOne = val;
    notifyListeners();
  }

  List<Map<String, int>> betHistory = [];

  void luckyAddBet(int id, int amount, int index, context) {
    if (!isPlayAllowed()) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);

    if (resetOne == false) {
      if (amount > profileViewModel.balance) {
        setMessage('INSUFFICIENT BALANCE');
        return;
      }

      bool betExists = false;
      for (var bet in addLucky12Bets) {
        if (bet['game_id'] == id) {
          bet['amount'] = (bet['amount'] ?? 0) + amount;
          betExists = true;
          break;
        }
      }

      if (!betExists) {
        addLucky12Bets.add({'game_id': id, 'amount': amount});
      }
      betHistory.add({'index': index, 'game_id': id, 'amount': amount});
      totalBetAmount += amount;
      profileViewModel.deductBalance(amount);
      notifyListeners();
    } else {
      resetOneByOne(context, index);
    }
  }

  void resetOneByOne(BuildContext context, int tappedIndex) {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);

    if (betHistory.isNotEmpty) {
      int betToRemoveIndex = -1;
      for (int i = betHistory.length - 1; i >= 0; i--) {
        if (betHistory[i]['index'] == tappedIndex) {
          betToRemoveIndex = i;
          break;
        }
      }

      if (betToRemoveIndex != -1) {
        var betToRemove = betHistory.removeAt(betToRemoveIndex);
        int gameId = betToRemove['game_id']!;
        int amount = betToRemove['amount']!;

        var existingBet = addLucky12Bets.firstWhere(
          (bet) => bet['game_id'] == gameId,
        );

        if (existingBet['amount']! > amount) {
          existingBet['amount'] = existingBet['amount']! - amount;
        } else {
          addLucky12Bets.removeWhere((bet) => bet['game_id'] == gameId);
        }

        totalBetAmount -= amount;
        profileViewModel.addBalance(amount);

        notifyListeners();
      }
    }
  }

  void clearAllBet(context) {
    if (!isPlayAllowed()) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    profileViewModel.addBalance(
        addLucky12Bets.fold(0, (sum, element) => sum + element["amount"]!));
    addLucky12Bets.clear();
    totalBetAmount = 0;
    betHistory.clear();
    tapedRowList.clear();
    tapedColumnList.clear();
    rowTrackHistory.clear();
    columnTrackHistory.clear();
    tapedRowTrack.clear();
    tapedColumnTrack.clear();
    notifyListeners();
  }

  void doubleAllBets(context) {
    if (!isPlayAllowed()) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    int totalRequiredBalance =
        addLucky12Bets.fold(0, (sum, bet) => sum + bet['amount']!);
    if (totalRequiredBalance > profileViewModel.balance) {
      setMessage('INSUFFICIENT BALANCE');
      return;
    }
    for (var bet in addLucky12Bets) {
      int currentAmount = bet['amount']!;
      int newAmount = currentAmount * 2;
      bet['amount'] = newAmount;
    }
    totalBetAmount += totalRequiredBalance;
    profileViewModel.deductBalance(totalRequiredBalance);
    notifyListeners();
  }

  void addRowBet(context, int rowIndex) {
    if (!isPlayAllowed()) return;
    if (resetOne == false) {
      final profileViewModel =
          Provider.of<ProfileViewModel>(context, listen: false);
      List<int> cardIds = [];
      switch (rowIndex) {
        case 0:
          cardIds = [1, 2, 3, 4];
          break;
        case 1:
          cardIds = [5, 6, 7, 8];
          break;
        case 2:
          cardIds = [9, 10, 11, 12];
          break;
      }

      int totalRequiredBalance = cardIds.length * selectedValue;

      if (totalRequiredBalance > profileViewModel.balance) {
        setMessage('INSUFFICIENT BALANCE');
        return;
      }

      for (var id in cardIds) {
        var existingBet = addLucky12Bets.firstWhere(
          (bet) => bet['game_id'] == id,
          orElse: () => <String, int>{},
        );

        if (existingBet.isNotEmpty) {
          existingBet['amount'] = (existingBet['amount'] ?? 0) + selectedValue;
        } else {
          addLucky12Bets.add({'game_id': id, 'amount': selectedValue});
        }
      }

      List<Map<String, int>> rowBet = cardIds
          .map((id) => {"cardIds": id, "amount": selectedValue})
          .toList();

      rowTrackHistory.add({"rowIndex": rowIndex, "rowBet": rowBet});

      totalBetAmount += totalRequiredBalance;
      profileViewModel.deductBalance(totalRequiredBalance);
      addRowBetList(rowIndex);
      notifyListeners();
    } else {
      removeRowBet(context, rowIndex);
    }
  }

  List<Map<String, dynamic>> rowTrackHistory = [];

  void removeRowBet(BuildContext context, int rowIndex) {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    int rowRemoveIndex = -1;
    for (int i = rowTrackHistory.length - 1; i >= 0; i--) {
      if (rowTrackHistory[i]['rowIndex'] == rowIndex) {
        rowRemoveIndex = i;
        break;
      }
    }

    if (rowRemoveIndex != -1) {
      var betToRemove = rowTrackHistory.removeAt(rowRemoveIndex);
      List<Map<String, int>> rowBet = betToRemove['rowBet'];

      for (var bet in rowBet) {
        int cardId = bet['cardIds']!;
        int amount = bet['amount']!;
        var existingBet = addLucky12Bets.firstWhere(
          (bet) => bet['game_id'] == cardId,
        );

        if (existingBet['amount']! > amount) {
          existingBet['amount'] = existingBet['amount']! - amount;
        } else {
          addLucky12Bets.removeWhere((bet) => bet['game_id'] == cardId);
        }

        totalBetAmount -= amount;
        profileViewModel.addBalance(amount);
      }
    }

    int trackRemoveIndex = -1;
    for (int i = tapedRowTrack.length - 1; i >= 0; i--) {
      if (tapedRowTrack[i]['index'] == rowIndex) {
        trackRemoveIndex = i;
        break;
      }
    }

    if (trackRemoveIndex != -1) {
      var betTrackToRemove = tapedRowTrack[trackRemoveIndex];

      final existIndex = tapedRowList.indexWhere((e) => e["index"] == rowIndex);
      if (existIndex != -1) {
        if (tapedRowList[existIndex]["amount"]! > betTrackToRemove["amount"]!) {
          tapedRowList[existIndex]["amount"] =
              tapedRowList[existIndex]["amount"]! - betTrackToRemove["amount"]!;
        } else {
          tapedRowList.removeAt(existIndex);
        }
      }

      tapedRowTrack.removeAt(trackRemoveIndex);
    }

    notifyListeners();
  }

  void addColumnBet(BuildContext context, int columnIndex) {
    if (!isPlayAllowed()) return;
    if (resetOne == false) {
      final profileViewModel =
          Provider.of<ProfileViewModel>(context, listen: false);
      List<int> cardIds = [];

      switch (columnIndex) {
        case 0:
          cardIds = [1, 5, 9];
          break;
        case 1:
          cardIds = [2, 6, 10];
          break;
        case 2:
          cardIds = [3, 7, 11];
          break;
        case 3:
          cardIds = [4, 8, 12];
          break;
      }

      int totalRequiredBalance = cardIds.length * selectedValue;

      if (totalRequiredBalance > profileViewModel.balance) {
        setMessage('INSUFFICIENT BALANCE');
        return;
      }

      for (var id in cardIds) {
        var existingBet = addLucky12Bets.firstWhere(
          (bet) => bet['game_id'] == id,
          orElse: () => <String, int>{},
        );

        if (existingBet.isNotEmpty) {
          existingBet['amount'] = (existingBet['amount'] ?? 0) + selectedValue;
        } else {
          addLucky12Bets.add({'game_id': id, 'amount': selectedValue});
        }
      }

      List<Map<String, int>> columnBet = cardIds
          .map((id) => {"cardIds": id, "amount": selectedValue})
          .toList();

      columnTrackHistory
          .add({"columnIndex": columnIndex, "columnBet": columnBet});

      totalBetAmount += totalRequiredBalance;
      profileViewModel.deductBalance(totalRequiredBalance);
      addColumnBetList(columnIndex);
      notifyListeners();
    } else {
      removeColumnBet(context, columnIndex);
    }
  }

  List<Map<String, dynamic>> columnTrackHistory = [];

  void removeColumnBet(context, int columnIndex) {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    int columnRemoveIndex = -1;
    for (int i = columnTrackHistory.length - 1; i >= 0; i--) {
      if (columnTrackHistory[i]['columnIndex'] == columnIndex) {
        columnRemoveIndex = i;
        break;
      }
    }

    if (columnRemoveIndex != -1) {
      var betToRemove = columnTrackHistory.removeAt(columnRemoveIndex);
      List<Map<String, int>> columnBet = betToRemove['columnBet'];

      for (var bet in columnBet) {
        int cardId = bet['cardIds']!;
        int amount = bet['amount']!;
        var existingBet = addLucky12Bets.firstWhere(
          (bet) => bet['game_id'] == cardId,
        );

        if (existingBet['amount']! > amount) {
          existingBet['amount'] = existingBet['amount']! - amount;
        } else {
          addLucky12Bets.removeWhere((bet) => bet['game_id'] == cardId);
        }

        totalBetAmount -= amount;
        profileViewModel.addBalance(amount);
      }
    }

    int trackRemoveIndex = -1;
    for (int i = tapedColumnTrack.length - 1; i >= 0; i--) {
      if (tapedColumnTrack[i]['index'] == columnIndex) {
        trackRemoveIndex = i;
        break;
      }
    }

    if (trackRemoveIndex != -1) {
      var betTrackToRemove = tapedColumnTrack[trackRemoveIndex];

      final existIndex =
          tapedColumnList.indexWhere((e) => e["index"] == columnIndex);
      if (existIndex != -1) {
        if (tapedColumnList[existIndex]["amount"]! >
            betTrackToRemove["amount"]!) {
          tapedColumnList[existIndex]["amount"] = tapedColumnList[existIndex]
                  ["amount"]! -
              betTrackToRemove["amount"]!;
        } else {
          tapedColumnList.removeAt(existIndex);
        }
      }

      tapedColumnTrack.removeAt(trackRemoveIndex);
    }

    notifyListeners();
  }

  List<Map<String, int>> addLucky12Bets = [];
  int _selectedIndex = 0;
  int _selectedValue = 5;
  int get selectedIndex => _selectedIndex;
  int get selectedValue => _selectedValue;

  void chipSelectIndex(int idx, int value) {
    _selectedIndex = idx;
    _selectedValue = value;
    notifyListeners();
  }

  int totalBetAmount = 0;

  List<LuckyCoinModel> coinList = [
    LuckyCoinModel(image: Assets.lucky16LC5, value: 5),
    LuckyCoinModel(image: Assets.lucky16LC10, value: 10),
    LuckyCoinModel(image: Assets.lucky16LC20, value: 20),
    LuckyCoinModel(image: Assets.lucky16LC50, value: 50),
    LuckyCoinModel(image: Assets.lucky16LC100, value: 100),
    LuckyCoinModel(image: Assets.lucky16LC500, value: 500),
  ];
  List<GridAllModel> cardList = [
    GridAllModel(image: Assets.lucky16HeartK, id: 1),
    GridAllModel(image: Assets.lucky16HukumK, id: 2),
    GridAllModel(image: Assets.lucky16EtaK, id: 3),
    GridAllModel(image: Assets.lucky16ChidiK, id: 4),
    GridAllModel(image: Assets.lucky16HeartQ, id: 5),
    GridAllModel(image: Assets.lucky16HukumQ, id: 6),
    GridAllModel(image: Assets.lucky16EtaQ, id: 7),
    GridAllModel(image: Assets.lucky16ChidiQ, id: 8),
    GridAllModel(image: Assets.lucky16HeartJ, id: 9),
    GridAllModel(image: Assets.lucky16HukumJ, id: 10),
    GridAllModel(image: Assets.lucky16EtaJ, id: 11),
    GridAllModel(image: Assets.lucky16ChidiJ, id: 12),
  ];

  // result match
  List<String> card = [
    Assets.lucky12Q,
    Assets.lucky12K,
    Assets.lucky12J,
  ];
  String getCardForIndex(int index) {
    return card[index];
  }

  List<String> color = [
    Assets.lucky12C,
    Assets.lucky12D,
    Assets.lucky12S,
    Assets.lucky12H,
  ];

  String getColorForIndex(int index) {
    return color[index];
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

  bool _resultShowTime = false;
  bool get resultShowTime => _resultShowTime;
  void setResultShowTime(bool val) {
    _resultShowTime = val;
    notifyListeners();
  }

  bool _showBettingTime = false;
  bool get showBettingTime => _showBettingTime;
  void setBettingTime(bool val) {
    _showBettingTime = val;
    notifyListeners();
  }

  bool betBool = false;
  late IO.Socket _socket;
  Lucky12BetViewModel lucky12BetViewModel = Lucky12BetViewModel();
  void connectToServer(context) async {
    _socket = IO.io(
      ApiUrl.timerLucky12Url,
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
      setData(receiveData['timerBetTime'], receiveData['timerStatus']);
      // bet on
      if (receiveData['timerStatus'] == 1 &&
          receiveData['timerBetTime'] == 90) {
        setMessage('PLACE YOUR CHIPS');
        setBettingTime(false);
      }
      // bet api
      if (receiveData['timerStatus'] == 1 &&
          receiveData['timerBetTime'] == 10) {
        setResultShowTime(true);
        setBettingTime(true);
        betBool = false;
        setMessage('NO MORE PLAY');
        if (addLucky12Bets.isNotEmpty && betBool == false) {
          lucky12BetViewModel.lucky12BetApi(addLucky12Bets, context);
          betBool = true;
        }
      }
      // start wheel
      if (receiveData['timerStatus'] == 2 &&
          receiveData['timerBetTime'] == 10) {
        firstStart();
        secondStart();
        addLucky12Bets.clear();
        totalBetAmount = 0;
        betHistory.clear();
        tapedRowList.clear();
        tapedColumnList.clear();
        rowTrackHistory.clear();
        columnTrackHistory.clear();
        tapedRowTrack.clear();
        tapedColumnTrack.clear();
      }
      // result api
      if (receiveData['timerStatus'] == 2 && receiveData['timerBetTime'] == 8) {
        final lucky12ResultViewModel =
            Provider.of<Lucky12ResultViewModel>(context, listen: false);
        lucky12ResultViewModel.lucky12ResultApi(context, 0);
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

  List<String> rowBetList = [
    Assets.lucky16GreenK,
    Assets.lucky16GreenQ,
    Assets.lucky16GreenJ,
  ];

  List<Map<String, int>> tapedRowList = [];
  List<Map<String, int>> tapedRowTrack = [];

  void addRowBetList(int index) {
    final existIndex = tapedRowList.indexWhere((e) => e["index"] == index);
    if (existIndex != -1) {
      tapedRowList[existIndex]["amount"] =
          tapedRowList[existIndex]["amount"]! + selectedValue;
    } else {
      tapedRowList.add({"index": index, "amount": selectedValue});
    }
    tapedRowTrack.add({"index": index, "amount": selectedValue});
    notifyListeners();
  }

  List<String> columnBetList = [
    Assets.lucky16LHeart,
    Assets.lucky16LShep,
    Assets.lucky16LDiamond,
    Assets.lucky16LClub,
  ];
  List<Map<String, int>> tapedColumnList = [];
  List<Map<String, int>> tapedColumnTrack = [];

  void addColumnBetList(int index) {
    final existIndex = tapedColumnList.indexWhere((e) => e["index"] == index);
    if (existIndex != -1) {
      tapedColumnList[existIndex]["amount"] =
          tapedColumnList[existIndex]["amount"]! + selectedValue;
    } else {
      tapedColumnList.add({"index": index, "amount": selectedValue});
    }
    tapedColumnTrack.add({"index": index, "amount": selectedValue});
    notifyListeners();
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

class LuckyCoinModel {
  final String image;
  final int value;

  LuckyCoinModel({
    required this.image,
    required this.value,
  });
}

class GridAllModel {
  final String image;
  final int id;

  GridAllModel({
    required this.image,
    required this.id,
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
