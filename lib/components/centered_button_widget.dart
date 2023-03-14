import 'package:flutter/material.dart';
import 'package:to_do_app/constants/app_colors.dart';
import 'package:to_do_app/constants/app_styles.dart';

class CenteredButtonWidget extends StatelessWidget {
  const CenteredButtonWidget({
    required this.title,
    required this.width,
    this.buttonState = ButtonState.active,
    this.activeBackgroundColor = AppColors.denimColor,
    this.inActiveBackgroundColor = AppColors.wildSandColor,
    this.activeBorderColor = AppColors.whiteColor,
    this.inActiveBorderColor = AppColors.wildSandColor,
    this.fontSize = 18,
    this.height,
    this.textColor,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String title;
  final double width;
  final Color? textColor;
  final ButtonState buttonState;
  final Color activeBackgroundColor;
  final Color inActiveBackgroundColor;
  final Color activeBorderColor;
  final Color inActiveBorderColor;
  final double fontSize;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
                height: height ?? LoadingPreferance.height,
                width: buttonState == ButtonState.loading
                    ? LoadingPreferance.width
                    : width,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: buttonState == ButtonState.inactive
                        ? inActiveBackgroundColor
                        : activeBackgroundColor,
                    border: Border.all(
                      color: buttonState == ButtonState.inactive
                          ? inActiveBorderColor
                          : activeBorderColor,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                duration: const Duration(milliseconds: 300),
                child: buttonState == ButtonState.loading
                    ? FittedBox(child: _renderItem())
                    : _renderItem())));
  }

  Widget _renderItem() {
    return buttonState == ButtonState.loading
        ? _renderLoading()
        : _renderText();
  }

  Widget _renderText() {
    return Align(
        alignment: Alignment.center,
        child: Text(title,
            textAlign: TextAlign.center,
            style: getStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: textColor ??
                    (buttonState == ButtonState.active
                        ? AppColors.whiteColor
                        : AppColors.dustyGrayColor))));
  }

  Widget _renderLoading() {
    return const Center(
        child: CircularProgressIndicator(color: AppColors.altoColor));
  }
}

enum ButtonState { inactive, active, loading }

class LoadingPreferance {
  static double height = 52;
  static double width = 52;
}
