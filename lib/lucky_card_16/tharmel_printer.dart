// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
// import 'package:flutter_thermal_printer/utils/printer.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:provider/provider.dart';
// import 'package:super_star/lucky_card_16/view_model/print_view_model.dart';
// import 'package:super_star/main.dart';
//
// import 'controller/lucky_16_controller.dart';
//
// class ThermalPrinter extends StatefulWidget {
//   const ThermalPrinter({super.key});
//
//   @override
//   State<ThermalPrinter> createState() => _ThermalPrinterState();
// }
//
// class _ThermalPrinterState extends State<ThermalPrinter> {
//   final _flutterThermalPrinterPlugin = FlutterThermalPrinter.instance;
//
//   String _ip = '192.168.0.100';
//   String _port = '9100';
//
//   List<Printer> printers = [];
//   Printer? selectedPrinter;
//   StreamSubscription<List<Printer>>? _devicesStreamSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       startScan();
//     });
//   }
//
//   // 🖨️ **Scan for Available Printers**
//   void startScan() async {
//     _devicesStreamSubscription?.cancel();
//     await _flutterThermalPrinterPlugin.getPrinters(
//       connectionTypes: [ConnectionType.USB, ConnectionType.BLE],
//     );
//
//     _devicesStreamSubscription = _flutterThermalPrinterPlugin.devicesStream
//         .listen((List<Printer> event) {
//           log("Printers Found: ${event.map((e) => e.name).toList()}");
//           setState(() {
//             printers =
//                 event
//                     .where(
//                       (printer) =>
//                           printer.name != null && printer.name!.isNotEmpty,
//                     )
//                     .toList();
//           });
//         });
//   }
//
//   void stopScan() {
//     _flutterThermalPrinterPlugin.stopScan();
//   }
//
//   // 🖨️ **Mock Printing (No Printer Needed)**
//   Future<void> mockPrint() async {
//     final bytes = await _generateReceipt();
//     log("Simulated Printing Data: $bytes");
//     log("Simulated Print Success!");
//   }
//
//   // 📜 **Generate Receipt for Testing**
//   Future<List<int>> _generateReceipt() async {
//     final profile = await CapabilityProfile.load();
//     final generator = Generator(PaperSize.mm80, profile);
//     List<int> bytes = [];
//
//     bytes += generator.text(
//       "Thermal Printer Test",
//       styles: const PosStyles(
//         bold: true,
//         height: PosTextSize.size3,
//         width: PosTextSize.size3,
//       ),
//     );
//     bytes += generator.cut();
//
//     log("Generated Print Data: $bytes");
//     return bytes;
//   }
//
//   // 🖼️ **Print Preview as a Widget**
//   // void showPrintPreview() {
//   //   showDialog(
//   //     context: context,
//   //     builder:
//   //         (context) => AlertDialog(
//   //           content: ReceiptWidget(printerType: '',),
//   //         ),
//   //   );
//   // }
//
//   // 📄 **Save as PDF (Virtual Print)**
//   Future<void> saveReceiptAsPdf() async {
//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         build:
//             (pw.Context context) =>
//                 pw.Center(child: pw.Text("Thermal Printer Test")),
//       ),
//     );
//     Directory dir = Directory("/storage/emulated/0/Download");
//     String path = "${dir.path}/receipt.pdf";
//     final file = File(path);
//
//     await file.writeAsBytes(await pdf.save());
//     log("PDF Saved at: ${file.path}");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Thermal Printer App'),
//           systemOverlayStyle: const SystemUiOverlayStyle(
//             statusBarColor: Colors.transparent,
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(20),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 // // 📡 **Network Printer Section**
//                 // Text(
//                 //   'NETWORK PRINTER',
//                 //   style: Theme.of(context).textTheme.titleLarge,
//                 // ),
//                 // const SizedBox(height: 12),
//                 // TextFormField(
//                 //   initialValue: _ip,
//                 //   decoration: const InputDecoration(
//                 //     labelText: 'Enter IP Address',
//                 //   ),
//                 //   onChanged: (value) => _ip = value,
//                 // ),
//                 // const SizedBox(height: 12),
//                 // TextFormField(
//                 //   initialValue: _port,
//                 //   decoration: const InputDecoration(labelText: 'Enter Port'),
//                 //   onChanged: (value) => _port = value,
//                 // ),
//                 // const SizedBox(height: 12),
//                 // ElevatedButton(
//                 //   onPressed: mockPrint,
//                 //   child: const Text('Simulate Print'),
//                 // ),
//                 // const Divider(),
//                 //
//                 // // 🖨️ **USB & BLE Printer Section**
//                 Text(
//                   'USB/BLE PRINTERS',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//                 const SizedBox(height: 22),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: startScan,
//                         child: const Text('Scan Printers'),
//                       ),
//                     ),
//                     const SizedBox(width: 22),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: stopScan,
//                         child: const Text('Stop Scan'),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//
//                 // 📜 **Print Preview & PDF Export**
//                 // Row(
//                 //   children: [
//                 //     Expanded(
//                 //       child: ElevatedButton(
//                 //         onPressed: showPrintPreview,
//                 //         child: const Text('Preview Receipt'),
//                 //       ),
//                 //     ),
//                 //     const SizedBox(width: 22),
//                 //     Expanded(
//                 //       child: ElevatedButton(
//                 //         onPressed: saveReceiptAsPdf,
//                 //         child: const Text('Save as PDF'),
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Widget receiptWidget(String printerType) {
//   //   List<Map<String, String>> ticketData = [
//   //     {'title': 'Game Name', 'value': 'Lucky 16 game'},
//   //     {'title': 'Game ID', 'value': 'Price'},
//   //     {'title': 'Ticket ID', 'value': '\$0.75'},
//   //     {'title': 'Draw Time', 'value': '\$2.25'},
//   //     {'title': 'Ticket Time', 'value': printerType},
//   //     {'title': 'Total Points', 'value': printerType},
//   //   ];
//   //
//   //   // final lucky16ResultViewModel = Provider.of<Lucky16ResultViewModel>(context);
//   //   return Consumer<Lucky16Controller>(
//   //     builder: (context, l16c, child) {
//   //       return SizedBox(
//   //         child: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             Text(
//   //               "LUCKY 16 CARDS LIVE",
//   //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//   //             ),
//   //             _buildReceiptRow('Game Name', ':', 'Lucky 16 game'),
//   //
//   //             _buildReceiptRow('Game ID', ':', 'Price'),
//   //
//   //             _buildReceiptRow('Ticket ID', ':', '\$0.75'),
//   //
//   //             _buildReceiptRow('Draw Time', ':', '\$2.25'),
//   //
//   //             _buildReceiptRow('Ticket Time', ':', printerType),
//   //
//   //             _buildReceiptRow('Total Points', ':', printerType),
//   //             Expanded(
//   //               child: GridView.builder(
//   //                 shrinkWrap: true,
//   //                 physics: NeverScrollableScrollPhysics(),
//   //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//   //                   crossAxisCount: 2, // Two columns
//   //                   childAspectRatio: 3,
//   //                   crossAxisSpacing: 8,
//   //                   mainAxisSpacing: 8,
//   //                 ),
//   //                 itemCount: ticketData.length,
//   //                 itemBuilder: (context, index) {
//   //                   return Container(
//   //                     padding: EdgeInsets.all(8),
//   //                     decoration: BoxDecoration(
//   //                       color: Colors.grey[200],
//   //                       borderRadius: BorderRadius.circular(8),
//   //                     ),
//   //                     child: Column(
//   //                       mainAxisAlignment: MainAxisAlignment.center,
//   //                       children: [
//   //                         Text(
//   //                           ticketData[index]['title']!,
//   //                           style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//   //                         ),
//   //                         SizedBox(height: 4),
//   //                         Text(
//   //                           ticketData[index]['value']!,
//   //                           style: TextStyle(fontSize: 14),
//   //                         ),
//   //                       ],
//   //                     ),
//   //                   );
//   //                 },
//   //               ),
//   //             ),
//   //
//   //           ],
//   //         ),
//   //
//   //       );
//   //     },
//   //   );
//   // }
//   // Widget receiptWidget(String printerType) {
//   //   // final lucky16BetViewModel = Provider.of<Lucky16BetViewModel>(context);
//   //   List ticketData = [
//   //     {'title': 'Item', 'value': 'Point'},
//   //     {'title': 'Game ID', 'value': 'Price'},
//   //     {'title': 'Ticket ID', 'value': '\$0.75'},
//   //     {'title': 'Draw Time', 'value': '\$2.25'},
//   //     {'title': 'Ticket Time', 'value': printerType},
//   //     {'title': 'Total Points', 'value': printerType},
//   //   ];
//   //   return Consumer<Lucky16Controller>(
//   //     builder: (context, l16c, child) {
//   //       return SizedBox(
//   //         child: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             Text(
//   //               "LUCKY 16 CARDS LIVE",
//   //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//   //             ),
//   //             _buildReceiptRow('Game Name', ':', 'Lucky 16 game'),
//   //             _buildReceiptRow('Game ID', ':',"skf" ),
//   //             _buildReceiptRow('Ticket ID', ':', '\$0.75'),
//   //             _buildReceiptRow('Ticket Time', ':', printerType),
//   //             _buildReceiptRow('Total Points', ':', printerType),
//   //             const SizedBox(height: 10),
//   //             // Container(
//   //             //   alignment: Alignment.topLeft,
//   //             //   height: 120,
//   //             //   width: 230,
//   //             //   child: GridView.builder(
//   //             //     shrinkWrap: true,
//   //             //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//   //             //       crossAxisCount: 2,
//   //             //       childAspectRatio: 3,
//   //             //       crossAxisSpacing: 10,
//   //             //       mainAxisSpacing: 10,
//   //             //     ),
//   //             //     itemCount: ticketData.length,
//   //             //     itemBuilder: (context, index) {
//   //             //       final data = ticketData[index];
//   //             //       return Column(
//   //             //         mainAxisAlignment: MainAxisAlignment.center,
//   //             //         children: [
//   //             //           Text(
//   //             //             data["title"],
//   //             //             style: TextStyle(
//   //             //               fontSize: 12,
//   //             //               fontWeight: FontWeight.bold,
//   //             //             ),
//   //             //           ),
//   //             //           // SizedBox(height: screenHeight*0.03,),
//   //             //           Text(
//   //             //             data['value']!,
//   //             //             style: TextStyle(fontSize: 12),
//   //             //           ),
//   //             //         ],
//   //             //       );
//   //             //     },
//   //             //   ),
//   //             // ),
//   //             Row(
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               children: [
//   //                 Column(
//   //                   children: [
//   //                     Text("Item"),
//   //                     Text("Q"),
//   //                     Text("K"),
//   //                     Text("J"),
//   //                     Text("Q"),
//   //                   ],
//   //                 ),
//   //                 SizedBox(width: 10),
//   //                 Column(
//   //                   children: [
//   //                     Text("Point"),
//   //                     Text("10"),
//   //                     Text("15"),
//   //                     Text("15"),
//   //                     Text("10"),
//   //                   ],
//   //                 ),
//   //                 SizedBox(width: 10),
//   //                 Column(
//   //                   children: [
//   //                     Text("Item"),
//   //                     Text("Q"),
//   //                     Text("K"),
//   //                     Text("J"),
//   //                   ],
//   //                 ),
//   //                 SizedBox(width: 10),
//   //                 Column(
//   //                   children: [
//   //                     Text("Point"),
//   //                     Text("10"),
//   //                     Text("15"),
//   //                     Text("15"),
//   //                   ],
//   //                 ),
//   //               ],
//   //             ),
//   //           ],
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }
//
//   // Widget _buildReceiptRow(
//   //   String leftText,
//   //   String text,
//   //   String rightText, {
//   //   bool isBold = false,
//   // }) {
//   //   return Padding(
//   //     padding: const EdgeInsets.symmetric(vertical: 3.0),
//   //     child: Row(
//   //       children: [
//   //         Text(
//   //           leftText,
//   //           style: TextStyle(
//   //             fontSize: 12,
//   //             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//   //           ),
//   //         ),
//   //         SizedBox(width: screenWidth * 0.006),
//   //         Text(
//   //           text,
//   //           style: TextStyle(
//   //             fontSize: 12,
//   //             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//   //           ),
//   //         ),
//   //         SizedBox(width: screenWidth * 0.01),
//   //         Text(
//   //           rightText,
//   //           style: TextStyle(
//   //             fontSize: 12,
//   //             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
// }
