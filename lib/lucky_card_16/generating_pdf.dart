import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfGeneratorScreen extends StatefulWidget {
  const PdfGeneratorScreen({super.key});

  @override
  PdfGeneratorScreenState createState() => PdfGeneratorScreenState();
}

class PdfGeneratorScreenState extends State<PdfGeneratorScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Generator")),
      body: KeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        autofocus: true,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            _generatePdf();
          }
        },
        child: Center(
          child: Text(
            "Press ENTER to generate PDF",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  void _generatePdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              "Hello, this is your generated PDF!",
              style: pw.TextStyle(fontSize: 20),
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

}
