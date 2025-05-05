import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_star/main.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.title,
    required this.icon,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
  });
  final String title;
  final Widget icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.3,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 3, color: const Color(0xff3b1a13)),
        color: const Color(0xff0c0201),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TextField(
        textCapitalization: TextCapitalization.characters,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.red,
        controller: controller,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        focusNode: focusNode,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: icon,
          hintText: title,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.only(
            top: 12,
          ),
        ),
      ),
    );
  }
}
