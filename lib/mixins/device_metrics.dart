import 'package:flutter/material.dart';

mixin DeviceMetricsStateful<T extends StatefulWidget> on State<T> {
  Size get _screenSize => MediaQuery.of(context).size;

  double get height => _screenSize.height;

  double get width => _screenSize.width;
}

mixin DeviceMetricsStateless<T extends StatelessWidget> {
  Size _screenSize(BuildContext context) => MediaQuery.of(context).size;

  double height(BuildContext context) => _screenSize(context).height;

  double width(BuildContext context) => _screenSize(context).width;
}
