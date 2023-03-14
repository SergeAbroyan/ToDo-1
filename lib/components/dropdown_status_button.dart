import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/constants/app_styles.dart';
import 'package:to_do_app/mixins/device_metrics.dart';

class DropdownStatusButton extends StatelessWidget with DeviceMetricsStateless {
  const DropdownStatusButton(
      {required this.value,
      required this.items,
      required this.backgroundColor,
      this.padding = const EdgeInsets.symmetric(vertical: 5),
      this.subBackgroundColor,
      this.textColor,
      this.columnWidth,
      Key? key})
      : super(key: key);

  final dynamic value;
  final List<DropdownMenuItem> items;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final Color? subBackgroundColor;
  final Color? textColor;
  final double? columnWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        margin: padding,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: backgroundColor),
        child: DropdownButtonHideUnderline(
            child: DropdownButton2<dynamic>(
                dropdownWidth: columnWidth,
                dropdownMaxHeight: 300,
                hint: DropdownMenuItem(
                    value: value,
                    child: Text(value,
                        style: getStyle(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                        overflow: TextOverflow.ellipsis)),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 30),
                dropdownDecoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                onChanged: (val) {},
                items: items)));
  }
}
