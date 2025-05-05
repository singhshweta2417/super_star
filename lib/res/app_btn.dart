import 'package:flutter/material.dart';
import 'package:super_star/main.dart';

class AppBtn extends StatelessWidget {
  const AppBtn({
    super.key,
    required this.title,
    required this.onTap,
    this.loading = false,
  });
  final String title;
  final VoidCallback onTap;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        width: screenWidth * 0.2,
        height: screenHeight * 0.13,
        decoration: BoxDecoration(
          color: const Color(0xffc51010),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: loading
            ? const CircularProgressIndicator(
          color: Colors.white,
        )
            : Text((title),
            style:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ),
    );
  }
}
