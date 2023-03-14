import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/constants/app_styles.dart';

class AlertWidget {
  void showMessage(BuildContext context, String message,
          {VoidCallback? onPressed, bool showIcon = false}) =>
      showCupertinoDialog(
          context: context,
          builder: (context) => Theme(
              data: ThemeData(
                  dialogBackgroundColor: Colors.black,
                  dialogTheme:
                      const DialogTheme(backgroundColor: Colors.black)),
              child: CupertinoAlertDialog(
                  content: Text(message,
                      style:
                          getStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                  actions: [
                    TextButton(
                        onPressed: () {
                          onPressed?.call();
                          Navigator.of(context).pop();
                        },
                        child: Text('OK', style: getStyle(fontSize: 16))),
                  ])));
}
