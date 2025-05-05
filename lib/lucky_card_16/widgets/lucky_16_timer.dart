import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_star/lucky_card_16/controller/lucky_16_controller.dart';
import 'package:super_star/main.dart';
import 'package:super_star/res/circular_progress.dart';

class Lucky16Timer extends StatelessWidget {
  const Lucky16Timer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Lucky16Controller>(builder: (context, l16c, child) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: const Color(0xffe5ca3b)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularPercentIndicator(
              radius: screenWidth * 0.06,
              percent:
                  l16c.timerStatus == 1 ? (180 - l16c.timerBetTime) / 180 : 0,
                  // l16c.timerStatus == 1 ? (90 - l16c.timerBetTime) / 90 : 0,
              lineWidth: 50,
              linearGradient: const LinearGradient(colors: [
                Colors.red,
                Colors.redAccent,
                Colors.green,
                Colors.green,
                Colors.green,
                Colors.green,
              ], stops: [
                0.0,
                0.2,
                0.4,
                0.6,
                0.8,
                1.0
              ]),
            ),
            Container(
                height: screenHeight * 0.16,
                width: screenHeight * 0.16,
                alignment: Alignment.center,
                // padding: const EdgeInsets.only(bottom: 8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff242424),
                ),
                child: Text(
                  l16c.timerStatus == 1
                      ? l16c.timerBetTime.toString().padLeft(2, '0')
                      : '00',
                  style: TextStyle(
                      color: l16c.timerStatus == 1
                          ? const Color(0xff02ff03)
                          : Colors.red,
                      fontSize: screenHeight * 0.09,
                      fontFamily: 'digital'),
                ))
          ],
        ),
      );
    });
  }
}
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:super_star/lucky_card_16/controller/lucky_16_controller.dart';
// import 'package:super_star/main.dart';
// import 'package:super_star/res/circular_progress.dart';
//
// class Lucky16Timer extends StatelessWidget {
//   const Lucky16Timer({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<Lucky16Controller>(builder: (context, l16c, child) {
//       return Container(
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(width: 2, color: const Color(0xffe5ca3b)),
//         ),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             CircularPercentIndicator(
//               radius: screenWidth * 0.06,
//               percent: l16c.timerStatus == 1
//                   ? (180 - l16c.timerBetTime) / 180 // Countdown from 180 seconds
//                   : 0,
//               lineWidth: 50,
//               linearGradient: const LinearGradient(
//                 colors: [
//                   Colors.red,
//                   Colors.redAccent,
//                   Colors.green,
//                   Colors.green,
//                   Colors.green,
//                   Colors.green,
//                 ],
//                 stops: [
//                   0.0,
//                   0.2,
//                   0.4,
//                   0.6,
//                   0.8,
//                   1.0,
//                 ],
//               ),
//             ),
//             Container(
//               height: screenHeight * 0.16,
//               width: screenHeight * 0.16,
//               alignment: Alignment.center,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Color(0xff242424),
//               ),
//               child: Text(
//                 l16c.timerStatus == 1
//                     ? (180 - l16c.timerBetTime).toString() // Countdown from 180 to 0
//                     : '180', // Default to '180' when timer is inactive
//                 style: TextStyle(
//                   color: l16c.timerStatus == 1
//                       ? const Color(0xff02ff03)
//                       : Colors.red,
//                   fontSize: screenHeight * 0.09,
//                   fontFamily: 'digital',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
