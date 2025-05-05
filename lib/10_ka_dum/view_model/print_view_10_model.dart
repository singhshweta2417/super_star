import 'dart:async';
import 'dart:io';

import 'package:barcode/barcode.dart' as barcode_lib;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import 'package:super_star/10_ka_dum/view_model/usb_print_10.dart';
import '../../utils/utils.dart';
import '../controller/dus_ka_dum_controller.dart';

class Printing10Controller extends ChangeNotifier {
  StreamSubscription<List<Printer>>? _devicesStreamSubscription;
  final _flutterThermalPrinterPlugin = FlutterThermalPrinter.instance;
  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;
  setDownloading(bool val) {
    _isDownloading = val;
    notifyListeners();
  }

  String getNextDrawTimeFormatted(int timerBetTime) {
    DateTime nextDrawTime = DateTime.now().add(
      Duration(seconds: timerBetTime + 10),
    );
    return DateFormat('hh:mm a').format(nextDrawTime);
  }

  Future<Uint8List> loadCardAssetImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  Future<void> handleReceiptPrinting(dynamic gameData,List<dynamic> betData,context) async {
    print('1ss$gameData');
    print('2ndsss$betData');
    setDownloading(true);
    final l16c = Provider.of<DusKaDumController>(context, listen: false);
    l16c.clearBetPrinting();
    l16c.setBetPrinting(betData);
    l16c.clearBetAfterPrint();
    Provider.of<UsbPrintDusViewModel>(
      context,
      listen: false,
    ).createAndPrintTicket(gameData, context,);

    debugPrint("betData length 2: ${l16c.addDusKDBetsPrinting.length}");
    debugPrint("here we got the pet printing data: ${ l16c.addDusKDBetsPrinting}");
  }

  Future<void> connect(String mac, dynamic gameData, context) async {
    final bool result = await PrintBluetoothThermal.connect(
      macPrinterAddress: mac,
    );
    debugPrint("state connected $result");
    if (result) {
      await printReceipt(gameData, context);
    } else {
      Utils.show(
        "Failed to connecting with printer, PDF download proceeded.",
        context,
      );
      await saveReceiptAsPdf(gameData, context,);
    }
  }

  Future<List<Printer>> getAvailablePrinters() async {
    List<Printer> printers = [];

    final Completer<List<Printer>> completer = Completer<List<Printer>>();

    _devicesStreamSubscription?.cancel();
    await _flutterThermalPrinterPlugin.getPrinters(
      connectionTypes: [ConnectionType.USB, ConnectionType.BLE],
    );

    _devicesStreamSubscription = _flutterThermalPrinterPlugin.devicesStream
        .listen((List<Printer> event) {
      printers =
          event
              .where(
                (printer) =>
            printer.name != null && printer.name!.isNotEmpty,
          )
              .toList();
      completer.complete(printers);
    });

    return completer.future;
  }

  Future<void> saveReceiptAsPdf(
      dynamic gameData,
      BuildContext context,
      ) async
  {
    final l16c = Provider.of<DusKaDumController>(context, listen: false);
    final pdf = pw.Document();

    final totalAmount = l16c.addDusKDBetsPrinting.fold<int>(
      0,
          (sum, item) => sum + (item['amount'] as int),
    );

    final getDrawTime = getNextDrawTimeFormatted(l16c.timerBetTime);
    final ticketId = gameData["ticket_id"].toString();

    final barcode = barcode_lib.Barcode.code128();
    final barcodeWidget = pw.BarcodeWidget(
      barcode: barcode,
      data: ticketId,
      width: 150,
      height: 60,
      drawText: false,
    );

    // Prepare table rows
    final List<pw.TableRow> tableRows = [];

    for (int i = 0; i < (l16c.addDusKDBetsPrinting.length / 2).ceil(); i++) {
      int firstIndex = i * 2;
      int secondIndex = firstIndex + 1;
      String firstNumber = l16c.addDusKDBetsPrinting[firstIndex]['game_id'].toString();
      String firstAmount = l16c.addDusKDBetsPrinting[firstIndex]['amount'].toString();
      String? secondNumber;
      String? secondAmount;
      if (secondIndex < l16c.addDusKDBetsPrinting.length) {
        secondNumber = l16c.addDusKDBetsPrinting[secondIndex]['game_id'].toString();
        secondAmount = l16c.addDusKDBetsPrinting[secondIndex]['amount'].toString();
      }

      tableRows.add(
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(firstNumber),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(firstAmount),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(secondNumber ?? ''),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(secondAmount ?? ''),
            ),
          ],),);
    }

    // Build PDF page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "SUPER STAR DUS KA DUM",
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            _buildPdfRow(pdf, 'Game Name', ':', 'Dus ka Dum'),
            _buildPdfRow(pdf, 'Game ID', ':', gameData["period_no"].toString()),
            _buildPdfRow(pdf, 'Ticket ID', ':', ticketId),
            _buildPdfRow(pdf, 'Draw Time', ':', getDrawTime),
            pw.SizedBox(height: 10),
            pw.Text("Your Numbers:"),
            pw.Table(
              border: pw.TableBorder.all(),
              children: tableRows,
            ),
            pw.SizedBox(height: 10),
            pw.Text("Total Amount: ₹$totalAmount"),
            pw.SizedBox(height: 10),
            pw.Text("Ticket Barcode:"),
            barcodeWidget,
          ],
        ),
      ),
    );
    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/ticket_$ticketId.pdf");
    await file.writeAsBytes(await pdf.save());

    Utils.show("PDF downloaded at ${file.path}", context);
    setDownloading(false);
  }


  Future<void> printReceipt(dynamic gameData, BuildContext context) async {
    final l16c = Provider.of<DusKaDumController>(context, listen: false);
    bool isConnected = await PrintBluetoothThermal.connectionStatus;
    if (!isConnected) {
      debugPrint("Printer is not connected.");
      return;
    }

    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    final totalAmount = l16c.dusKaDumBets.fold(
      0,
          (sum, item) => sum + (item["amount"] as int),
    );
    final getDrawTime = getNextDrawTimeFormatted(l16c.timerBetTime);
    List<int> bytes = [];

    bytes += generator.text(
      'Super Star',
      styles: PosStyles(bold: true, align: PosAlign.center),
    );
    bytes += generator.hr();

    // Add Game Details
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
    bytes += _buildReceiptRow(
      generator,
      'Ticket Time',
      gameData["ticket_time"].toString(),
    );
    bytes += _buildReceiptRow(generator, 'Draw Time', getDrawTime);
    bytes += _buildReceiptRow(
      generator,
      'Total Points',
      totalAmount.toString(),
    );

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(text: 'Game', width: 6, styles: PosStyles(bold: true)),
      PosColumn(text: 'Point', width: 6, styles: PosStyles(bold: true)),
    ]);

    for (var bet in gameData["bets"]) {
      print(gameData["bets"]);
      bytes += generator.row([
        PosColumn(text: bet['game_id'].toString(), width: 6),
        PosColumn(text: bet['amount'].toString(), width: 6),
      ]);
    }

    bytes += generator.feed(1);

    bytes += generator.barcode(Barcode.code128(gameData["bets"]));

    // Add QR Code
    bytes += generator.qrcode(gameData["ticket_id"].toString());

    bytes += generator.feed(2); // Space before cutting
    bytes += generator.cut(); // Cut the paper

    // Send Data to Printer
    bool success = await PrintBluetoothThermal.writeBytes(bytes);
    if (success) {
      debugPrint("Print successful");
    } else {
      debugPrint("Print failed");
    }
  }

  List<int> _buildReceiptRow(Generator generator, String title, String value) {
    return generator.row([
      PosColumn(text: title, width: 6, styles: PosStyles(bold: true)),
      PosColumn(text: ': $value', width: 6),
    ]);
  }

  pw.Widget _buildPdfRow(
      pw.Document pdf,
      String leftText,
      String text,
      String rightText, {
        bool isBold = false,
      })
  {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3.0),
      child: pw.Row(
        children: [
          pw.Text(
            leftText,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Text(
            text,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Text(
            rightText,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}


