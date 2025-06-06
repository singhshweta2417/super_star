import 'dart:async';
import 'dart:developer';
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
import 'package:super_star/lucky_card_16/controller/lucky_16_controller.dart';
import 'package:super_star/lucky_card_16/view_model/usb_print.dart';
import '../../utils/utils.dart';


class PrintingController extends ChangeNotifier {
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
    setDownloading(true);
    final l16c = Provider.of<Lucky16Controller>(context, listen: false);
    l16c.clearBetPrinting();
    l16c.setBetPrinting(betData);
    l16c.clearBetAfterPrint();
    Provider.of<UsbPrintViewModel>(
      context,
      listen: false,
    ).createAndPrintTicket(gameData, context,);
    // Provider.of<Lucky16BetViewModel>(context, listen: false).setLoading(false);

    debugPrint("betData length 2: ${l16c.addLucky16BetsPrinting.length}");
    debugPrint("here we got the pet printing data: ${ l16c.addLucky16BetsPrinting}");
    // final List<BluetoothInfo> availablePrinters =
    //     await PrintBluetoothThermal.pairedBluetooths;
    // if (availablePrinters.isNotEmpty) {
    //   connect(availablePrinters[0].macAdress, gameData, context);
    // }
    // else {
    //   Utils.show("Printer not found, PDF download proceeded.", context);
    //   Provider.of<UsbPrintViewModel>(
    //     context,
    //     listen: false,
    //   ).createAndPrintTicket(gameData, context,);
    // }

    // Navigator.pop(context);
  }

  Future<void> connect(String mac, dynamic gameData, context) async {
    final l16c = Provider.of<Lucky16Controller>(context, listen: false);

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
      ) async {
    final l16c = Provider.of<Lucky16Controller>(context, listen: false);
    final pdf = pw.Document();

    final totalAmount = l16c.addLucky16BetsPrinting.fold<int>(
      0,
          (sum, item) {
        print("print item : $item");
        return sum + (item['amount'] as int);
      },
    );

    final getDrawTime = getNextDrawTimeFormatted(l16c.timerBetTime);

    final List<pw.TableRow> tableRows = [];

    final ticketId = gameData["ticket_id"].toString();

    final barcode = barcode_lib.Barcode.code128();
    final barcodeWidget = pw.BarcodeWidget(
      barcode: barcode,
      data: ticketId,
      width: 150,
      height: 60,
      drawText: false,
    );
    for (int i = 0; i < (l16c.addLucky16BetsPrinting.length / 2).ceil(); i++) {
      int firstIndex = i * 2;
      int secondIndex = firstIndex + 1;

      final firstCard = l16c.cardList.firstWhere(
            (card) => card.id == l16c.addLucky16BetsPrinting[firstIndex]['game_id'],
      );
      final firstImageBytes = await loadCardAssetImage(firstCard.icon!);
      final firstImage = pw.MemoryImage(firstImageBytes);

      pw.MemoryImage? secondImage;
      String? secondAmount;

      if (secondIndex < l16c.addLucky16BetsPrinting.length) {
        final secondCard = l16c.cardList.firstWhere(
              (card) => card.id == l16c.addLucky16BetsPrinting[secondIndex]['game_id'],
        );
        final secondImageBytes = await loadCardAssetImage(secondCard.icon!);
        secondImage = pw.MemoryImage(secondImageBytes);
        secondAmount = l16c.addLucky16BetsPrinting[secondIndex]['amount'].toString();
      }

      tableRows.add(
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Image(firstImage, height: 15, width: 15),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(
                l16c.addLucky16BetsPrinting[firstIndex]['amount'].toString(),
              ),
            ),
            secondImage != null
                ? pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Image(secondImage, height: 15, width: 15),
            )
                : pw.SizedBox(),
            secondAmount != null
                ? pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(secondAmount),
            )
                : pw.SizedBox(),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.Page(
        build:
            (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "SUPER STAR 16 CARDS LIVE",
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            _buildPdfRow(pdf, 'Game Name', ':', 'Lucky 16 game'),
            _buildPdfRow(
              pdf,
              'Game ID',
              ':',
              gameData["period_no"].toString(),
            ),
            _buildPdfRow(
              pdf,
              'Ticket ID',
              ':',
              gameData["ticket_id"].toString(),
            ),
            _buildPdfRow(pdf, 'Draw Time', ':', getDrawTime),
            _buildPdfRow(
              pdf,
              'Ticket Time',
              ':',
              gameData["ticket_time"].toString(),
            ),
            _buildPdfRow(pdf, 'Total Points', ':', "$totalAmount"),
            pw.SizedBox(height: 10),
            pw.Table(
              tableWidth: pw.TableWidth.min,
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        'Item',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        'Point',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        'Item',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        'Point',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...tableRows,
              ],
            ),
            barcodeWidget,
          ],
        ),
      ),
    );

    Directory? dir;
    if (Platform.isAndroid) {
      dir = Directory("/storage/emulated/0/Download");
    } else if (Platform.isWindows)
    {
      dir = await getDownloadsDirectory();
    } else if (Platform.isMacOS || Platform.isLinux)
    {
      dir = await getApplicationDocumentsDirectory();
    } else
    {
      throw UnsupportedError("Unsupported Platform");
    }

    if (!await dir!.exists()) {
      await dir.create(recursive: true);
    }

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = "${dir.path}/$fileName.pdf";
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    Utils.show(
      "PDF generated successfully, as $fileName.pdf - location: ${dir.path}",
      context,
    );
    setDownloading(false);
    log("PDF Saved at: $path");
  }

  Future<void> printReceipt(dynamic gameData, BuildContext context) async {
    final l16c = Provider.of<Lucky16Controller>(context, listen: false);
    bool isConnected = await PrintBluetoothThermal.connectionStatus;
    if (!isConnected) {
      debugPrint("Printer is not connected.");
      return;
    }

    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    final totalAmount = l16c.addLucky16Bets.fold(
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
      }) {
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

// Future<void> saveReceiptAsPdf(dynamic gameData, context) async {
//   final pdf = pw.Document();
//
//   final totalAmount = addLucky16Bets.fold(
//     0,
//     (sum, item) => sum + (item["amount"] as int),
//   );
//   final getDrawTime = getNextDrawTimeFormatted();
//
//   final barcodeData =
//       'GameID:${gameData["period_no"]},TicketID:${gameData["ticket_id"]}';
//   final imageBytes = await loadAssetImage();
//   pdf.addPage(
//     pw.Page(
//       build:
//           (pw.Context context) => pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text(
//                 "LUCKY 16 CARDS LIVE",
//                 style: pw.TextStyle(
//                   fontSize: 16,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//               _buildPdfRow(pdf, 'Game Name', ':', 'Lucky 16 game'),
//               _buildPdfRow(
//                 pdf,
//                 'Game ID',
//                 ':',
//                 gameData["period_no"].toString(),
//               ),
//               _buildPdfRow(
//                 pdf,
//                 'Ticket ID',
//                 ':',
//                 gameData["ticket_id"].toString(),
//               ),
//               _buildPdfRow(pdf, 'Draw Time', ':', getDrawTime),
//               _buildPdfRow(
//                 pdf,
//                 'Ticket Time',
//                 ':',
//                 gameData["ticket_time"].toString(),
//               ),
//               _buildPdfRow(pdf, 'Total Points', ':', "$totalAmount"),
//               pw.SizedBox(height: 10),
//               pw.Table(
//                 tableWidth: pw.TableWidth.min,
//                 children: [
//                   pw.TableRow(
//                     children: [
//                       pw.Padding(
//                         padding: const pw.EdgeInsets.all(8.0),
//                         child: pw.Text(
//                           'Item',
//                           style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                         ),
//                       ),
//                       pw.Padding(
//                         padding: const pw.EdgeInsets.all(8.0),
//                         child: pw.Text(
//                           'Point',
//                           style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                         ),
//                       ),
//                       pw.Padding(
//                         padding: const pw.EdgeInsets.all(8.0),
//                         child: pw.Text(
//                           'Item',
//                           style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                         ),
//                       ),
//                       pw.Padding(
//                         padding: const pw.EdgeInsets.all(8.0),
//                         child: pw.Text(
//                           'Point',
//                           style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                   ),
//                   // Data Rows
//                   ...List.generate((addLucky16Bets.length / 2).ceil(), (
//                     index,
//                   ) {
//                     int firstIndex = index * 2;
//                     int secondIndex = firstIndex + 1;
//                     return pw.TableRow(
//                       children: [
//                         pw.Padding(
//                           padding: const pw.EdgeInsets.all(8.0),
//                           child: pw.Text(
//                             addLucky16Bets[firstIndex]['game_id'].toString(),
//                           ),
//                         ),
//                         // First Point Column
//                         pw.Padding(
//                           padding: const pw.EdgeInsets.all(8.0),
//                           child: pw.Text(
//                             addLucky16Bets[firstIndex]['amount'].toString(),
//                           ),
//                         ),
//                         if (secondIndex < addLucky16Bets.length)
//                           pw.Padding(
//                             padding: const pw.EdgeInsets.all(8.0),
//                             child: pw.Text(
//                               addLucky16Bets[secondIndex]['game_id']
//                                   .toString(),
//                             ),
//                           ),
//                         if (secondIndex < addLucky16Bets.length)
//                           pw.Padding(
//                             padding: const pw.EdgeInsets.all(8.0),
//                             child: pw.Text(
//                               addLucky16Bets[secondIndex]['amount']
//                                   .toString(),
//                             ),
//                           ),
//                       ],
//                     );
//                   }),
//                 ],
//               ),
//             ],
//           ),
//     ),
//   );
//
//   Directory? dir;
//   if (Platform.isAndroid) {
//     dir = Directory(
//       "/storage/emulated/0/Download",
//     ); // Android Download folder
//   } else if (Platform.isWindows) {
//     dir = await getDownloadsDirectory();
//   } else if (Platform.isMacOS || Platform.isLinux) {
//     dir = await getApplicationDocumentsDirectory();
//   } else {
//     throw UnsupportedError("Unsupported Platform");
//   }
//
//   // Ensure directory exists
//   if (!await dir!.exists()) {
//     await dir.create(recursive: true);
//   }
//   final fileName = DateTime.now().millisecondsSinceEpoch.toString();
//   String path = "${dir.path}/$fileName.pdf";
//   final file = File(path);
//   await file.writeAsBytes(await pdf.save());
//   Utils.show(
//     "PDF generated successfully, as $fileName.png - location:${dir.path}",
//     context,
//   );
//   log("PDF Saved at: ${file.path}");
// }

//
// pw.Document? drawnReceipt;
// Future<pw.Document> drawReceiptPdf(
//     dynamic gameData,
//     BuildContext context,
//     ) async {
//   print("recipt drawn fun invoked");
//   final l16c = Provider.of<Lucky16Controller>(context, listen: false);
//   final pdf = pw.Document();
//
//   final totalAmount = l16c.addLucky16Bets.fold<int>(
//     0,
//         (sum, item) => sum + (item['amount'] as int),
//   );
//
//   final getDrawTime = getNextDrawTimeFormatted(l16c.timerBetTime);
//   final ticketId = gameData["ticket_id"].toString();
//   final barcode = barcode_lib.Barcode.code128();
//
//   final barcodeWidget = pw.BarcodeWidget(
//     barcode: barcode,
//     data: ticketId,
//     width: 150,
//     height: 60,
//     drawText: false,
//   );
//
//   final List<pw.TableRow> tableRows = [];
//
//   for (int i = 0; i < (l16c.addLucky16Bets.length / 2).ceil(); i++) {
//     int firstIndex = i * 2;
//     int secondIndex = firstIndex + 1;
//
//     final firstCard = l16c.cardList.firstWhere(
//           (card) => card.id == l16c.addLucky16Bets[firstIndex]['game_id'],
//     );
//     final firstImageBytes = await loadCardAssetImage(firstCard.icon!);
//     final firstImage = pw.MemoryImage(firstImageBytes);
//
//     pw.MemoryImage? secondImage;
//     String? secondAmount;
//
//     if (secondIndex < l16c.addLucky16Bets.length) {
//       final secondCard = l16c.cardList.firstWhere(
//             (card) => card.id == l16c.addLucky16Bets[secondIndex]['game_id'],
//       );
//       final secondImageBytes = await loadCardAssetImage(secondCard.icon!);
//       secondImage = pw.MemoryImage(secondImageBytes);
//       secondAmount = l16c.addLucky16Bets[secondIndex]['amount'].toString();
//     }
//
//     tableRows.add(
//       pw.TableRow(
//         children: [
//           pw.Padding(
//             padding: const pw.EdgeInsets.all(8.0),
//             child: pw.Image(firstImage, height: 15, width: 15),
//           ),
//           pw.Padding(
//             padding: const pw.EdgeInsets.all(8.0),
//             child: pw.Text(
//               l16c.addLucky16Bets[firstIndex]['amount'].toString(),
//             ),
//           ),
//           secondImage != null
//               ? pw.Padding(
//             padding: const pw.EdgeInsets.all(8.0),
//             child: pw.Image(secondImage, height: 15, width: 15),
//           )
//               : pw.SizedBox(),
//           secondAmount != null
//               ? pw.Padding(
//             padding: const pw.EdgeInsets.all(8.0),
//             child: pw.Text(secondAmount),
//           )
//               : pw.SizedBox(),
//         ],
//       ),
//     );
//   }
//
//   pdf.addPage(
//     pw.Page(
//       build:
//           (pw.Context context) => pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             "LUCKY 16 CARDS LIVE",
//             style: pw.TextStyle(
//               fontSize: 16,
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//           _buildPdfRow(pdf, 'Game Name', ':', 'Lucky 16 game'),
//           _buildPdfRow(
//             pdf,
//             'Game ID',
//             ':',
//             gameData["period_no"].toString(),
//           ),
//           _buildPdfRow(
//             pdf,
//             'Ticket ID',
//             ':',
//             gameData["ticket_id"].toString(),
//           ),
//           _buildPdfRow(pdf, 'Draw Time', ':', getDrawTime),
//           _buildPdfRow(
//             pdf,
//             'Ticket Time',
//             ':',
//             gameData["ticket_time"].toString(),
//           ),
//           _buildPdfRow(pdf, 'Total Points', ':', "$totalAmount"),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             tableWidth: pw.TableWidth.min,
//             children: [
//               pw.TableRow(
//                 children: [
//                   pw.Padding(
//                     padding: const pw.EdgeInsets.all(8.0),
//                     child: pw.Text(
//                       'Item',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                     ),
//                   ),
//                   pw.Padding(
//                     padding: const pw.EdgeInsets.all(8.0),
//                     child: pw.Text(
//                       'Point',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                     ),
//                   ),
//                   pw.Padding(
//                     padding: const pw.EdgeInsets.all(8.0),
//                     child: pw.Text(
//                       'Item',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                     ),
//                   ),
//                   pw.Padding(
//                     padding: const pw.EdgeInsets.all(8.0),
//                     child: pw.Text(
//                       'Point',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//               ...tableRows,
//             ],
//           ),
//           pw.SizedBox(height: 10),
//           barcodeWidget,
//         ],
//       ),
//     ),
//   );
//   print("pdf generated successfully");
//   print(pdf.document.documentID);
//   drawnReceipt = pdf;
//   return pdf;
// }
//
// Future<void> downloadReceiptPdf(BuildContext context) async {
//   Directory? dir;
//   pw.Document pdf = drawnReceipt!;
//   if (Platform.isAndroid) {
//     dir = Directory("/storage/emulated/0/Download");
//   } else if (Platform.isWindows) {
//     dir = await getDownloadsDirectory();
//   } else if (Platform.isMacOS || Platform.isLinux) {
//     dir = await getApplicationDocumentsDirectory();
//   } else {
//     throw UnsupportedError("Unsupported Platform");
//   }
//
//   if (!await dir!.exists()) {
//     await dir.create(recursive: true);
//   }
//
//   final fileName = DateTime.now().millisecondsSinceEpoch.toString();
//   final path = "${dir.path}/$fileName.pdf";
//   final file = File(path);
//
//   await file.writeAsBytes(await pdf.save());
//
//   Utils.show(
//     "PDF generated successfully as $fileName.pdf\nLocation: ${dir.path}",
//     context,
//   );
//
//   log("PDF Saved at: $path");
// }
