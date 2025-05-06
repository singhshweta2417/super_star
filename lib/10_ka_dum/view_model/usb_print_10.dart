import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:super_star/10_ka_dum/view_model/print_view_10_model.dart';
import 'package:super_star/main.dart';
import 'package:thermal_printer/esc_pos_utils_platform/esc_pos_utils_platform.dart';
import 'package:thermal_printer/thermal_printer.dart';
import 'package:image/image.dart' as img;
import '../../spin_to_win/view_model/profile_view_model.dart';
import '../controller/dus_ka_dum_controller.dart';

class BluetoothPrinter {
  int? id;
  String? deviceName;
  String? address;
  String? port;
  String? vendorId;
  String? productId;
  bool? isBle;

  PrinterType typePrinter;
  bool? state;

  BluetoothPrinter({
    this.deviceName,
    this.address,
    this.port,
    this.state,
    this.vendorId,
    this.productId,
    this.typePrinter = PrinterType.bluetooth,
    this.isBle = false,
  });
}

class UsbPrintDusViewModel extends ChangeNotifier {
  final _defaultPrinterType = PrinterType.usb;
  StreamSubscription<USBStatus>? _subscriptionUsbStatus;
  StreamSubscription<PrinterDevice>? _subscription;
  var printerManager = PrinterManager.instance;
  bool _isConnected = false;
  var devices = <BluetoothPrinter>[];
  final bool _isBle = false;
  final _reconnect = false;
  BluetoothPrinter? selectedPrinter;
  List<int>? pendingTask;
  final BTStatus _currentStatus = BTStatus.none;

  Future<img.Image?> loadCardAssetImageAsRaster(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      final img.Image? image = img.decodeImage(bytes);

      if (image == null) return null;

      // Resize and convert to grayscale for thermal printer
      final img.Image resized = img.copyResize(image, width: 50);
      final img.Image grayscale = img.grayscale(resized);

      return grayscale;
    } catch (e) {
      debugPrint('Failed to load image: $e');
      return null;
    }
  }


  Future<void> scan(context) async {
    devices.clear();
    _subscription = printerManager
        .discovery(type: _defaultPrinterType, isBle: _isBle)
        .listen((device) {
      devices.add(
        BluetoothPrinter(
          deviceName: device.name,
          address: device.address,
          isBle: _isBle,
          vendorId: device.vendorId,
          productId: device.productId,
          typePrinter: _defaultPrinterType,
        ),
      );
      notifyListeners();
    });
    await Future.delayed(Duration(seconds: 2));
    if (devices.isEmpty || selectedPrinter != null) return;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Dialog(
          child: Container(
            width: screenWidth / 3,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Text(
                  "Available printers",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Select 1 of them to continue",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 15),
                Column(
                  children: List.generate(devices.length, (i) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(devices[i].deviceName ?? ""),
                        Checkbox(
                          value: false,
                          onChanged: (v) {
                            if (v!) {
                              _selectDevice(devices[i]);
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> createAndPrintTicket(
      dynamic gameData,
      BuildContext context,
      ) async
  {
    final l16c = Provider.of<DusKaDumController>(context, listen: false);
    Provider.of<Printing10Controller>(
      context,
      listen: false,
    ).saveReceiptAsPdf(gameData, context);
    final profileViewModel = Provider.of<ProfileViewModel>(
      context,
      listen: false,
    );

    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    final totalAmount = l16c.addDusKDBetsPrinting.fold<int>(
      0,
          (sum, item) => sum + (item["amount"] as int),
    );
    final getDrawTime = l16c.nextDrawTimeFormatted;

    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += generator.text(
      'SUPER STAR DUS KA DUM LIVE',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    );
    bytes += generator.hr();

    bytes += _buildReceiptRow(generator, 'Game Name', 'Dus Ka Dum');
    bytes += _buildReceiptRow(
      generator,
      'Terminal ID',
      profileViewModel.userName.toString(),
    );
    bytes += _buildReceiptRow(
      generator,
      'Game ID',
      gameData["period_no"].toString(),
    );
    bytes += _buildReceiptRow(
      generator,
      'Ticket ID',
      gameData["ticket_id"].toString(),
    );
    bytes += _buildReceiptRow(generator, 'Draw Time', getDrawTime);
    bytes += _buildReceiptRow(
      generator,
      'Total Points',
      totalAmount.toString(),
    );
    bytes += _buildReceiptRow(
      generator,
      'Ticket Time',
      DateFormat(
        'dd-MM-yyyy hh:mm a',
      ).format(DateTime.parse(gameData["ticket_time"].toString())),
    );
    bytes += generator.hr();

    // Header row for items
    bytes += generator.row([
      PosColumn(
        text: 'Items',
        width: 3,
        styles: PosStyles(bold: true, align: PosAlign.center),
      ),
      PosColumn(
        text: 'Point',
        width: 3,
        styles: PosStyles(bold: true, align: PosAlign.center),
      ),
      PosColumn(
        text: 'Items',
        width: 3,
        styles: PosStyles(bold: true, align: PosAlign.center),
      ),
      PosColumn(
        text: 'Point',
        width: 3,
        styles: PosStyles(bold: true, align: PosAlign.center),
      ),
    ]);
    bytes += generator.hr();
    final bets = l16c.addDusKDBetsPrinting;
    for (int i = 0; i < (bets.length / 2).ceil(); i++) {

      int firstIndex = i * 2;

      int secondIndex = firstIndex + 1;

      String firstNumber = bets[firstIndex]["game_id"].toString();
      String firstAmount = bets[firstIndex]["amount"].toString();

      String secondNumber = "";
      String secondAmount = "";

      if (secondIndex < bets.length) {
        secondNumber = bets[secondIndex]["game_id"].toString();
        secondAmount = bets[secondIndex]["amount"].toString();
      }

      bytes += generator.row([
        PosColumn(
          text: firstNumber,
          width: 3,
          styles: PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: firstAmount,
          width: 3,
          styles: PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: secondNumber,
          width: 3,
          styles: PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: secondAmount,
          width: 3,
          styles: PosStyles(align: PosAlign.center),
        ),
      ]);
    }
    bytes += generator.hr();
    final ticketId = gameData["ticket_id"].toString();
    final barcodeData = ticketId.split('').map(int.parse).toList();
    bytes += generator.barcode(Barcode.code39(barcodeData), height: 100);

    _printEscPos(bytes, generator);
  }

  void _selectDevice(BluetoothPrinter device) async {
    if (selectedPrinter != null) {
      if ((device.address != selectedPrinter!.address) ||
          (device.typePrinter == PrinterType.usb &&
              selectedPrinter!.vendorId != device.vendorId)) {
        await PrinterManager.instance.disconnect(
          type: selectedPrinter!.typePrinter,
        );
      }
    }
    selectedPrinter = device;
    notifyListeners();
    _connectDevice();
  }

  _connectDevice() async {
    _isConnected = false;
    if (selectedPrinter == null) return;
    switch (selectedPrinter!.typePrinter) {
      case PrinterType.usb:
        await printerManager.connect(
          type: selectedPrinter!.typePrinter,
          model: UsbPrinterInput(
            name: selectedPrinter!.deviceName,
            productId: selectedPrinter!.productId,
            vendorId: selectedPrinter!.vendorId,
          ),
        );
        _isConnected = true;
        break;
      case PrinterType.bluetooth:
        await printerManager.connect(
          type: selectedPrinter!.typePrinter,
          model: BluetoothPrinterInput(
            name: selectedPrinter!.deviceName,
            address: selectedPrinter!.address!,
            isBle: selectedPrinter!.isBle ?? false,
            autoConnect: _reconnect,
          ),
        );
        break;
      case PrinterType.network:
        await printerManager.connect(
          type: selectedPrinter!.typePrinter,
          model: TcpPrinterInput(ipAddress: selectedPrinter!.address!),
        );
        _isConnected = true;
        break;
    }
    notifyListeners();
  }

  String getNextDrawTimeFormatted(int timerBetTime) {
    DateTime nextDrawTime = DateTime.now().add(
      Duration(seconds: timerBetTime + 10),
    );
    return DateFormat('hh:mm a').format(nextDrawTime);
  }

  List<int> _buildReceiptRow(Generator generator, String label, String value) {
    return generator.row([
      PosColumn(
        text: label,
        width: 5,
        // styles: const PosStyles(align: PosAlign.left),//PosAlign.left
      ),
      PosColumn(
        text: value,
        width: 7,
        // styles: const PosStyles(align: PosAlign.right), // styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
  }

  void _printEscPos(List<int> bytes, Generator generator) async {
    var connectedTCP = false;
    if (selectedPrinter == null) return;
    var bluetoothPrinter = selectedPrinter!;

    switch (bluetoothPrinter.typePrinter) {
      case PrinterType.usb:
        bytes += generator.cut();
        await printerManager.connect(
          type: bluetoothPrinter.typePrinter,
          model: UsbPrinterInput(
            name: bluetoothPrinter.deviceName,
            productId: bluetoothPrinter.productId,
            vendorId: bluetoothPrinter.vendorId,
          ),
        );
        pendingTask = null;
        break;
      case PrinterType.bluetooth:
        bytes += generator.cut();
        await printerManager.connect(
          type: bluetoothPrinter.typePrinter,
          model: BluetoothPrinterInput(
            name: bluetoothPrinter.deviceName,
            address: bluetoothPrinter.address!,
            isBle: bluetoothPrinter.isBle ?? false,
            autoConnect: _reconnect,
          ),
        );
        pendingTask = null;
        if (Platform.isAndroid) pendingTask = bytes;
        break;
      case PrinterType.network:
        bytes += generator.feed(2);
        bytes += generator.cut();
        connectedTCP = await printerManager.connect(
          type: bluetoothPrinter.typePrinter,
          model: TcpPrinterInput(ipAddress: bluetoothPrinter.address!),
        );
        if (!connectedTCP) print(' --- please review your connection ---');
        break;
    }
    if (bluetoothPrinter.typePrinter == PrinterType.bluetooth &&
        Platform.isAndroid) {
      if (_currentStatus == BTStatus.connected) {
        printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
        pendingTask = null;
      }
    } else {
      printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
    }
  }

}
