import 'package:flutter/material.dart';
import 'package:to_do_app/constants/app_styles.dart';
import 'package:to_do_app/mixins/device_metrics.dart';

class InfoWidget extends StatelessWidget with DeviceMetricsStateless {
  const InfoWidget({required this.title, required this.info, Key? key})
      : super(key: key);

  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title, style: getStyle()),
          Container(
              padding: const EdgeInsets.only(left: 20),
              width: width(context) / 3,
              child: Text(info,
                  overflow: TextOverflow.ellipsis, style: getStyle()))
        ]));
  }
}
