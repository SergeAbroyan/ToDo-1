import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/constants/app_styles.dart';

class AlertWidget {
  void showMessage(
    BuildContext context,
    String message, {
    VoidCallback? onTapOk,
    VoidCallback? onTapAlsoDelete,
  }) =>
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
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel', style: getStyle(fontSize: 16))),
                    TextButton(
                        onPressed: () {
                          onTapAlsoDelete?.call();
                          Navigator.of(context).pop();
                        },
                        child: Text('Add and Delete',
                            style: getStyle(fontSize: 16))),
                    TextButton(
                        onPressed: () {
                          onTapOk?.call();
                          Navigator.of(context).pop();
                        },
                        child: Text('OK', style: getStyle(fontSize: 16))),
                  ])));
}
