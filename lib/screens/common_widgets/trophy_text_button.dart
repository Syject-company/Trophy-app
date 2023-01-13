import 'dart:ui';

import 'package:flutter/material.dart';

class TrophyTextButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color backgroundColor;
  final double borderWidth;
  final Color borderColor;
  final Widget icon;
  final TextStyle textStyle;
  final List<BoxShadow> shadows;

  TrophyTextButton({
    @required this.text,
    @required this.onPressed,
    this.backgroundColor,
    this.borderWidth = 0,
    this.borderColor,
    this.icon,
    this.textStyle,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 40,
        width: double.infinity,
        padding: EdgeInsets.all(0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: backgroundColor,
          boxShadow: shadows,
          border: borderWidth > 0
              ? Border.fromBorderSide(
                  BorderSide(width: borderWidth, color: borderColor),
                )
              : null,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: icon ?? SizedBox.shrink(),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
