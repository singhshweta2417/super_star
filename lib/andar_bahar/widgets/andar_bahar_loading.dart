import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_star/andar_bahar/controller/andar_bahar_controller.dart';
import 'package:super_star/main.dart';

import '../../../generated/assets.dart';

class AndarBaharLoading extends StatefulWidget {
  const AndarBaharLoading({super.key});

  @override
  AndarBaharLoadingState createState() => AndarBaharLoadingState();
}

class AndarBaharLoadingState extends State<AndarBaharLoading>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    final abc = Provider.of<AndarBaharController>(context, listen: false);
   _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _progressAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController)
          ..addListener(() {
            setState(() {});
            if (_progressAnimation.value == 1.0) {
              abc.setPageLoading(true);
            }
          });
   _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AndarBaharController>(builder: (context, abc, child) {
      return Material(
          color: Colors.black,
          child: Center(
            child: Container(
              height: screenHeight,
              width: screenWidth,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.andarBLightGift),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.andarBAndarBaharHome,
                    height: screenHeight * 0.40,
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: const Color(0xffea0b3e), width: 1),
                        ),
                        child: LinearProgressIndicator(
                          value: _progressAnimation.value,
                          backgroundColor: Colors.grey,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Color(0xffea0b3e)),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${(_progressAnimation.value * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: screenWidth * 0.02,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Text(
                    'Welcome to Andar Bahar!',
                    style: TextStyle(
                      fontSize: screenWidth * 0.02,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
