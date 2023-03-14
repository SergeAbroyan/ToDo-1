import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/constants/app_styles.dart';

class TextFiledWidget extends StatelessWidget {
  const TextFiledWidget(
      {required this.hint, required this.controller, Key? key})
      : super(key: key);

  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
          controller: controller,
          style: getStyle(fontSize: 12),
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 14),
              icon: const Icon(CupertinoIcons.square_list, color: Colors.brown),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
    );
  }
}
