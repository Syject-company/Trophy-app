import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF5F6F7),
      child: Padding(
        padding: EdgeInsets.only(
          top: 10,
          right: 10,
          bottom: 10,
          left: 10,
        ),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 3,
                  spreadRadius: 0,
                  offset: Offset(0, 2),
                )
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/img/loading_logo.svg',
                width: 219,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
