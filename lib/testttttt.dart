// class Lucky12WheelFirst extends StatefulWidget {
//   final Lucky12Controller controller;
//   final String pathImage;
//   final double withWheel;
//   final int pieces;
//   final double offset;
//   final int speed;
//   final int resultValue;
//
//   const Lucky12WheelFirst({
//     super.key,
//     required this.controller,
//     required this.pathImage,
//     required this.withWheel,
//     this.offset = 0,
//     required this.pieces,
//     this.speed = 900,
//     required this.resultValue,
//   });
//
//   @override
//   State<Lucky12WheelFirst> createState() =>
//       _Lucky12WheelFirstState(controller);
// }
//
// class _Lucky12WheelFirstState extends State<Lucky12WheelFirst>
//     with TickerProviderStateMixin {
//   _Lucky12WheelFirstState(Lucky12Controller controller) {
//     controller.lucky12StartWheel = startWheel;
//     controller.lucky12StopWheel = stopWheel;
//   }
//
//   late final AnimationController _controllerStart = AnimationController(
//     duration: Duration(milliseconds: widget.speed),
//     vsync: this,
//   );
//
//   late final AnimationController _controllerFinish = AnimationController(
//     duration: Duration(milliseconds: widget.speed * 2),
//     vsync: this,
//   );
//
//   late final AnimationController _controllerMiddle = AnimationController(
//     duration: Duration(milliseconds: widget.speed),
//     vsync: this,
//   );
//
//   late final Animation<double> _animationFinish = CurvedAnimation(
//     parent: _controllerFinish,
//     curve: Curves.linear,
//   );
//
//   late final Animation<double> _animationStart = CurvedAnimation(
//     parent: _controllerStart,
//     curve: Curves.linear,
//   );
//
//   late final Animation<double> _animationMiddle = CurvedAnimation(
//     parent: _controllerMiddle,
//     curve: Curves.linear,
//   );
//
//   int statusWheel = 0;
//   bool isNhanKetQua = false;
//   int indexResult = 0;
//   double angle = 0;
//   int pieces = 0;
//   bool isStart = false;
//
//   @override
//   void initState() {
//     super.initState();
//     pieces = widget.pieces;
//
//     // 🔹 Set default angle according to resultValue
//     Future.delayed(Duration(milliseconds: 800),(){
//       setState(() {
//         indexResult = widget.resultValue;
//         angle = (indexResult / pieces) * 2 * pi;
//       });
//
//       print(indexResult);
//       print(angle);
//       print("qqqqqqqqqqqq");
//     });
//
//
//     _controllerStart.addStatusListener((status) {
//       if (!isStart) return;
//       if (status == AnimationStatus.completed) {
//         if (!isNhanKetQua) {
//           _controllerStart.reset();
//           _controllerStart.forward();
//         } else {
//           setState(() {
//             statusWheel = 1;
//             _controllerStart.stop();
//             _controllerMiddle.forward();
//           });
//         }
//       }
//     });
//
//     _controllerMiddle.addListener(() {
//       if (!isStart) return;
//       double radius = indexResult / pieces + widget.offset;
//       if (_controllerMiddle.value >= radius) {
//         setState(() {
//           statusWheel = 2;
//           angle = radius * 2 * pi;
//           _controllerMiddle.stop();
//           _controllerFinish.forward();
//         });
//       }
//     });
//   }
//
//   void reset() {
//     setState(() {});
//     isStart = false;
//     statusWheel = 0;
//
//     // 🔹 Reset to default resultValue angle
//     angle = (widget.resultValue / pieces) * 2 * pi;
//
//     _controllerMiddle.reset();
//     _controllerFinish.reset();
//     _controllerStart.reset();
//     isNhanKetQua = false;
//   }
//
//   void nhanKetQua(int index) {
//     isNhanKetQua = true;
//     indexResult = index;
//   }
//
//   Animation<double> getAnimation() {
//     if (statusWheel == 0) return _animationStart;
//     if (statusWheel == 1) return _animationMiddle;
//     return _animationFinish;
//   }
//
//   @override
//   void dispose() {
//     _controllerStart.dispose();
//     _controllerFinish.dispose();
//     _controllerMiddle.dispose();
//     super.dispose();
//   }
//
//   void startWheel() {
//     reset();
//     isStart = true;
//     _controllerStart.forward();
//   }
//
//   void stopWheel(int index) {
//     nhanKetQua(index);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: Listenable.merge([
//         _controllerStart,
//         _controllerMiddle,
//         _controllerFinish,
//       ]),
//       builder: (context, child) {
//         double currentAngle = angle;
//
//         // Apply animation based on status
//         if (statusWheel == 0) {
//           currentAngle += _animationStart.value * 2 * pi;
//         } else if (statusWheel == 1) {
//           currentAngle += _animationMiddle.value * 2 * pi;
//         } else {
//           currentAngle += _animationFinish.value * 2 * pi;
//         }
//
//         return Transform.rotate(
//           angle: currentAngle,
//           child: Container(
//             width: widget.withWheel,
//             height: widget.withWheel,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(widget.pathImage),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }