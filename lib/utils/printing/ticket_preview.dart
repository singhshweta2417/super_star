import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:super_star/generated/assets.dart';
import 'package:super_star/main.dart';

import '../../lucky_card_16/controller/lucky_16_controller.dart';
import '../../lucky_card_16/view_model/print_view_model.dart';
import '../../lucky_card_16/widgets/lucky_16_btn.dart';
import '../../spin_to_win/view_model/profile_view_model.dart';

class TicketPreview extends StatefulWidget {
  final dynamic gameData;
  final List<dynamic> betData;

  const TicketPreview({super.key, required this.gameData, required this.betData});

  @override
  State<TicketPreview> createState() => _TicketPreviewState();
}

final GlobalKey ticketKey = GlobalKey();

class _TicketPreviewState extends State<TicketPreview> {
  final FocusNode _keyboardFocusNode = FocusNode();
  @override
  void initState() {
    _keyboardFocusNode.requestFocus();
    super.initState();
  }

  void _handleKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter) {
        final l16c = Provider.of<Lucky16Controller>(context, listen: false);
        if (l16c.addLucky16Bets.isNotEmpty) {
          if (l16c.addLucky16Bets.isNotEmpty) {
            Provider.of<PrintingController>(
              context,
              listen: false,
            ).handleReceiptPrinting(widget.gameData, widget.betData, context);

            // Provider.of<UsbPrintViewModel>(
            //   context,
            //   listen: false,
            // ).createAndPrintTicket(widget.gameData, context);
            // handleReceiptPrinting
          }
        }
      } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPoints = widget.betData.fold<int>(
      0,
      (sum, item) => sum + item['amount'] as int,
    );
    final printingCon = Provider.of<PrintingController>(context);
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    return Consumer<Lucky16Controller>(
      builder: (context, l16c, _) {
        return Dialog(
          backgroundColor: Colors.white,
          child: KeyboardListener(
            focusNode: _keyboardFocusNode,
            onKeyEvent: _handleKey,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                RepaintBoundary(
                  key: ticketKey,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    width: screenWidth / 3.5,
                    height: screenHeight / 1.15,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "Ticket Preview",
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(Assets.assetsSuperStar),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "SUPER STAR 16 CARDS LIVE",
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildRow("Game Name", "Lucky 16"),
                            _buildRow(
                              "Terminal ID",
                              profileViewModel.userName.toString(),
                            ),
                            _buildRow(
                              "Ticket ID",
                              widget.gameData["ticket_id"].toString(),
                            ),
                            // _buildRow("Draw Time", l16c.nextDrawTimeFormatted),
                            _buildRow(
                              "Ticket Time",
                              DateFormat('dd-MM-yyyy hh:mm a').format(
                                DateTime.parse(
                                  widget.gameData["ticket_time"].toString(),
                                ),
                              ),
                            ),
                            _buildRow("Total Points", "$totalPoints"),
                            const Divider(height: 8, thickness: 1),
                            Row(
                              children: [
                                betHeading(),
                                const SizedBox(width: 10),
                                betHeading(),
                              ],
                            ),
                            Column(
                              children: List.generate(
                                (widget.betData.length / 2).ceil(),
                                (index) {
                                  int firstIndex = index * 2;
                                  int secondIndex = firstIndex + 1;

                                  final firstBet = widget.betData[firstIndex];
                                  final firstCard = l16c.cardList.firstWhere(
                                    (card) => card.id == firstBet['game_id'],
                                  );

                                  Map<String, dynamic>? secondBet;
                                  dynamic secondCard;
                                  if (secondIndex < widget.betData.length) {
                                    secondBet = widget.betData[secondIndex];
                                    secondCard = l16c.cardList.firstWhere(
                                      (card) =>
                                          card.id == secondBet!['game_id'],
                                    );
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Row(
                                      children: [
                                        _buildCardItem(
                                          firstCard.icon!,
                                          firstBet['amount'],
                                        ),
                                        const SizedBox(width: 8),
                                        secondBet != null
                                            ? _buildCardItem(
                                              secondCard.icon!,
                                              secondBet['amount'],
                                            )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 16),
                            Center(
                              child: BarcodeWidget(
                                barcode: Barcode.code128(),
                                data: widget.gameData["ticket_id"].toString(),
                                width: screenWidth / 7,
                                height: 80,
                                drawText: true,
                              ),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child:
                                  printingCon.isDownloading
                                      ? CircularProgressIndicator(
                                        color: Colors.green,
                                      )
                                      : Lucky16Btn(
                                        title: 'Print',
                                        onTap: () async {
                                          Provider.of<PrintingController>(
                                            context,
                                            listen: false,
                                          ).handleReceiptPrinting(
                                            widget.gameData,
                                            widget.betData,
                                            context,
                                          );
                                        },
                                        height: 30,
                                        fontSize: 15,
                                        width: screenWidth / 18,
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -8,
                  right: -8,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CupertinoIcons.clear_circled,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: screenWidth / 14,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(": "),
          SizedBox(width: 10),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildCardItem(String imagePath, int amount) {
    return SizedBox(
      width: screenWidth / 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(imagePath, height: 20, width: 20),
          const SizedBox(width: 15),
          Text("$amount"),
        ],
      ),
    );
  }

  Widget betHeading() {
    return Container(
      width: screenWidth / 12,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Items', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(width: 15),
          Text('Points', style: TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class WidgetToImageSaver {
  static Future<String?> saveWidgetAsImage(GlobalKey globalKey) async {
    try {
      // Get the boundary
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Convert to image
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        // Get the app's document directory
        final directory = await getApplicationDocumentsDirectory();

        // Create a file path
        final filePath =
            '${directory.path}/widget_image_${DateTime.now().millisecondsSinceEpoch}.png';

        // Save the file
        final file = File(filePath);
        await file.writeAsBytes(pngBytes);

        // Return file path
        return file.path;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error saving widget as image: $e");
      }
    }
    return null;
  }
}
