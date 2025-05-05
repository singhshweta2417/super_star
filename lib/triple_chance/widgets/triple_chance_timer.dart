// import 'package:flutter/material.dart';
// import 'dart:async';
//
// import 'package:npl/main.dart';
//
// class TripleChanceTimer extends StatefulWidget {
//   final Function(int) onTimerTick;
//
//   const TripleChanceTimer({
//     super.key,
//     required this.onTimerTick,
//   });
//
//   @override
//   TripleChanceTimerState createState() => TripleChanceTimerState();
// }
//
// class TripleChanceTimerState extends State<TripleChanceTimer> {
//   late Stream<DateTime> _clockStream;
//
//   @override
//   void initState() {
//     super.initState();
//     _clockStream = clockStream();
//   }
//
//   Stream<DateTime> clockStream() {
//     return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DateTime>(
//       stream: _clockStream,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const SizedBox(height: 26);
//         } else {
//           DateTime currentTime = snapshot.data!;
//           int seconds = 60 - (currentTime.second % 60);
//           String showdownSeconds = seconds.toString().padLeft(2, '0');
//           widget.onTimerTick(seconds);
//           return Text(
//             showdownSeconds,
//             style:  TextStyle(
//                 color: const Color(0xffffff34), fontWeight: FontWeight.bold,fontSize: screenHeight*0.07),
//           );
//         }
//       },
//     );
//   }
// }