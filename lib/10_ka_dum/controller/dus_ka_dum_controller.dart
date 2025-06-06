import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:super_star/10_ka_dum/res/api_url.dart';
import 'package:super_star/10_ka_dum/view_model/dus_ka_dum_result_view_model.dart';
import 'package:super_star/spin_to_win/view_model/profile_view_model.dart';
import '../../generated/assets.dart';
import '../../lucky_card_12/controller/lucky_12_controller.dart';
import '../../lucky_card_16/controller/audio_controller.dart';
import '../res/sizes_const.dart';

class DusKaDumController extends ChangeNotifier {
  String get nextDrawTimeFormatted {
    DateTime nextDrawTime = DateTime.now().add(
      Duration(seconds: _timerBetTime + 10),
    );
    return DateFormat('hh:mm a').format(nextDrawTime);
  }

  final bettingNumberList = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
  ];

  List<LuckyCoinModel> coinList = [
    LuckyCoinModel(image: Assets.lucky16LC50, value: 5),
    LuckyCoinModel(image: Assets.lucky16LC20, value: 10),
    LuckyCoinModel(image: Assets.lucky16LC10, value: 20),
    LuckyCoinModel(image: Assets.lucky16LC50, value: 50),
    LuckyCoinModel(image: Assets.lucky16LC20, value: 100),
    LuckyCoinModel(image: Assets.lucky16LC10, value: 500),
    LuckyCoinModel(image: Assets.lucky16LC50, value: 1000),
  ];
  List<dynamic> addDusKDBetsPrinting = [];
  int _selectedChip = 5;
  int get selectedChip => _selectedChip;

  selectChip(int num) {
    _selectedChip = num;
    notifyListeners();
  }

  setBetPrinting(List<dynamic> bet) {
    addDusKDBetsPrinting.addAll(bet);
    debugPrint("debug ${addDusKDBetsPrinting.length}");
    notifyListeners();
  }

  clearBetPrinting() {
    addDusKDBetsPrinting = [];
    notifyListeners();
  }

  clearBetAfterPrint() {
    dusKaDumBets.clear();
    totalBetAmount = 0;
    tapedRowList.clear();
    tapedColumnList.clear();
    tapedRowTrack.clear();
    tapedColumnTrack.clear();
    notifyListeners();
  }

  List<dynamic> _dusKaDumBets = [];
  List<dynamic> get dusKaDumBets => _dusKaDumBets;

  List<dynamic> _dusKaDumLastBets = [];
  List<dynamic> get dusKaDumLastBets => _dusKaDumLastBets;

  int _timerBetTime = 0;
  int _timerStatus = 0;
  int totalBetAmount = 0;
  int get timerBetTime => _timerBetTime;
  int get timerStatus => _timerStatus;

  void setSocketTimeAndStatus(int betTime, int status) {
    _timerBetTime = betTime;
    _timerStatus = status;
    notifyListeners();
  }

  double get playBetAmount {
    return _dusKaDumBets.fold(0.0, (sum, item) => sum + (item['amount'] ?? 0));
  }

  setLastBetData() {
    _dusKaDumLastBets = List.from(_dusKaDumBets);
    _dusKaDumBets = [];
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

  addBetOnNumber(int number) {
    if (!isPlayAllowed()) return;
    if (_showBettingTime) {
      return;
    }
    if (_dusKaDumBets.isEmpty) {
      _dusKaDumBets.add({'amount': _selectedChip, 'game_id': number});
    } else if (_dusKaDumBets.any((item) => item['game_id'] == number)) {
      _dusKaDumBets.firstWhere((item) => item['game_id'] == number)['amount'] +=
          _selectedChip;
    } else {
      _dusKaDumBets.add({'amount': _selectedChip, 'game_id': number});
    }
    debugPrint("user applied bets: $_dusKaDumBets");
    notifyListeners();
  }

  List<String> rowBetList = [
    Assets.lucky16GreenA,
    Assets.lucky16GreenK,
    Assets.lucky16GreenQ,
    Assets.lucky16GreenJ,
  ];

  void addRowBet(context, int rowIndex) {
    if (!isPlayAllowed()) return;
    if (resetOne == false) {
      final profileViewModel = Provider.of<ProfileViewModel>(
        context,
        listen: false,
      );
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
        case 3:
          cardIds = [13, 14, 15, 16];
          break;
      }

      int totalRequiredBalance = cardIds.length * selectedChip;

      if (totalRequiredBalance > profileViewModel.balance) {
        setMessage('INSUFFICIENT BALANCE');
        return;
      }

      for (var id in cardIds) {
        var existingBet = dusKaDumBets.firstWhere(
          (bet) => bet['game_id'] == id,
          orElse: () => <String, int>{},
        );

        if (existingBet.isNotEmpty) {
          existingBet['amount'] = (existingBet['amount'] ?? 0) + selectedChip;
        } else {
          dusKaDumBets.add({'game_id': id, 'amount': selectedChip});
        }
      }

      totalBetAmount += totalRequiredBalance;
      profileViewModel.deductBalance(totalRequiredBalance);
      addRowBetList(rowIndex);
      notifyListeners();
    }
  }

  dynamic getBetDataForNumber(int number) {
    return _dusKaDumBets.where((item) => item['game_id'] == number).firstOrNull;
  }

  List<Map<String, int>> tapedRowList = [];
  List<Map<String, int>> tapedRowTrack = [];

  void addRowBetList(int index) {
    final existIndex = tapedRowList.indexWhere((e) => e["index"] == index);
    if (existIndex != -1) {
      tapedRowList[existIndex]["amount"] =
          tapedRowList[existIndex]["amount"]! + selectedChip;
    } else {
      tapedRowList.add({"index": index, "amount": selectedChip});
    }
    tapedRowTrack.add({"index": index, "amount": selectedChip});
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
          tapedColumnList[existIndex]["amount"]! + selectedChip;
    } else {
      tapedColumnList.add({"index": index, "amount": selectedChip});
    }
    tapedColumnTrack.add({"index": index, "amount": selectedChip});
    notifyListeners();
  }

  String? getJackpotForIndex(int jackpot) {
    final jackpotModel = jackpotList.firstWhere(
      (e) => e.id == jackpot,
      orElse: () => JackpotModel(img: '', id: 1),
    );
    return jackpotModel.id == 1 ? null : jackpotModel.img;
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
  getJokerJackPot(int jackPot, BuildContext context) {
    final jackpotModel = jackpotList.firstWhere(
          (e) => e.id == jackPot,
      orElse: () => JackpotModel(img: '', id: 1),
    );
    if (jackpotModel.id > 1) {
      AudioController().playSound('beep');
      showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child:  Container(
              height:Sizes.screenWidth / 3,
              width:Sizes.screenWidth / 3,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage('assets/jackpot/joker.gif'),fit: BoxFit.contain)
              ),

            ),
          );
        },
      );
      Future.delayed(Duration(seconds: 2,), () {
        Navigator.pop(context);
      });
    }
  }

  doubleUpBet() {
    for (int i = 0; i < _dusKaDumBets.length; i++) {
      _dusKaDumBets[i]['amount'] *= 2;
    }
    notifyListeners();
  }

  clearBet() {
    _dusKaDumBets = [];
    _dusKaDumLastBets = [];
    notifyListeners();
  }

  bool _showBettingTime = false;
  bool get showBettingTime => _showBettingTime;

  void setBettingTime(bool val) {
    _showBettingTime = val;
    notifyListeners();
  }

  rebate() {
    if (_dusKaDumLastBets.isNotEmpty) {
      _dusKaDumBets = List.from(_dusKaDumLastBets);
      notifyListeners();
    } else {
      debugPrint('there is no bet found for rebate');
    }
  }

  bool _resetOne = false;
  bool get resetOne => _resetOne;
  void setResetOne(bool val) {
    _resetOne = val;
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

  void addColumnBet(context, int columnIndex) {
    if (!isPlayAllowed()) return;
    if (resetOne == false) {
      final profileViewModel = Provider.of<ProfileViewModel>(
        context,
        listen: false,
      );
      List<int> cardIds = [];

      switch (columnIndex) {
        case 0:
          cardIds = [1, 5, 9, 13];
          break;
        case 1:
          cardIds = [2, 6, 10, 14];
          break;
        case 2:
          cardIds = [3, 7, 11, 15];
          break;
        case 3:
          cardIds = [4, 8, 12, 16];
          break;
      }

      int totalRequiredBalance = cardIds.length * selectedChip;

      if (totalRequiredBalance > profileViewModel.balance) {
        setMessage('INSUFFICIENT BALANCE');
        return;
      }

      for (var id in cardIds) {
        var existingBet = dusKaDumBets.firstWhere(
          (bet) => bet['game_id'] == id,
          orElse: () => <String, int>{},
        );

        if (existingBet.isNotEmpty) {
          existingBet['amount'] = (existingBet['amount'] ?? 0) + selectedChip;
        } else {
          dusKaDumBets.add({'game_id': id, 'amount': selectedChip});
        }
      }

      totalBetAmount += totalRequiredBalance;
      profileViewModel.deductBalance(totalRequiredBalance);
      addColumnBetList(columnIndex);
      notifyListeners();
    }
  }

  bool _resultShowTime = false;
  bool get resultShowTime => _resultShowTime;
  void setResultShowTime(bool val) {
    _resultShowTime = val;
    notifyListeners();
  }

  late IO.Socket _socket;

  void connectToServer(context) async {
    _socket = IO.io(
      DusKaDumApiUrl.timerDusKaDumUrl,
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
    _socket.on(DusKaDumApiUrl.dusKaDumTimerEvent, (timerData) async {
      final receiveData = jsonDecode(timerData);
      setSocketTimeAndStatus(
        receiveData['timerBetTime'],
        receiveData['timerStatus'],
      );
      if (receiveData['timerStatus'] == 1 &&
          receiveData['timerBetTime'] == 179) {
        Provider.of<DusKaDumResultViewModel>(
          context,
          listen: false,
        ).dusKaDumResultApi(context);
        setBettingTime(false);
      }
      if (receiveData['timerStatus'] == 1 &&
          receiveData['timerBetTime'] == 178) {
        setMessage('PLACE YOUR CHIPS');
        setBettingTime(false);
      }
      // bet api
      if (receiveData['timerStatus'] == 1 &&
          receiveData['timerBetTime'] == 11) {
        AudioController().playSound('no_more_bet');
      }
      if (receiveData['timerStatus'] == 1 &&
          receiveData['timerBetTime'] == 10) {
        setResultShowTime(true);
        setBettingTime(true);
        setMessage('NO MORE PLAY');
      }
      // start wheel
      if (receiveData['timerStatus'] == 2 &&
          receiveData['timerBetTime'] == 10) {
        dusKaDumBets.clear();
        totalBetAmount = 0;
        tapedRowList.clear();
        tapedColumnList.clear();
        tapedRowTrack.clear();
        tapedColumnTrack.clear();
      }
    });
    _socket.connect();
  }

  void disConnectToServer(context) async {
    _socket.disconnect();
    _socket.clearListeners();
    _socket.close();
    // _soundController.dispose();
    if (kDebugMode) {
      print('SOCKET DISCONNECT');
    }
  }
}
