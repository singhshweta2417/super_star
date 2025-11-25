import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:super_star/generated/assets.dart';
import 'package:super_star/triple_chance/view_model/triple_chance_result_view_model.dart';
import '../../spin_to_win/view_model/profile_view_model.dart';
import '../../triple_chance/res/api_url.dart';
import 'package:super_star/triple_chance/view_model/triple_chance_bet_view_model.dart';

class TripleChanceController with ChangeNotifier {
  late IO.Socket _socket;
  int _timerBetTime = 0;
  int _timerStatus = 0;

  int get timerBetTime => _timerBetTime;
  int get timerStatus => _timerStatus;
  String _showMessage = '';
  String get showMessage => _showMessage;

  void setData(int betTime, int status) {
    _timerBetTime = betTime;
    _timerStatus = status;
    notifyListeners();
  }

  void setMessage(String value) {
    _showMessage = value;
    notifyListeners();
    Future.delayed(const Duration(seconds: 2), () {
      _showMessage = '';
      notifyListeners();
    });
  }

  bool _showBettingTime = false;
  bool get showBettingTime => _showBettingTime;
  void setBettingTime(bool val) {
    _showBettingTime = val;
    notifyListeners();
  }

  bool _resultShowTime = false;
  bool get resultShowTime => _resultShowTime;
  void setResultShowTime(bool val) {
    _resultShowTime = val;
    notifyListeners();
  }

  bool betBool = false;
  TripleChanceBetViewModel tripleChanceBetViewModel =
      TripleChanceBetViewModel();
  void connectToServer(context) async {
    _socket = IO.io(
      ApiUrlTriple.timerTripleChanceUrl,
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
    _socket.on(ApiUrlTriple.timerEvent, (timerData) {
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
        if (addTripleChanceBets.isNotEmpty && betBool == false) {
          tripleChanceBetViewModel.tripleChanceBetApi(
              addTripleChanceBets, context);
          betBool = true;
        }
      }
      // start wheel
      if (receiveData['timerStatus'] == 1 && receiveData['timerBetTime'] == 1) {
        firstStart();
        secondStart();
        thirdStart();
        // addTripleChanceBets.clear();
        // doubleTotalAmount=0;
        // tripleTotalAmount=0;
        // singleTotalAmount=0;
        // betHistory.clear();
        // tapedRowList.clear();
        // tapedColumnList.clear();
        // rowTrackHistory.clear();
        // columnTrackHistory.clear();
        // tapedRowTrack.clear();
        // tapedColumnTrack.clear();
      }
      // result api
      if (receiveData['timerStatus'] == 2 && receiveData['timerBetTime'] == 8) {
        final lucky12ResultViewModel =
            Provider.of<TripleChanceResultViewModel>(context, listen: false);
        lucky12ResultViewModel.tripleChanceResultApi(context, 0);
      }
      if (receiveData['timerStatus'] == 2 && receiveData['timerBetTime'] == 4) {
        addTripleChanceBets.clear();
        doubleTotalAmount = 0;
        tripleTotalAmount = 0;
        singleTotalAmount = 0;
        ranDoubleTrackList.clear();
        ranTripleTrackList.clear();
        doubleRowTrackList.clear();
        doubleColumnTrackList.clear();
        tripleRowTrackList.clear();
        tripleColumnTrackList.clear();
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

  late void Function() firstStartWheel;
  late void Function(int index) firstStopWheel;

  void firstStart() {
    firstStartWheel();
    notifyListeners();
  }

  void firstStop(int index) {
    firstStopWheel(index);
    notifyListeners();
  }

  late void Function() secondStartWheel;
  late void Function(int index) secondStopWheel;

  void secondStart() {
    secondStartWheel();
    notifyListeners();
  }

  void secondStop(int index) {
    secondStopWheel(index);
    notifyListeners();
  }

  late void Function() thirdStartWheel;
  late void Function(int index) thirdStopWheel;
  void thirdStart() {
    thirdStartWheel();
    notifyListeners();
  }

  void thirdStop(int index) {
    thirdStopWheel(index);
    notifyListeners();
  }

  int _selectRenDouble = -1;
  int get selectRenDouble => _selectRenDouble;

  void setRenD(int val) {
    _selectRenDouble = val;
    notifyListeners();
  }

  int _selectRenTriple = -1;
  int get selectRenTriple => _selectRenTriple;

  void setRenT(int val) {
    _selectRenTriple = val;
    notifyListeners();
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

  List<Map<String, dynamic>> addTripleChanceBets = [];
  int singleTotalAmount = 0;
  int doubleTotalAmount = 0;
  int tripleTotalAmount = 0;

  void singleAddBet(dynamic gameId, int amount, int wheelNo, context) {
    if (!isPlayAllowed()) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);

    if (resetOne) {
      removeOneByOne(gameId, wheelNo, context);
      return;
    }

    if (amount > profileViewModel.balance) {
      setMessage('INSUFFICIENT BALANCE');
      return;
    }

    final int betLimit = _getBetLimit(wheelNo);
    bool betExists = false;
    bool isLimitExceeded = false;

    for (var bet in addTripleChanceBets) {
      if (bet['game_id'] == gameId) {
        isLimitExceeded = _isBetLimitExceeded(bet, amount, betLimit);
        if (!isLimitExceeded) {
          bet['amount'] = (bet['amount'] ?? 0) + amount;
        }
        betExists = true;
        break;
      }
    }
    if (!betExists && !isLimitExceeded) {
      addTripleChanceBets.add({
        'game_id': gameId,
        'amount': amount,
        'wheel_no': wheelNo,
      });
    }
    if (!isLimitExceeded) {
      _increaseTotalAmount(wheelNo, amount);
      profileViewModel.deductBalance(amount);
      notifyListeners();
    }
  }

  int _getBetLimit(int wheelNo) {
    switch (wheelNo) {
      case 3:
        return 100;
      case 2:
        return 1000;
      case 1:
      default:
        return 10000;
    }
  }

  bool _isBetLimitExceeded(Map<String, dynamic> bet, int amount, int limit) {
    int currentAmount = bet['amount'] ?? 0;
    if (currentAmount + amount > limit) {
      if (kDebugMode) {
        print("Can't place bet > $limit");
      }
      return true;
    }
    return false;
  }

  void _increaseTotalAmount(int wheelNo, int amount) {
    switch (wheelNo) {
      case 3:
        tripleTotalAmount += amount;
        break;
      case 2:
        doubleTotalAmount += amount;
        break;
      case 1:
        singleTotalAmount += amount;
        break;
    }
  }

  bool _resetOne = false;
  bool get resetOne => _resetOne;
  void setResetOne(bool val) {
    _resetOne = val;
    notifyListeners();
  }

  void removeOneByOne(dynamic gameId, int wheelNo, context) {
    if (!isPlayAllowed()) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    if (addTripleChanceBets
        .where((bet) => bet['game_id'] == gameId)
        .isNotEmpty) {
      var betToRemove =
          addTripleChanceBets.firstWhere((bet) => bet['game_id'] == gameId);
      _decreaseTotalAmount(wheelNo, betToRemove['amount']);
      profileViewModel.addBalance(betToRemove['amount']);
      addTripleChanceBets.removeWhere((e) => e['game_id'] == gameId);
      if (ranDoubleTrackList.isNotEmpty) {
        ranDoubleTrackList.removeWhere((bet) => bet['game_id'] == gameId);
      }
      if (ranTripleTrackList.isNotEmpty) {
        ranTripleTrackList.removeWhere((bet) => bet['game_id'] == gameId);
      }
      notifyListeners();
    }
  }

  void _decreaseTotalAmount(int wheelNo, int amount) {
    switch (wheelNo) {
      case 3:
        tripleTotalAmount -= amount;
        break;
      case 2:
        doubleTotalAmount -= amount;
        break;
      case 1:
        singleTotalAmount -= amount;
        break;
    }
  }

  // clear all
  void clearAllBet(context) {
    if (!isPlayAllowed()) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    profileViewModel.addBalance(addTripleChanceBets.fold(
        0, (sum, element) => (sum + element["amount"]! as int)));
    addTripleChanceBets.clear();
    singleTotalAmount = 0;
    doubleTotalAmount = 0;
    tripleTotalAmount = 0;
    ranDoubleTrackList.clear();
    ranTripleTrackList.clear();
    notifyListeners();
  }

  void doubleAllBets(context) {
    if (!isPlayAllowed()) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    int totalRequiredBalance = addTripleChanceBets.fold(
        0, (sum, bet) => sum + (bet['amount']! as int) * 2);

    if (totalRequiredBalance > profileViewModel.balance) {
      setMessage('INSUFFICIENT BALANCE');
      return;
    }

    for (var bet in addTripleChanceBets) {
      int currentAmount = bet['amount']!;
      int newAmount = currentAmount * 2;
      final int betLimit = _getBetLimit(bet['wheel_no']!);

      if (_isBetLimitExceeded(bet, newAmount, betLimit)) {
        if (kDebugMode) {
          print(
              "Bet limit exceeded for game id ${bet['game id']}, can't double");
        }
        continue;
      }
      bet['amount'] = newAmount;
      int increaseAmount = newAmount - currentAmount;
      _increaseTotalAmount(bet['wheel_no']!, increaseAmount);
    }
    profileViewModel.deductBalance(totalRequiredBalance);
    notifyListeners();
  }

  // double Row add Bets
  void doubleRowAddBets(int rowIndex, int amount, int wheelNo, context) {
    if (!isPlayAllowed()) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);

    if (_resetOne) {
      doubleRowRemoveBets(context, rowIndex);
      return;
    }

    List<dynamic> betsIds = _getBetsIdsForRow(rowIndex);

    if (betsIds.isEmpty) return;

    int totalRequiredBalance = betsIds.length * amount;

    if (totalRequiredBalance > profileViewModel.balance) {
      setMessage('INSUFFICIENT BALANCE');
      return;
    }

    final int betLimit = _getBetLimit(wheelNo);
    bool isLimitExceeded = false;

    for (var gameId in betsIds) {
      var existingBet = addTripleChanceBets.firstWhere(
        (bet) => bet['game_id'] == gameId,
        orElse: () => <String, int>{},
      );

      isLimitExceeded = _isBetLimitExceeded(existingBet, amount, betLimit);

      if (isLimitExceeded) {
        if (kDebugMode) {
          print("Bet limit exceeded for game_id: $gameId. Bet canceled.");
        }
        return;
      }
    }

    for (var gameId in betsIds) {
      var existingBet = addTripleChanceBets.firstWhere(
        (bet) => bet['game_id'] == gameId,
        orElse: () => <String, int>{},
      );
      if (existingBet.isNotEmpty) {
        existingBet['amount'] = (existingBet['amount'] ?? 0) + amount;
      } else {
        addTripleChanceBets
            .add({'game_id': gameId, 'amount': amount, 'wheel_no': wheelNo});
      }
    }

    List<Map<String, dynamic>> rowBetsIds =
        betsIds.map((id) => {"cardIds": id, "amount": selectedValue}).toList();

    doubleRowTrackList.add({"rowIndex": rowIndex, "rowBet": rowBetsIds});

    doubleTotalAmount += totalRequiredBalance;
    profileViewModel.deductBalance(totalRequiredBalance);
    notifyListeners();
  }

  List<dynamic> _getBetsIdsForRow(int rowIndex) {
    switch (rowIndex) {
      case 0:
        return ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09'];
      case 1:
        return ['10', '11', '12', '13', '14', '15', '16', '17', '18', '19'];
      case 2:
        return ['20', '21', '22', '23', '24', '25', '26', '27', '28', '29'];
      case 3:
        return ['30', '31', '32', '33', '34', '35', '36', '37', '38', '39'];
      case 4:
        return ['40', '41', '42', '43', '44', '45', '46', '47', '48', '49'];
      case 5:
        return ['50', '51', '52', '53', '54', '55', '56', '57', '58', '59'];
      case 6:
        return ['60', '61', '62', '63', '64', '65', '66', '67', '68', '69'];
      case 7:
        return ['70', '71', '72', '73', '74', '75', '76', '77', '78', '79'];
      case 8:
        return ['80', '81', '82', '83', '84', '85', '86', '87', '88', '89'];
      case 9:
        return ['90', '91', '92', '93', '94', '95', '96', '97', '98', '99'];
      default:
        return [];
    }
  }

  // double Row remove Bets
  List<Map<String, dynamic>> doubleRowTrackList = [];
  void doubleRowRemoveBets(BuildContext context, int rowIndex) {
    if (!isPlayAllowed()) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    int rowRemoveIndex = -1;
    for (int i = doubleRowTrackList.length - 1; i >= 0; i--) {
      if (doubleRowTrackList[i]['rowIndex'] == rowIndex) {
        rowRemoveIndex = i;
        break;
      }
    }
    if (rowRemoveIndex != -1) {
      var betToRemove = doubleRowTrackList.removeAt(rowRemoveIndex);
      List<Map<String, dynamic>> rowBet = betToRemove['rowBet'];
      for (var bet in rowBet) {
        String cardId = bet['cardIds'];
        int amount = bet['amount'];

        var existingBet = addTripleChanceBets.firstWhere(
          (bet) => bet['game_id'] == cardId,
        );

        if (existingBet.isNotEmpty) {
          if (existingBet['amount'] > amount) {
            existingBet['amount'] -= amount;
          } else {
            addTripleChanceBets.removeWhere((bet) => bet['game_id'] == cardId);
          }

          doubleTotalAmount -= amount;
          profileViewModel.addBalance(amount);
        } else {
          if (kDebugMode) {
            print("Bet not found for cardId: $cardId");
          }
        }
      }
    } else {
      if (kDebugMode) {
        print("Row not found for rowIndex: $rowIndex");
      }
    }

    notifyListeners();
  }

  // double Column add Bets
  void doubleColumnAddBets(int columnIndex, int amount, int wheelNo, context) {
    if (!isPlayAllowed()) return;

    if (_resetOne) {
      doubleColumnRemoveBets(context, columnIndex);
      return;
    }

    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    List<dynamic> betsIds = _getBetsIdsForColumn(columnIndex);

    if (betsIds.isEmpty) return;

    int totalRequiredBalance = betsIds.length * amount;

    if (totalRequiredBalance > profileViewModel.balance) {
      setMessage('INSUFFICIENT BALANCE');
      return;
    }

    final int betLimit = _getBetLimit(wheelNo);
    bool isLimitExceeded = false;

    for (var gameId in betsIds) {
      var existingBet = addTripleChanceBets.firstWhere(
        (bet) => bet['game_id'] == gameId,
        orElse: () => <String, int>{},
      );

      isLimitExceeded = _isBetLimitExceeded(existingBet, amount, betLimit);

      if (isLimitExceeded) {
        if (kDebugMode) {
          print("Bet limit exceeded for game_id: $gameId. Bet canceled.");
        }
        return;
      }
    }

    for (var gameId in betsIds) {
      var existingBet = addTripleChanceBets.firstWhere(
        (bet) => bet['game_id'] == gameId,
        orElse: () => <String, int>{},
      );
      if (existingBet.isNotEmpty) {
        existingBet['amount'] = (existingBet['amount'] ?? 0) + amount;
      } else {
        addTripleChanceBets
            .add({'game_id': gameId, 'amount': amount, 'wheel_no': wheelNo});
      }
    }

    List<Map<String, dynamic>> colBetsIds =
        betsIds.map((id) => {"cardIds": id, "amount": amount}).toList();

    doubleColumnTrackList
        .add({"columnIndex": columnIndex, "columnBet": colBetsIds});
    doubleTotalAmount += totalRequiredBalance;
    profileViewModel.deductBalance(totalRequiredBalance);
    notifyListeners();
  }

  List<dynamic> _getBetsIdsForColumn(int columnIndex) {
    switch (columnIndex) {
      case 0:
        return ['00', '10', '20', '30', '40', '50', '60', '70', '80', '90'];
      case 1:
        return ['01', '11', '21', '31', '41', '51', '61', '71', '81', '91'];
      case 2:
        return ['02', '12', '22', '32', '42', '52', '62', '72', '82', '92'];
      case 3:
        return ['03', '13', '23', '33', '43', '53', '63', '73', '83', '93'];
      case 4:
        return ['04', '14', '24', '34', '44', '54', '64', '74', '84', '94'];
      case 5:
        return ['05', '15', '25', '35', '45', '55', '65', '75', '85', '95'];
      case 6:
        return ['06', '16', '26', '36', '46', '56', '66', '76', '86', '96'];
      case 7:
        return ['07', '17', '27', '37', '47', '57', '67', '77', '87', '97'];
      case 8:
        return ['08', '18', '28', '38', '48', '58', '68', '78', '88', '98'];
      case 9:
        return ['09', '19', '29', '39', '49', '59', '69', '79', '89', '99'];
      default:
        return [];
    }
  }

  // double Column remove Bets
  List<Map<String, dynamic>> doubleColumnTrackList = [];
  void doubleColumnRemoveBets(BuildContext context, int columnIndex) {
    if (!isPlayAllowed()) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    int columnRemoveIndex = -1;

    for (int i = doubleColumnTrackList.length - 1; i >= 0; i--) {
      if (doubleColumnTrackList[i]['columnIndex'] == columnIndex) {
        columnRemoveIndex = i;
        break;
      }
    }

    if (columnRemoveIndex != -1) {
      var betToRemove = doubleColumnTrackList.removeAt(columnRemoveIndex);
      List<Map<String, dynamic>> columnBet = betToRemove['columnBet'];

      for (var bet in columnBet) {
        String cardId = bet['cardIds'];
        int amount = bet['amount'];

        var existingBet = addTripleChanceBets.firstWhere(
          (bet) => bet['game_id'] == cardId,
        );

        if (existingBet.isNotEmpty) {
          if (existingBet['amount'] > amount) {
            existingBet['amount'] -= amount;
          } else {
            addTripleChanceBets.removeWhere((bet) => bet['game_id'] == cardId);
          }

          doubleTotalAmount -= amount;
          profileViewModel.addBalance(amount);
        } else {
          if (kDebugMode) {
            print("Bet not found for cardId: $cardId");
          }
        }
      }
    } else {
      if (kDebugMode) {
        print("Column not found for columnIndex: $columnIndex");
      }
    }

    notifyListeners();
  }

  // triple Row add Bets
  void tripleRowAddBets(
      int rowIndex, int amount, int wheelNo, dynamic catId, context) {
    if (!isPlayAllowed()) return;
    if (_resetOne) {
      tripleRowRemoveBets(context, rowIndex);
      return;
    }
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    List<dynamic> betsIds = _getBetsIdsForRowTriple(rowIndex, catId);

    if (betsIds.isEmpty) return;

    int totalRequiredBalance = betsIds.length * amount;

    if (totalRequiredBalance > profileViewModel.balance) {
      setMessage('INSUFFICIENT BALANCE');
      return;
    }

    final int betLimit = _getBetLimit(wheelNo);
    bool isLimitExceeded = false;

    // Check and update existing bets
    for (var gameId in betsIds) {
      var existingBet = addTripleChanceBets.firstWhere(
        (bet) => bet['game_id'] == gameId && bet['cat_id'] == catId,
        orElse: () => <String, int>{},
      );

      isLimitExceeded = _isBetLimitExceeded(existingBet, amount, betLimit);

      if (isLimitExceeded) {
        if (kDebugMode) {
          print("Bet limit exceeded for game_id: $gameId. Bet canceled.");
        }
        return;
      }

      if (existingBet.isNotEmpty) {
        existingBet['amount'] = (existingBet['amount'] ?? 0) + amount;
      } else {
        addTripleChanceBets.add({
          'game_id': gameId,
          'amount': amount,
          'wheel_no': wheelNo,
          'cat_id': catId
        });
      }
    }
    List<Map<String, dynamic>> rowBet = [];
    for (var gameId in betsIds) {
      rowBet.add({'cardIds': gameId, 'amount': amount});
    }

    tripleRowTrackList.add({"rowIndex": rowIndex, "rowBet": rowBet});

    tripleTotalAmount += totalRequiredBalance;
    profileViewModel.deductBalance(totalRequiredBalance);
    notifyListeners();
  }

  List<dynamic> _getBetsIdsForRowTriple(int rowIndex, String catId) {
    const Map<String, List<String>> catIdCase0 = {
      "000": [
        '000',
        '001',
        '002',
        '003',
        '004',
        '005',
        '006',
        '007',
        '008',
        '009'
      ],
      "100": [
        '100',
        '101',
        '102',
        '103',
        '104',
        '105',
        '106',
        '107',
        '108',
        '109'
      ],
      "200": [
        '200',
        '201',
        '202',
        '203',
        '204',
        '205',
        '206',
        '207',
        '208',
        '209'
      ],
      "300": [
        '300',
        '301',
        '302',
        '303',
        '304',
        '305',
        '306',
        '307',
        '308',
        '309'
      ],
      "400": [
        '400',
        '401',
        '402',
        '403',
        '404',
        '405',
        '406',
        '407',
        '408',
        '409'
      ],
      "500": [
        '500',
        '501',
        '502',
        '503',
        '504',
        '505',
        '506',
        '507',
        '508',
        '509'
      ],
      "600": [
        '600',
        '601',
        '602',
        '603',
        '604',
        '605',
        '606',
        '607',
        '608',
        '609'
      ],
      "700": [
        '700',
        '701',
        '702',
        '703',
        '704',
        '705',
        '706',
        '707',
        '708',
        '709'
      ],
      "800": [
        '800',
        '801',
        '802',
        '803',
        '804',
        '805',
        '806',
        '807',
        '808',
        '809'
      ],
      "900": [
        '900',
        '901',
        '902',
        '903',
        '904',
        '905',
        '906',
        '907',
        '908',
        '909'
      ]
    };

    const Map<String, List<String>> catIdCase1 = {
      "000": [
        '010',
        '011',
        '012',
        '013',
        '014',
        '015',
        '016',
        '017',
        '018',
        '019'
      ],
      "100": [
        '110',
        '111',
        '112',
        '113',
        '114',
        '115',
        '116',
        '117',
        '118',
        '119'
      ],
      "200": [
        '210',
        '211',
        '212',
        '213',
        '214',
        '215',
        '216',
        '217',
        '218',
        '219'
      ],
      "300": [
        '310',
        '311',
        '312',
        '313',
        '314',
        '315',
        '316',
        '317',
        '318',
        '319'
      ],
      "400": [
        '410',
        '411',
        '412',
        '413',
        '414',
        '415',
        '416',
        '417',
        '418',
        '419'
      ],
      "500": [
        '510',
        '511',
        '512',
        '513',
        '514',
        '515',
        '516',
        '517',
        '518',
        '519'
      ],
      "600": [
        '610',
        '611',
        '612',
        '613',
        '614',
        '615',
        '616',
        '617',
        '618',
        '619'
      ],
      "700": [
        '710',
        '711',
        '712',
        '713',
        '714',
        '715',
        '716',
        '717',
        '718',
        '719'
      ],
      "800": [
        '810',
        '811',
        '812',
        '813',
        '814',
        '815',
        '816',
        '817',
        '818',
        '819'
      ],
      "900": [
        '910',
        '911',
        '912',
        '913',
        '914',
        '915',
        '916',
        '917',
        '918',
        '919'
      ]
    };

    const Map<String, List<String>> catIdCase2 = {
      "000": [
        '020',
        '021',
        '022',
        '023',
        '024',
        '025',
        '026',
        '027',
        '028',
        '029'
      ],
      "100": [
        '120',
        '121',
        '122',
        '123',
        '124',
        '125',
        '126',
        '127',
        '128',
        '129'
      ],
      "200": [
        '220',
        '221',
        '222',
        '223',
        '224',
        '225',
        '226',
        '227',
        '228',
        '229'
      ],
      "300": [
        '320',
        '321',
        '322',
        '323',
        '324',
        '325',
        '326',
        '327',
        '328',
        '329'
      ],
      "400": [
        '420',
        '421',
        '422',
        '423',
        '424',
        '425',
        '426',
        '427',
        '428',
        '429'
      ],
      "500": [
        '520',
        '521',
        '522',
        '523',
        '524',
        '525',
        '526',
        '527',
        '528',
        '529'
      ],
      "600": [
        '620',
        '621',
        '622',
        '623',
        '624',
        '625',
        '626',
        '627',
        '628',
        '629'
      ],
      "700": [
        '720',
        '721',
        '722',
        '723',
        '724',
        '725',
        '726',
        '727',
        '728',
        '729'
      ],
      "800": [
        '820',
        '821',
        '822',
        '823',
        '824',
        '825',
        '826',
        '827',
        '828',
        '829'
      ],
      "900": [
        '920',
        '921',
        '922',
        '923',
        '924',
        '925',
        '926',
        '927',
        '928',
        '929'
      ]
    };

    const Map<String, List<String>> catIdCase3 = {
      "000": [
        '030',
        '031',
        '032',
        '033',
        '034',
        '035',
        '036',
        '037',
        '038',
        '039'
      ],
      "100": [
        '130',
        '131',
        '132',
        '133',
        '134',
        '135',
        '136',
        '137',
        '138',
        '139'
      ],
      "200": [
        '230',
        '231',
        '232',
        '233',
        '234',
        '235',
        '236',
        '237',
        '238',
        '239'
      ],
      "300": [
        '330',
        '331',
        '332',
        '333',
        '334',
        '335',
        '336',
        '337',
        '338',
        '339'
      ],
      "400": [
        '430',
        '431',
        '432',
        '433',
        '434',
        '435',
        '436',
        '437',
        '438',
        '439'
      ],
      "500": [
        '530',
        '531',
        '532',
        '533',
        '534',
        '535',
        '536',
        '537',
        '538',
        '539'
      ],
      "600": [
        '630',
        '631',
        '632',
        '633',
        '634',
        '635',
        '636',
        '637',
        '638',
        '639'
      ],
      "700": [
        '730',
        '731',
        '732',
        '733',
        '734',
        '735',
        '736',
        '737',
        '738',
        '739'
      ],
      "800": [
        '830',
        '831',
        '832',
        '833',
        '834',
        '835',
        '836',
        '837',
        '838',
        '839'
      ],
      "900": [
        '930',
        '931',
        '932',
        '933',
        '934',
        '935',
        '936',
        '937',
        '938',
        '939'
      ]
    };

    const Map<String, List<String>> catIdCase4 = {
      "000": [
        '040',
        '041',
        '042',
        '043',
        '044',
        '045',
        '046',
        '047',
        '048',
        '049'
      ],
      "100": [
        '140',
        '141',
        '142',
        '143',
        '144',
        '145',
        '146',
        '147',
        '148',
        '149'
      ],
      "200": [
        '240',
        '241',
        '242',
        '243',
        '244',
        '245',
        '246',
        '247',
        '248',
        '249'
      ],
      "300": [
        '340',
        '341',
        '342',
        '343',
        '344',
        '345',
        '346',
        '347',
        '348',
        '349'
      ],
      "400": [
        '440',
        '441',
        '442',
        '443',
        '444',
        '445',
        '446',
        '447',
        '448',
        '449'
      ],
      "500": [
        '540',
        '541',
        '542',
        '543',
        '544',
        '545',
        '546',
        '547',
        '548',
        '549'
      ],
      "600": [
        '640',
        '641',
        '642',
        '643',
        '644',
        '645',
        '646',
        '647',
        '648',
        '649'
      ],
      "700": [
        '740',
        '741',
        '742',
        '743',
        '744',
        '745',
        '746',
        '747',
        '748',
        '749'
      ],
      "800": [
        '840',
        '841',
        '842',
        '843',
        '844',
        '845',
        '846',
        '847',
        '848',
        '849'
      ],
      "900": [
        '940',
        '941',
        '942',
        '943',
        '944',
        '945',
        '946',
        '947',
        '948',
        '949'
      ]
    };

    const Map<String, List<String>> catIdCase5 = {
      "000": [
        '050',
        '051',
        '052',
        '053',
        '054',
        '055',
        '056',
        '057',
        '058',
        '059'
      ],
      "100": [
        '150',
        '151',
        '152',
        '153',
        '154',
        '155',
        '156',
        '157',
        '158',
        '159'
      ],
      "200": [
        '250',
        '251',
        '252',
        '253',
        '254',
        '255',
        '256',
        '257',
        '258',
        '259'
      ],
      "300": [
        '350',
        '351',
        '352',
        '353',
        '354',
        '355',
        '356',
        '357',
        '358',
        '359'
      ],
      "400": [
        '450',
        '451',
        '452',
        '453',
        '454',
        '455',
        '456',
        '457',
        '458',
        '459'
      ],
      "500": [
        '550',
        '551',
        '552',
        '553',
        '554',
        '555',
        '556',
        '557',
        '558',
        '559'
      ],
      "600": [
        '650',
        '651',
        '652',
        '653',
        '654',
        '655',
        '656',
        '657',
        '658',
        '659'
      ],
      "700": [
        '750',
        '751',
        '752',
        '753',
        '754',
        '755',
        '756',
        '757',
        '758',
        '759'
      ],
      "800": [
        '850',
        '851',
        '852',
        '853',
        '854',
        '855',
        '856',
        '857',
        '858',
        '859'
      ],
      "900": [
        '950',
        '951',
        '952',
        '953',
        '954',
        '955',
        '956',
        '957',
        '958',
        '959'
      ]
    };

    const Map<String, List<String>> catIdCase6 = {
      "000": [
        '060',
        '061',
        '062',
        '063',
        '064',
        '065',
        '066',
        '067',
        '068',
        '069'
      ],
      "100": [
        '160',
        '161',
        '162',
        '163',
        '164',
        '165',
        '166',
        '167',
        '168',
        '169'
      ],
      "200": [
        '260',
        '261',
        '262',
        '263',
        '264',
        '265',
        '266',
        '267',
        '268',
        '269'
      ],
      "300": [
        '360',
        '361',
        '362',
        '363',
        '364',
        '365',
        '366',
        '367',
        '368',
        '369'
      ],
      "400": [
        '460',
        '461',
        '462',
        '463',
        '464',
        '465',
        '466',
        '467',
        '468',
        '469'
      ],
      "500": [
        '560',
        '561',
        '562',
        '563',
        '564',
        '565',
        '566',
        '567',
        '568',
        '569'
      ],
      "600": [
        '660',
        '661',
        '662',
        '663',
        '664',
        '665',
        '666',
        '667',
        '668',
        '669'
      ],
      "700": [
        '760',
        '761',
        '762',
        '763',
        '764',
        '765',
        '766',
        '767',
        '768',
        '769'
      ],
      "800": [
        '860',
        '861',
        '862',
        '863',
        '864',
        '865',
        '866',
        '867',
        '868',
        '869'
      ],
      "900": [
        '960',
        '961',
        '962',
        '963',
        '964',
        '965',
        '966',
        '967',
        '968',
        '969'
      ]
    };

    const Map<String, List<String>> catIdCase7 = {
      "000": [
        '070',
        '071',
        '072',
        '073',
        '074',
        '075',
        '076',
        '077',
        '078',
        '079'
      ],
      "100": [
        '170',
        '171',
        '172',
        '173',
        '174',
        '175',
        '176',
        '177',
        '178',
        '179'
      ],
      "200": [
        '270',
        '271',
        '272',
        '273',
        '274',
        '275',
        '276',
        '277',
        '278',
        '279'
      ],
      "300": [
        '370',
        '371',
        '372',
        '373',
        '374',
        '375',
        '376',
        '377',
        '378',
        '379'
      ],
      "400": [
        '470',
        '471',
        '472',
        '473',
        '474',
        '475',
        '476',
        '477',
        '478',
        '479'
      ],
      "500": [
        '570',
        '571',
        '572',
        '573',
        '574',
        '575',
        '576',
        '577',
        '578',
        '579'
      ],
      "600": [
        '670',
        '671',
        '672',
        '673',
        '674',
        '675',
        '676',
        '677',
        '678',
        '679'
      ],
      "700": [
        '770',
        '771',
        '772',
        '773',
        '774',
        '775',
        '776',
        '777',
        '778',
        '779'
      ],
      "800": [
        '870',
        '871',
        '872',
        '873',
        '874',
        '875',
        '876',
        '877',
        '878',
        '879'
      ],
      "900": [
        '970',
        '971',
        '972',
        '973',
        '974',
        '975',
        '976',
        '977',
        '978',
        '979'
      ]
    };

    const Map<String, List<String>> catIdCase8 = {
      "000": [
        '080',
        '081',
        '082',
        '083',
        '084',
        '085',
        '086',
        '087',
        '088',
        '089'
      ],
      "100": [
        '180',
        '181',
        '182',
        '183',
        '184',
        '185',
        '186',
        '187',
        '188',
        '189'
      ],
      "200": [
        '280',
        '281',
        '282',
        '283',
        '284',
        '285',
        '286',
        '287',
        '288',
        '289'
      ],
      "300": [
        '380',
        '381',
        '382',
        '383',
        '384',
        '385',
        '386',
        '387',
        '388',
        '389'
      ],
      "400": [
        '480',
        '481',
        '482',
        '483',
        '484',
        '485',
        '486',
        '487',
        '488',
        '489'
      ],
      "500": [
        '580',
        '581',
        '582',
        '583',
        '584',
        '585',
        '586',
        '587',
        '588',
        '589'
      ],
      "600": [
        '680',
        '681',
        '682',
        '683',
        '684',
        '685',
        '686',
        '687',
        '688',
        '689'
      ],
      "700": [
        '780',
        '781',
        '782',
        '783',
        '784',
        '785',
        '786',
        '787',
        '788',
        '789'
      ],
      "800": [
        '880',
        '881',
        '882',
        '883',
        '884',
        '885',
        '886',
        '887',
        '888',
        '889'
      ],
      "900": [
        '980',
        '981',
        '982',
        '983',
        '984',
        '985',
        '986',
        '987',
        '988',
        '989'
      ]
    };

    const Map<String, List<String>> catIdCase9 = {
      "000": [
        '090',
        '091',
        '092',
        '093',
        '094',
        '095',
        '096',
        '097',
        '098',
        '099'
      ],
      "100": [
        '190',
        '191',
        '192',
        '193',
        '194',
        '195',
        '196',
        '197',
        '198',
        '199'
      ],
      "200": [
        '290',
        '291',
        '292',
        '293',
        '294',
        '295',
        '296',
        '297',
        '298',
        '299'
      ],
      "300": [
        '390',
        '391',
        '392',
        '393',
        '394',
        '395',
        '396',
        '397',
        '398',
        '399'
      ],
      "400": [
        '490',
        '491',
        '492',
        '493',
        '494',
        '495',
        '496',
        '497',
        '498',
        '499'
      ],
      "500": [
        '590',
        '591',
        '592',
        '593',
        '594',
        '595',
        '596',
        '597',
        '598',
        '599'
      ],
      "600": [
        '690',
        '691',
        '692',
        '693',
        '694',
        '695',
        '696',
        '697',
        '698',
        '699'
      ],
      "700": [
        '790',
        '791',
        '792',
        '793',
        '794',
        '795',
        '796',
        '797',
        '798',
        '799'
      ],
      "800": [
        '890',
        '891',
        '892',
        '893',
        '894',
        '895',
        '896',
        '897',
        '898',
        '899'
      ],
      "900": [
        '990',
        '991',
        '992',
        '993',
        '994',
        '995',
        '996',
        '997',
        '998',
        '999'
      ]
    };

    switch (rowIndex) {
      case 0:
        return catIdCase0[catId] ?? [];
      case 1:
        return catIdCase1[catId] ?? [];
      case 2:
        return catIdCase2[catId] ?? [];
      case 3:
        return catIdCase3[catId] ?? [];
      case 4:
        return catIdCase4[catId] ?? [];
      case 5:
        return catIdCase5[catId] ?? [];
      case 6:
        return catIdCase6[catId] ?? [];
      case 7:
        return catIdCase7[catId] ?? [];
      case 8:
        return catIdCase8[catId] ?? [];
      case 9:
        return catIdCase9[catId] ?? [];
      default:
        return [];
    }
  }

  // triple row Remove Bets
  List<Map<String, dynamic>> tripleRowTrackList = [];
  void tripleRowRemoveBets(BuildContext context, int rowIndex) {
    if (!isPlayAllowed()) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    int rowRemoveIndex = -1;

    for (int i = tripleRowTrackList.length - 1; i >= 0; i--) {
      if (tripleRowTrackList[i]['rowIndex'] == rowIndex) {
        rowRemoveIndex = i;
        break;
      }
    }
    if (rowRemoveIndex != -1) {
      var betToRemove = tripleRowTrackList.removeAt(rowRemoveIndex);
      List<Map<String, dynamic>> rowBet = betToRemove['rowBet'] ?? [];

      for (var bet in rowBet) {
        String cardId = bet['cardIds'];
        int amount = bet['amount'];
        var existingBet = addTripleChanceBets.firstWhere(
          (bet) => bet['game_id'] == cardId,
        );

        if (existingBet.isNotEmpty) {
          if (existingBet['amount'] > amount) {
            existingBet['amount'] -= amount;
          } else {
            addTripleChanceBets.removeWhere((bet) => bet['game_id'] == cardId);
          }

          tripleTotalAmount -= amount;
          profileViewModel.addBalance(amount);
        } else {
          if (kDebugMode) {
            print("Bet not found for cardId: $cardId");
          }
        }
      }
    } else {
      if (kDebugMode) {
        print("Row not found for rowIndex: $rowIndex");
      }
    }

    notifyListeners();
  }

  // triple Column add Bets
  void tripleColumnAddBets(
      int columnIndex, int amount, int wheelNo, dynamic catId, context) {
    if (!isPlayAllowed()) return;
    if (_resetOne) {
      tripleColumnRemoveBets(context, columnIndex);
      return;
    }
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    List<dynamic> betsIds = _getBetsIdsForColumnTriple(columnIndex, catId);

    if (betsIds.isEmpty) return;

    int totalRequiredBalance = betsIds.length * amount;

    if (totalRequiredBalance > profileViewModel.balance) {
      setMessage('INSUFFICIENT BALANCE');
      return;
    }

    final int betLimit = _getBetLimit(wheelNo);
    bool isLimitExceeded = false;

    for (var gameId in betsIds) {
      var existingBet = addTripleChanceBets.firstWhere(
        (bet) => bet['game_id'] == gameId && bet['cat_id'] == catId,
        orElse: () => <String, int>{},
      );

      isLimitExceeded = _isBetLimitExceeded(existingBet, amount, betLimit);

      if (isLimitExceeded) {
        if (kDebugMode) {
          print("Bet limit exceeded for game_id: $gameId. Bet canceled.");
        }
        return;
      }

      if (existingBet.isNotEmpty) {
        existingBet['amount'] = (existingBet['amount'] ?? 0) + amount;
      } else {
        addTripleChanceBets.add({
          'game_id': gameId,
          'amount': amount,
          'wheel_no': wheelNo,
          'cat_id': catId
        });
      }
    }
    List<Map<String, dynamic>> rowBet = [];
    for (var gameId in betsIds) {
      rowBet.add({'cardIds': gameId, 'amount': amount});
    }

    tripleColumnTrackList
        .add({"columnIndex": columnIndex, "columnBet": rowBet});
    tripleTotalAmount += totalRequiredBalance;
    profileViewModel.deductBalance(totalRequiredBalance);
    notifyListeners();
  }

  List<dynamic> _getBetsIdsForColumnTriple(int rowIndex, String catId) {
    const Map<String, List<String>> catIdCase0 = {
      "000": [
        '000',
        '010',
        '020',
        '030',
        '040',
        '050',
        '060',
        '070',
        '080',
        '090'
      ],
      "100": [
        '100',
        '110',
        '120',
        '130',
        '140',
        '150',
        '160',
        '170',
        '180',
        '190'
      ],
      "200": [
        '200',
        '210',
        '220',
        '230',
        '240',
        '250',
        '260',
        '270',
        '280',
        '290'
      ],
      "300": [
        '300',
        '310',
        '320',
        '330',
        '340',
        '350',
        '360',
        '370',
        '380',
        '390'
      ],
      "400": [
        '400',
        '410',
        '420',
        '430',
        '440',
        '450',
        '460',
        '470',
        '480',
        '490'
      ],
      "500": [
        '500',
        '510',
        '520',
        '530',
        '540',
        '550',
        '560',
        '570',
        '580',
        '590'
      ],
      "600": [
        '600',
        '610',
        '620',
        '630',
        '640',
        '650',
        '660',
        '670',
        '680',
        '690'
      ],
      "700": [
        '700',
        '710',
        '720',
        '730',
        '740',
        '750',
        '760',
        '770',
        '780',
        '790'
      ],
      "800": [
        '800',
        '810',
        '820',
        '830',
        '840',
        '850',
        '860',
        '870',
        '880',
        '890'
      ],
      "900": [
        '900',
        '910',
        '920',
        '930',
        '940',
        '950',
        '960',
        '970',
        '980',
        '990'
      ]
    };

    const Map<String, List<String>> catIdCase1 = {
      "000": [
        '001',
        '011',
        '021',
        '031',
        '041',
        '051',
        '061',
        '071',
        '081',
        '091'
      ],
      "100": [
        '101',
        '111',
        '121',
        '131',
        '141',
        '151',
        '161',
        '171',
        '181',
        '191'
      ],
      "200": [
        '201',
        '211',
        '221',
        '231',
        '241',
        '251',
        '261',
        '271',
        '281',
        '291'
      ],
      "300": [
        '301',
        '311',
        '321',
        '331',
        '341',
        '351',
        '361',
        '371',
        '381',
        '391'
      ],
      "400": [
        '401',
        '411',
        '421',
        '431',
        '441',
        '451',
        '461',
        '471',
        '481',
        '491'
      ],
      "500": [
        '501',
        '511',
        '521',
        '531',
        '541',
        '551',
        '561',
        '571',
        '581',
        '591'
      ],
      "600": [
        '601',
        '611',
        '621',
        '631',
        '641',
        '651',
        '661',
        '671',
        '681',
        '691'
      ],
      "700": [
        '701',
        '711',
        '721',
        '731',
        '741',
        '751',
        '761',
        '771',
        '781',
        '791'
      ],
      "800": [
        '801',
        '811',
        '821',
        '831',
        '841',
        '851',
        '861',
        '871',
        '881',
        '891'
      ],
      "900": [
        '901',
        '911',
        '921',
        '931',
        '941',
        '951',
        '961',
        '971',
        '981',
        '991'
      ]
    };

    const Map<String, List<String>> catIdCase2 = {
      "000": [
        '002',
        '012',
        '022',
        '032',
        '042',
        '052',
        '062',
        '072',
        '082',
        '092'
      ],
      "100": [
        '102',
        '112',
        '122',
        '132',
        '142',
        '152',
        '162',
        '172',
        '182',
        '192'
      ],
      "200": [
        '202',
        '212',
        '222',
        '232',
        '242',
        '252',
        '262',
        '272',
        '282',
        '292'
      ],
      "300": [
        '302',
        '312',
        '322',
        '332',
        '342',
        '352',
        '362',
        '372',
        '382',
        '392'
      ],
      "400": [
        '402',
        '412',
        '422',
        '432',
        '442',
        '452',
        '462',
        '472',
        '482',
        '492'
      ],
      "500": [
        '502',
        '512',
        '522',
        '532',
        '542',
        '552',
        '562',
        '572',
        '582',
        '592'
      ],
      "600": [
        '602',
        '612',
        '622',
        '632',
        '642',
        '652',
        '662',
        '672',
        '682',
        '692'
      ],
      "700": [
        '702',
        '712',
        '722',
        '732',
        '742',
        '752',
        '762',
        '772',
        '782',
        '792'
      ],
      "800": [
        '802',
        '812',
        '822',
        '832',
        '842',
        '852',
        '862',
        '872',
        '882',
        '892'
      ],
      "900": [
        '902',
        '912',
        '922',
        '932',
        '942',
        '952',
        '962',
        '972',
        '982',
        '992'
      ]
    };

    const Map<String, List<String>> catIdCase3 = {
      "000": [
        '003',
        '013',
        '023',
        '033',
        '043',
        '053',
        '063',
        '073',
        '083',
        '093'
      ],
      "100": [
        '103',
        '113',
        '123',
        '133',
        '143',
        '153',
        '163',
        '173',
        '183',
        '193'
      ],
      "200": [
        '203',
        '213',
        '223',
        '233',
        '243',
        '253',
        '263',
        '273',
        '283',
        '293'
      ],
      "300": [
        '303',
        '313',
        '323',
        '333',
        '343',
        '353',
        '363',
        '373',
        '383',
        '393'
      ],
      "400": [
        '403',
        '413',
        '423',
        '433',
        '443',
        '453',
        '463',
        '473',
        '483',
        '493'
      ],
      "500": [
        '503',
        '513',
        '523',
        '533',
        '543',
        '553',
        '563',
        '573',
        '583',
        '593'
      ],
      "600": [
        '603',
        '613',
        '623',
        '633',
        '643',
        '653',
        '663',
        '673',
        '683',
        '693'
      ],
      "700": [
        '703',
        '713',
        '723',
        '733',
        '743',
        '753',
        '763',
        '773',
        '783',
        '793'
      ],
      "800": [
        '803',
        '813',
        '823',
        '833',
        '843',
        '853',
        '863',
        '873',
        '883',
        '893'
      ],
      "900": [
        '903',
        '913',
        '923',
        '933',
        '943',
        '953',
        '963',
        '973',
        '983',
        '993'
      ]
    };

    const Map<String, List<String>> catIdCase4 = {
      "000": [
        '004',
        '014',
        '024',
        '034',
        '044',
        '054',
        '064',
        '074',
        '084',
        '094'
      ],
      "100": [
        '104',
        '114',
        '124',
        '134',
        '144',
        '154',
        '164',
        '174',
        '184',
        '194'
      ],
      "200": [
        '204',
        '214',
        '224',
        '234',
        '244',
        '254',
        '264',
        '274',
        '284',
        '294'
      ],
      "300": [
        '304',
        '314',
        '324',
        '334',
        '344',
        '354',
        '364',
        '374',
        '384',
        '394'
      ],
      "400": [
        '404',
        '414',
        '424',
        '434',
        '444',
        '454',
        '464',
        '474',
        '484',
        '494'
      ],
      "500": [
        '504',
        '514',
        '524',
        '534',
        '544',
        '554',
        '564',
        '574',
        '584',
        '594'
      ],
      "600": [
        '604',
        '614',
        '624',
        '634',
        '644',
        '654',
        '664',
        '674',
        '684',
        '694'
      ],
      "700": [
        '704',
        '714',
        '724',
        '734',
        '744',
        '754',
        '764',
        '774',
        '784',
        '794'
      ],
      "800": [
        '804',
        '814',
        '824',
        '834',
        '844',
        '854',
        '864',
        '874',
        '884',
        '894'
      ],
      "900": [
        '904',
        '914',
        '924',
        '934',
        '944',
        '954',
        '964',
        '974',
        '984',
        '994'
      ]
    };

    const Map<String, List<String>> catIdCase5 = {
      "000": [
        '005',
        '015',
        '025',
        '035',
        '045',
        '055',
        '065',
        '075',
        '085',
        '095'
      ],
      "100": [
        '105',
        '115',
        '125',
        '135',
        '145',
        '155',
        '165',
        '175',
        '185',
        '195'
      ],
      "200": [
        '205',
        '215',
        '225',
        '235',
        '245',
        '255',
        '265',
        '275',
        '285',
        '295'
      ],
      "300": [
        '305',
        '315',
        '325',
        '335',
        '345',
        '355',
        '365',
        '375',
        '385',
        '395'
      ],
      "400": [
        '405',
        '415',
        '425',
        '435',
        '445',
        '455',
        '465',
        '475',
        '485',
        '495'
      ],
      "500": [
        '505',
        '515',
        '525',
        '535',
        '545',
        '555',
        '565',
        '575',
        '585',
        '595'
      ],
      "600": [
        '605',
        '615',
        '625',
        '635',
        '645',
        '655',
        '665',
        '675',
        '685',
        '695'
      ],
      "700": [
        '705',
        '715',
        '725',
        '735',
        '745',
        '755',
        '765',
        '775',
        '785',
        '795'
      ],
      "800": [
        '805',
        '815',
        '825',
        '835',
        '845',
        '855',
        '865',
        '875',
        '885',
        '895'
      ],
      "900": [
        '905',
        '915',
        '925',
        '935',
        '945',
        '955',
        '965',
        '975',
        '985',
        '995'
      ]
    };

    const Map<String, List<String>> catIdCase6 = {
      "000": [
        '006',
        '016',
        '026',
        '036',
        '046',
        '056',
        '066',
        '076',
        '086',
        '096'
      ],
      "100": [
        '106',
        '116',
        '126',
        '136',
        '146',
        '156',
        '166',
        '176',
        '186',
        '196'
      ],
      "200": [
        '206',
        '216',
        '226',
        '236',
        '246',
        '256',
        '266',
        '276',
        '286',
        '296'
      ],
      "300": [
        '306',
        '316',
        '326',
        '336',
        '346',
        '356',
        '366',
        '376',
        '386',
        '396'
      ],
      "400": [
        '406',
        '416',
        '426',
        '436',
        '446',
        '456',
        '466',
        '476',
        '486',
        '496'
      ],
      "500": [
        '506',
        '516',
        '526',
        '536',
        '546',
        '556',
        '566',
        '576',
        '586',
        '596'
      ],
      "600": [
        '606',
        '616',
        '626',
        '636',
        '646',
        '656',
        '666',
        '676',
        '686',
        '696'
      ],
      "700": [
        '706',
        '716',
        '726',
        '736',
        '746',
        '756',
        '766',
        '776',
        '786',
        '796'
      ],
      "800": [
        '806',
        '816',
        '826',
        '836',
        '846',
        '856',
        '866',
        '876',
        '886',
        '896'
      ],
      "900": [
        '906',
        '916',
        '926',
        '936',
        '946',
        '956',
        '966',
        '976',
        '986',
        '996'
      ]
    };

    const Map<String, List<String>> catIdCase7 = {
      "000": [
        '007',
        '017',
        '027',
        '037',
        '047',
        '057',
        '067',
        '077',
        '087',
        '097'
      ],
      "100": [
        '107',
        '117',
        '127',
        '137',
        '147',
        '157',
        '167',
        '177',
        '187',
        '197'
      ],
      "200": [
        '207',
        '217',
        '227',
        '237',
        '247',
        '257',
        '267',
        '277',
        '287',
        '297'
      ],
      "300": [
        '307',
        '317',
        '327',
        '337',
        '347',
        '357',
        '367',
        '377',
        '387',
        '397'
      ],
      "400": [
        '407',
        '417',
        '427',
        '437',
        '447',
        '457',
        '467',
        '477',
        '487',
        '497'
      ],
      "500": [
        '507',
        '517',
        '527',
        '537',
        '547',
        '557',
        '567',
        '577',
        '587',
        '597'
      ],
      "600": [
        '607',
        '617',
        '627',
        '637',
        '647',
        '657',
        '667',
        '677',
        '687',
        '697'
      ],
      "700": [
        '707',
        '717',
        '727',
        '737',
        '747',
        '757',
        '767',
        '777',
        '787',
        '797'
      ],
      "800": [
        '807',
        '817',
        '827',
        '837',
        '847',
        '857',
        '867',
        '877',
        '887',
        '897'
      ],
      "900": [
        '907',
        '917',
        '927',
        '937',
        '947',
        '957',
        '967',
        '977',
        '987',
        '997'
      ]
    };

    const Map<String, List<String>> catIdCase8 = {
      "000": [
        '008',
        '018',
        '028',
        '038',
        '048',
        '058',
        '068',
        '078',
        '088',
        '098'
      ],
      "100": [
        '108',
        '118',
        '128',
        '138',
        '148',
        '158',
        '168',
        '178',
        '188',
        '198'
      ],
      "200": [
        '208',
        '218',
        '228',
        '238',
        '248',
        '258',
        '268',
        '278',
        '288',
        '298'
      ],
      "300": [
        '308',
        '318',
        '328',
        '338',
        '348',
        '358',
        '368',
        '378',
        '388',
        '398'
      ],
      "400": [
        '408',
        '418',
        '428',
        '438',
        '448',
        '458',
        '468',
        '478',
        '488',
        '498'
      ],
      "500": [
        '508',
        '518',
        '528',
        '538',
        '548',
        '558',
        '568',
        '578',
        '588',
        '598'
      ],
      "600": [
        '608',
        '618',
        '628',
        '638',
        '648',
        '658',
        '668',
        '678',
        '688',
        '698'
      ],
      "700": [
        '708',
        '718',
        '728',
        '738',
        '748',
        '758',
        '768',
        '778',
        '788',
        '798'
      ],
      "800": [
        '808',
        '818',
        '828',
        '838',
        '848',
        '858',
        '868',
        '878',
        '888',
        '898'
      ],
      "900": [
        '908',
        '918',
        '928',
        '938',
        '948',
        '958',
        '968',
        '978',
        '988',
        '998'
      ]
    };

    const Map<String, List<String>> catIdCase9 = {
      "000": [
        '009',
        '019',
        '029',
        '039',
        '049',
        '059',
        '069',
        '079',
        '089',
        '099'
      ],
      "100": [
        '109',
        '119',
        '129',
        '139',
        '149',
        '159',
        '169',
        '179',
        '189',
        '199'
      ],
      "200": [
        '209',
        '219',
        '229',
        '239',
        '249',
        '259',
        '269',
        '279',
        '289',
        '299'
      ],
      "300": [
        '309',
        '319',
        '329',
        '339',
        '349',
        '359',
        '369',
        '379',
        '389',
        '399'
      ],
      "400": [
        '409',
        '419',
        '429',
        '439',
        '449',
        '459',
        '469',
        '479',
        '489',
        '499'
      ],
      "500": [
        '509',
        '519',
        '529',
        '539',
        '549',
        '559',
        '569',
        '579',
        '589',
        '599'
      ],
      "600": [
        '609',
        '619',
        '629',
        '639',
        '649',
        '659',
        '669',
        '679',
        '689',
        '699'
      ],
      "700": [
        '709',
        '719',
        '729',
        '739',
        '749',
        '759',
        '769',
        '779',
        '789',
        '799'
      ],
      "800": [
        '809',
        '819',
        '829',
        '839',
        '849',
        '859',
        '869',
        '879',
        '889',
        '899'
      ],
      "900": [
        '909',
        '919',
        '929',
        '939',
        '949',
        '959',
        '969',
        '979',
        '989',
        '999'
      ]
    };

    switch (rowIndex) {
      case 0:
        return catIdCase0[catId] ?? [];
      case 1:
        return catIdCase1[catId] ?? [];
      case 2:
        return catIdCase2[catId] ?? [];
      case 3:
        return catIdCase3[catId] ?? [];
      case 4:
        return catIdCase4[catId] ?? [];
      case 5:
        return catIdCase5[catId] ?? [];
      case 6:
        return catIdCase6[catId] ?? [];
      case 7:
        return catIdCase7[catId] ?? [];
      case 8:
        return catIdCase8[catId] ?? [];
      case 9:
        return catIdCase9[catId] ?? [];
      default:
        return [];
    }
  }

  List<Map<String, dynamic>> tripleColumnTrackList = [];

  // triple Column Remove Bets
  void tripleColumnRemoveBets(BuildContext context, int columnIndex) {
    if (!isPlayAllowed()) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    int columnRemoveIndex = -1;
    for (int i = tripleColumnTrackList.length - 1; i >= 0; i--) {
      if (tripleColumnTrackList[i]['columnIndex'] == columnIndex) {
        columnRemoveIndex = i;
        break;
      }
    }

    if (columnRemoveIndex != -1) {
      var betToRemove = tripleColumnTrackList.removeAt(columnRemoveIndex);
      List<Map<String, dynamic>> columnBet = betToRemove['columnBet'];

      // Step 3: Process and remove the bets
      for (var bet in columnBet) {
        String cardId = bet['cardIds'];
        int amount = bet['amount'];
        var existingBet = addTripleChanceBets.firstWhere(
          (bet) => bet['game_id'] == cardId,
        );

        if (existingBet.isNotEmpty) {
          if (existingBet['amount'] > amount) {
            existingBet['amount'] -= amount;
          } else {
            addTripleChanceBets.removeWhere((bet) => bet['game_id'] == cardId);
          }

          tripleTotalAmount -= amount;
          profileViewModel.addBalance(amount);
        } else {
          if (kDebugMode) {
            print("Bet not found for cardId: $cardId");
          }
        }
      }
    } else {
      if (kDebugMode) {
        print("Column not found for columnIndex: $columnIndex");
      }
    }

    notifyListeners();
  }

  // random double bet
  List<Map<String, dynamic>> ranDoubleTrackList = [];
  void randomDoubleBets(int noOfBets, int amount, int wheelNo, context) {
    if (!isPlayAllowed()) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    List<dynamic> betsIds = getDoubleRandomBets(noOfBets);

    if (betsIds.isEmpty) return;

    int totalRequiredBalance = betsIds.length * amount;

    if (totalRequiredBalance > profileViewModel.balance) {
      setMessage('INSUFFICIENT BALANCE');
      return;
    }

    final int betLimit = _getBetLimit(wheelNo);
    bool isLimitExceeded = false;
    if (ranDoubleTrackList.isNotEmpty) {
      for (var trackBet in ranDoubleTrackList) {
        var existingBet = addTripleChanceBets.firstWhere(
          (bet) => bet['game_id'] == trackBet['game_id'],
          orElse: () => <String, int>{},
        );

        if (existingBet.isNotEmpty) {
          existingBet['amount'] =
              (existingBet['amount'] ?? 0) - trackBet['amount'];
          if (existingBet['amount'] <= 0) {
            addTripleChanceBets
                .removeWhere((bet) => bet['game_id'] == trackBet['game_id']);
          }
        }
      }
    }

    ranDoubleTrackList.clear();

    for (var gameId in betsIds) {
      var existingBet = addTripleChanceBets.firstWhere(
        (bet) => bet['game_id'] == gameId,
        orElse: () => <String, int>{},
      );

      isLimitExceeded = _isBetLimitExceeded(existingBet, amount, betLimit);

      if (isLimitExceeded) {
        if (kDebugMode) {
          print("Bet limit exceeded for game_id: $gameId. Bet canceled.");
        }
        return;
      }
    }

    for (var gameId in betsIds) {
      var existingBet = addTripleChanceBets.firstWhere(
        (bet) => bet['game_id'] == gameId,
        orElse: () => <String, int>{},
      );

      if (existingBet.isNotEmpty) {
        existingBet['amount'] = (existingBet['amount'] ?? 0) + amount;
        ranDoubleTrackList.add({
          'game_id': existingBet['game_id'],
          'amount': amount,
          'wheel_no': wheelNo
        });
      } else {
        addTripleChanceBets
            .add({'game_id': gameId, 'amount': amount, 'wheel_no': wheelNo});
        ranDoubleTrackList
            .add({'game_id': gameId, 'amount': amount, 'wheel_no': wheelNo});
      }
    }

    doubleTotalAmount += totalRequiredBalance;
    profileViewModel.deductBalance(totalRequiredBalance);

    notifyListeners();
  }

  List<String> doubleRandom = [
    '00',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '55',
    '46',
    '77',
    '48',
    '49',
    '50',
    '51',
    '52',
    '53',
    '54',
    '55',
    '56',
    '57',
    '58',
    '59',
    '60',
    '61',
    '62',
    '63',
    '64',
    '65',
    '66',
    '67',
    '68',
    '69',
    '70',
    '71',
    '72',
    '73',
    '74',
    '75',
    '76',
    '77',
    '78',
    '79',
    '80',
    '81',
    '82',
    '83',
    '84',
    '85',
    '86',
    '87',
    '88',
    '89',
    '90',
    '91',
    '92',
    '93',
    '94',
    '95',
    '96',
    '97',
    '98',
    '99'
  ];
  List<String> getDoubleRandomBets(int noOfBets) {
    if (noOfBets > doubleRandom.length) {
      noOfBets = doubleRandom.length;
    }
    doubleRandom.shuffle(Random());
    return doubleRandom.take(noOfBets).toList();
  }

  // random triple bet
  List<Map<String, dynamic>> ranTripleTrackList = [];
  void randomTripleBets(
      int noOfBets, int amount, int wheelNo, String catId, context) {
    if (!isPlayAllowed()) return;
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    List<dynamic> betsIds = getTripleRandomBets(noOfBets, catId);

    if (betsIds.isEmpty) return;

    int totalRequiredBalance = betsIds.length * amount;

    if (totalRequiredBalance > profileViewModel.balance) {
      setMessage('INSUFFICIENT BALANCE');
      return;
    }

    final int betLimit = _getBetLimit(wheelNo);
    bool isLimitExceeded = false;
    if (ranTripleTrackList.isNotEmpty) {
      for (var trackBet in ranTripleTrackList
          .where((bet) => bet['cat_id'] == catId)
          .toList()) {
        var existingBet = addTripleChanceBets.firstWhere(
          (bet) =>
              bet['game_id'] == trackBet['game_id'] &&
              bet['cat_id'] == trackBet['cat_id'],
          orElse: () => <String, int>{},
        );

        if (existingBet.isNotEmpty) {
          existingBet['amount'] =
              (existingBet['amount'] ?? 0) - trackBet['amount'];
          if (existingBet['amount'] <= 0) {
            addTripleChanceBets.removeWhere((bet) =>
                bet['game_id'] == trackBet['game_id'] &&
                bet['cat_id'] == catId);
          }
        }
      }
    }

    int totalTrackBalance = ranTripleTrackList
        .where((bet) => bet['cat_id'] == catId)
        .fold(0, (sum, bet) => sum + (bet['amount']! as int));

    if (tripleTotalAmount != 0) {
      tripleTotalAmount -= totalTrackBalance;
      profileViewModel.addBalance(totalTrackBalance);
    }

    ranTripleTrackList.removeWhere((bet) => bet['cat_id'] == catId);

    for (var gameId in betsIds) {
      var existingBet = addTripleChanceBets.firstWhere(
        (bet) => bet['game_id'] == gameId && bet['cat_id'] == catId,
        orElse: () => <String, int>{},
      );

      isLimitExceeded = _isBetLimitExceeded(existingBet, amount, betLimit);

      if (isLimitExceeded) {
        if (kDebugMode) {
          print("Bet limit exceeded for game_id: $gameId. Bet canceled.");
        }
        return;
      }
    }

    for (var gameId in betsIds) {
      var existingBet = addTripleChanceBets.firstWhere(
        (bet) => bet['game_id'] == gameId && bet['cat_id'] == catId,
        orElse: () => <String, int>{},
      );

      if (existingBet.isNotEmpty) {
        existingBet['amount'] = (existingBet['amount'] ?? 0) + amount;
      } else {
        addTripleChanceBets.add({
          'game_id': gameId,
          'amount': amount,
          'wheel_no': wheelNo,
          'cat_id': catId
        });
      }
      ranTripleTrackList.add({
        'game_id': gameId,
        'amount': amount,
        'wheel_no': wheelNo,
        'cat_id': catId
      });
    }

    tripleTotalAmount += totalRequiredBalance;
    profileViewModel.deductBalance(totalRequiredBalance);
    notifyListeners();
  }

  List<dynamic> _getBetsIdsForTripleRandom(String catId) {
    List<String> tripleCase000 = [
      '000',
      '001',
      '002',
      '003',
      '004',
      '005',
      '006',
      '007',
      '008',
      '009',
      '010',
      '011',
      '012',
      '013',
      '014',
      '015',
      '016',
      '017',
      '018',
      '019',
      '020',
      '021',
      '022',
      '023',
      '024',
      '025',
      '026',
      '027',
      '028',
      '029',
      '030',
      '031',
      '032',
      '033',
      '034',
      '035',
      '036',
      '037',
      '038',
      '039',
      '040',
      '041',
      '042',
      '043',
      '044',
      '045',
      '046',
      '047',
      '048',
      '049',
      '050',
      '051',
      '052',
      '053',
      '054',
      '055',
      '056',
      '057',
      '058',
      '059',
      '060',
      '061',
      '062',
      '063',
      '064',
      '065',
      '066',
      '067',
      '068',
      '069',
      '070',
      '071',
      '072',
      '073',
      '074',
      '075',
      '076',
      '077',
      '078',
      '079',
      '080',
      '081',
      '082',
      '083',
      '084',
      '085',
      '086',
      '087',
      '088',
      '089',
      '090',
      '091',
      '092',
      '093',
      '094',
      '095',
      '096',
      '097',
      '098',
      '099'
    ];
    List<String> tripleCase100 = [
      '100',
      '101',
      '102',
      '103',
      '104',
      '105',
      '106',
      '107',
      '108',
      '109',
      '110',
      '111',
      '112',
      '113',
      '114',
      '115',
      '116',
      '117',
      '118',
      '119',
      '120',
      '121',
      '122',
      '123',
      '124',
      '125',
      '126',
      '127',
      '128',
      '129',
      '130',
      '131',
      '132',
      '133',
      '134',
      '135',
      '136',
      '137',
      '138',
      '139',
      '140',
      '141',
      '142',
      '143',
      '144',
      '145',
      '146',
      '147',
      '148',
      '149',
      '150',
      '151',
      '152',
      '153',
      '154',
      '155',
      '156',
      '157',
      '158',
      '159',
      '160',
      '161',
      '162',
      '163',
      '164',
      '165',
      '166',
      '167',
      '168',
      '169',
      '170',
      '171',
      '172',
      '173',
      '174',
      '175',
      '176',
      '177',
      '178',
      '179',
      '180',
      '181',
      '182',
      '183',
      '184',
      '185',
      '186',
      '187',
      '188',
      '189',
      '190',
      '191',
      '192',
      '193',
      '194',
      '195',
      '196',
      '197',
      '198',
      '199'
    ];
    List<String> tripleCase200 = [
      '200',
      '201',
      '202',
      '203',
      '204',
      '205',
      '206',
      '207',
      '208',
      '209',
      '210',
      '211',
      '212',
      '213',
      '214',
      '215',
      '216',
      '217',
      '218',
      '219',
      '220',
      '221',
      '222',
      '223',
      '224',
      '225',
      '226',
      '227',
      '228',
      '229',
      '230',
      '231',
      '232',
      '233',
      '234',
      '235',
      '236',
      '237',
      '238',
      '239',
      '240',
      '241',
      '242',
      '243',
      '244',
      '245',
      '246',
      '247',
      '248',
      '249',
      '250',
      '251',
      '252',
      '253',
      '254',
      '255',
      '256',
      '257',
      '258',
      '259',
      '260',
      '261',
      '262',
      '263',
      '264',
      '265',
      '266',
      '267',
      '268',
      '269',
      '270',
      '271',
      '272',
      '273',
      '274',
      '275',
      '276',
      '277',
      '278',
      '279',
      '280',
      '281',
      '282',
      '283',
      '284',
      '285',
      '286',
      '287',
      '288',
      '289',
      '290',
      '291',
      '292',
      '293',
      '294',
      '295',
      '296',
      '297',
      '298',
      '299'
    ];
    List<String> tripleCase300 = [
      '300',
      '301',
      '302',
      '303',
      '304',
      '305',
      '306',
      '307',
      '308',
      '309',
      '310',
      '311',
      '312',
      '313',
      '314',
      '315',
      '316',
      '317',
      '318',
      '319',
      '320',
      '321',
      '322',
      '323',
      '324',
      '325',
      '326',
      '327',
      '328',
      '329',
      '330',
      '331',
      '332',
      '333',
      '334',
      '335',
      '336',
      '337',
      '338',
      '339',
      '340',
      '341',
      '342',
      '343',
      '344',
      '345',
      '346',
      '347',
      '348',
      '349',
      '350',
      '351',
      '352',
      '353',
      '354',
      '355',
      '356',
      '357',
      '358',
      '359',
      '360',
      '361',
      '362',
      '363',
      '364',
      '365',
      '366',
      '367',
      '368',
      '369',
      '370',
      '371',
      '372',
      '373',
      '374',
      '375',
      '376',
      '377',
      '378',
      '379',
      '380',
      '381',
      '382',
      '383',
      '384',
      '385',
      '386',
      '387',
      '388',
      '389',
      '390',
      '391',
      '392',
      '393',
      '394',
      '395',
      '396',
      '397',
      '398',
      '399'
    ];
    List<String> tripleCase400 = [
      '400',
      '401',
      '402',
      '403',
      '404',
      '405',
      '406',
      '407',
      '408',
      '409',
      '410',
      '411',
      '412',
      '413',
      '414',
      '415',
      '416',
      '417',
      '418',
      '419',
      '420',
      '421',
      '422',
      '423',
      '424',
      '425',
      '426',
      '427',
      '428',
      '429',
      '430',
      '431',
      '432',
      '433',
      '434',
      '435',
      '436',
      '437',
      '438',
      '439',
      '440',
      '441',
      '442',
      '443',
      '444',
      '445',
      '446',
      '447',
      '448',
      '449',
      '450',
      '451',
      '452',
      '453',
      '454',
      '455',
      '456',
      '457',
      '458',
      '459',
      '460',
      '461',
      '462',
      '463',
      '464',
      '465',
      '466',
      '467',
      '468',
      '469',
      '470',
      '471',
      '472',
      '473',
      '474',
      '475',
      '476',
      '477',
      '478',
      '479',
      '480',
      '481',
      '482',
      '483',
      '484',
      '485',
      '486',
      '487',
      '488',
      '489',
      '490',
      '491',
      '492',
      '493',
      '494',
      '495',
      '496',
      '497',
      '498',
      '499'
    ];
    List<String> tripleCase500 = [
      '500',
      '501',
      '502',
      '503',
      '504',
      '505',
      '506',
      '507',
      '508',
      '509',
      '510',
      '511',
      '512',
      '513',
      '514',
      '515',
      '516',
      '517',
      '518',
      '519',
      '520',
      '521',
      '522',
      '523',
      '524',
      '525',
      '526',
      '527',
      '528',
      '529',
      '530',
      '531',
      '532',
      '533',
      '534',
      '535',
      '536',
      '537',
      '538',
      '539',
      '540',
      '541',
      '542',
      '543',
      '544',
      '545',
      '546',
      '547',
      '548',
      '549',
      '550',
      '551',
      '552',
      '553',
      '554',
      '555',
      '556',
      '557',
      '558',
      '559',
      '560',
      '561',
      '562',
      '563',
      '564',
      '565',
      '566',
      '567',
      '568',
      '569',
      '570',
      '571',
      '572',
      '573',
      '574',
      '575',
      '576',
      '577',
      '578',
      '579',
      '580',
      '581',
      '582',
      '583',
      '584',
      '585',
      '586',
      '587',
      '588',
      '589',
      '590',
      '591',
      '592',
      '593',
      '594',
      '595',
      '596',
      '597',
      '598',
      '599'
    ];
    List<String> tripleCase600 = [
      '600',
      '601',
      '602',
      '603',
      '604',
      '605',
      '606',
      '607',
      '608',
      '609',
      '610',
      '611',
      '612',
      '613',
      '614',
      '615',
      '616',
      '617',
      '618',
      '619',
      '610',
      '611',
      '612',
      '613',
      '614',
      '615',
      '616',
      '617',
      '618',
      '619',
      '620',
      '621',
      '622',
      '623',
      '624',
      '625',
      '626',
      '627',
      '628',
      '629',
      '630',
      '631',
      '632',
      '633',
      '634',
      '635',
      '636',
      '637',
      '638',
      '639',
      '640',
      '641',
      '642',
      '643',
      '644',
      '645',
      '646',
      '647',
      '648',
      '649',
      '650',
      '651',
      '652',
      '653',
      '654',
      '655',
      '656',
      '657',
      '658',
      '659',
      '660',
      '661',
      '662',
      '663',
      '664',
      '665',
      '666',
      '667',
      '668',
      '669',
      '670',
      '671',
      '672',
      '673',
      '674',
      '675',
      '676',
      '677',
      '678',
      '679',
      '680',
      '681',
      '682',
      '683',
      '684',
      '685',
      '686',
      '687',
      '688',
      '689',
      '690',
      '691',
      '692',
      '693',
      '694',
      '695',
      '696',
      '697',
      '698',
      '699'
    ];
    List<String> tripleCase700 = [
      '700',
      '701',
      '702',
      '703',
      '704',
      '705',
      '706',
      '707',
      '708',
      '709',
      '710',
      '711',
      '712',
      '713',
      '714',
      '715',
      '716',
      '717',
      '718',
      '719',
      '720',
      '721',
      '722',
      '723',
      '724',
      '725',
      '726',
      '727',
      '728',
      '729',
      '730',
      '731',
      '732',
      '733',
      '734',
      '735',
      '736',
      '737',
      '738',
      '739',
      '740',
      '741',
      '742',
      '743',
      '744',
      '745',
      '746',
      '747',
      '748',
      '749',
      '750',
      '751',
      '752',
      '753',
      '754',
      '755',
      '756',
      '757',
      '758',
      '759',
      '760',
      '761',
      '762',
      '763',
      '764',
      '765',
      '766',
      '767',
      '768',
      '769',
      '770',
      '771',
      '772',
      '773',
      '774',
      '775',
      '776',
      '777',
      '778',
      '779',
      '780',
      '781',
      '782',
      '783',
      '784',
      '785',
      '786',
      '787',
      '788',
      '789',
      '790',
      '791',
      '792',
      '793',
      '794',
      '795',
      '796',
      '797',
      '798',
      '799'
    ];
    List<String> tripleCase800 = [
      '800',
      '801',
      '802',
      '803',
      '804',
      '805',
      '806',
      '807',
      '808',
      '809',
      '810',
      '811',
      '812',
      '813',
      '814',
      '815',
      '816',
      '817',
      '818',
      '819',
      '820',
      '821',
      '822',
      '823',
      '824',
      '825',
      '826',
      '827',
      '828',
      '829',
      '830',
      '831',
      '832',
      '833',
      '834',
      '835',
      '836',
      '837',
      '838',
      '839',
      '840',
      '841',
      '842',
      '843',
      '844',
      '845',
      '846',
      '847',
      '848',
      '849',
      '850',
      '851',
      '852',
      '853',
      '854',
      '855',
      '856',
      '857',
      '858',
      '859',
      '860',
      '861',
      '862',
      '863',
      '864',
      '865',
      '866',
      '867',
      '868',
      '869',
      '870',
      '871',
      '872',
      '873',
      '874',
      '875',
      '876',
      '877',
      '878',
      '879',
      '880',
      '881',
      '882',
      '883',
      '884',
      '885',
      '886',
      '887',
      '888',
      '889',
      '890',
      '891',
      '892',
      '893',
      '894',
      '895',
      '896',
      '897',
      '898',
      '899'
    ];
    List<String> tripleCase900 = [
      '900',
      '901',
      '902',
      '903',
      '904',
      '905',
      '906',
      '907',
      '908',
      '909',
      '910',
      '911',
      '912',
      '913',
      '914',
      '915',
      '916',
      '917',
      '918',
      '919',
      '920',
      '921',
      '922',
      '923',
      '924',
      '925',
      '926',
      '927',
      '928',
      '929',
      '930',
      '931',
      '932',
      '933',
      '934',
      '935',
      '936',
      '937',
      '938',
      '939',
      '940',
      '941',
      '942',
      '943',
      '944',
      '945',
      '946',
      '947',
      '948',
      '949',
      '950',
      '951',
      '952',
      '953',
      '954',
      '955',
      '956',
      '957',
      '958',
      '959',
      '960',
      '961',
      '962',
      '963',
      '964',
      '965',
      '966',
      '967',
      '968',
      '969',
      '970',
      '971',
      '972',
      '973',
      '974',
      '975',
      '976',
      '977',
      '978',
      '979',
      '980',
      '981',
      '982',
      '983',
      '984',
      '985',
      '986',
      '987',
      '988',
      '989',
      '990',
      '991',
      '992',
      '993',
      '994',
      '995',
      '996',
      '997',
      '998',
      '999',
    ];

    switch (catId) {
      case '000':
        return tripleCase000;
      case '100':
        return tripleCase100;
      case '200':
        return tripleCase200;
      case '300':
        return tripleCase300;
      case '400':
        return tripleCase400;
      case '500':
        return tripleCase500;
      case '600':
        return tripleCase600;
      case '700':
        return tripleCase700;
      case '800':
        return tripleCase800;
      case '900':
        return tripleCase900;
      default:
        return [];
    }
  }

  List<dynamic> getTripleRandomBets(int noOfBets, catId) {
    List<dynamic> tripleRandom = _getBetsIdsForTripleRandom(catId);
    if (noOfBets > tripleRandom.length) {
      noOfBets = tripleRandom.length;
    }
    tripleRandom.shuffle(Random());
    return tripleRandom.take(noOfBets).toList();
  }

  int _selectedIndex = 0;
  int _selectedValue = 2;
  int get selectedIndex => _selectedIndex;
  int get selectedValue => _selectedValue;

  void selectChips(int idx, int value) {
    _selectedIndex = idx;
    _selectedValue = value;
    notifyListeners();
  }

  List<CoinModel> coinList = [
    CoinModel(image: Assets.tripleChanceC2, value: 2),
    CoinModel(image: Assets.tripleChanceC5, value: 5),
    CoinModel(image: Assets.tripleChanceC10, value: 10),
    CoinModel(image: Assets.tripleChanceC50, value: 50),
    CoinModel(image: Assets.tripleChanceC100, value: 100),
  ];

  final List<Color> colors = [
    const Color(0xff52f395),
    const Color(0xffffa6ff),
  ];
  List<int> commonListAll = [5, 10, 15, 20, 25, 50, 75];

  int nextIds = 0;
  int selectIndex = 0;
  List<String> intList = List.generate(
      10, (index) => index == 0 ? "000" : (index * 100).toString());

  List<int> gridValues = List.generate(100, (index) => index);

  void updateGrid(int newStart, int index) {
    nextIds = newStart;
    selectIndex = index;
    gridValues = List.generate(100, (index) => newStart + index);
    notifyListeners();
  }
}

class CoinModel {
  final String image;
  final int value;

  CoinModel({
    required this.image,
    required this.value,
  });
}
