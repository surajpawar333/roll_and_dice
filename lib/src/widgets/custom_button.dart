import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.height = ConstantStrings.homeScreenButtonHeight,
    this.width = ConstantStrings.homeScreenButtonWidth,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.borderColor = Colors.black,
    this.borderRadius,
    this.enabled,
  }) : super(key: key);

  final VoidCallback onTap;
  final double height;
  final double width;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final BorderRadius? borderRadius;
  final String text;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: new Container(
        width: width,
        height: height,
        decoration: new BoxDecoration(
          color: backgroundColor,
          border: new Border.all(color: enabled != null && enabled! ? borderColor : Colors.grey, width: 2.0),
          borderRadius: borderRadius ?? BorderRadius.circular(10.0),
        ),
        child: new Center(
          child: new Text(
            text,
            style: new TextStyle(fontSize: 18.0, color: enabled != null && enabled! ? textColor : Colors.grey),
          ),
        ),
      ),
    );
  }
}
