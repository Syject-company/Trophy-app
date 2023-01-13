import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trophyapp/constants/theme_defaults.dart';

class TrophyTextField extends StatefulWidget {
  final String hint;
  final TextStyle hintStyle;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final TextInputType keyboardType;
  final String leadingIconPath;
  final String eyeIconPath;
  final String crossedOutEyeIconPath;
  final TextEditingController controller;
  final String initialValue;
  final String obscuringCharater;
  final bool obscureText;
  final String errorText;
  final String commentText;
  final Color defaultUnderLineColor;

  TrophyTextField({
    this.hint,
    this.hintStyle,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.leadingIconPath,
    this.eyeIconPath,
    this.crossedOutEyeIconPath,
    this.controller,
    this.initialValue,
    this.obscuringCharater = '*',
    this.obscureText = false,
    this.errorText = '',
    this.commentText = '',
    this.defaultUnderLineColor,
  });

  @override
  State<StatefulWidget> createState() => _TrophyTextFieldState();
}

class _TrophyTextFieldState extends State<TrophyTextField> {
  TextEditingController _controller;
  bool _obscureText;
  Widget _leadingIcon;
  Widget _leadingErrorIcon;
  Widget _leadingActiveIcon;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue ?? '');
    } else {
      _controller = widget.controller;
    }

    _obscureText = widget.obscureText;

    if (widget.leadingIconPath != null && widget.leadingIconPath.isNotEmpty) {
      _leadingIcon = SvgPicture.asset(
        widget.leadingIconPath,
      );
      _leadingActiveIcon = SvgPicture.asset(
        widget.leadingIconPath,
        color: Color(0xFF434345),
      );
      _leadingErrorIcon = SvgPicture.asset(
        widget.leadingIconPath,
        color: Color(0xFFEB5757),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 71,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    widget.errorText.isEmpty || _controller.text.isEmpty
                        ? SizedBox(width: 13)
                        : SvgPicture.asset(
                            'assets/img/cross_icon.svg',
                            height: 13,
                            width: 13,
                          ),
                    SizedBox(width: 8),
                    _getLeadingIcon(),
                  ],
                ),
              ),
              TextField(
                controller: _controller,
                obscuringCharacter: widget.obscuringCharater,
                obscureText: _obscureText,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                keyboardType: widget.keyboardType,
                style: GoogleFonts.hind(
                  fontSize: 13.0,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                  color: ThemeDefaults.primaryTextColor,
                ),
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: _controller.text.isEmpty
                        ? BorderSide(
                            color: widget.defaultUnderLineColor ??
                                Color(0xFFBDBDBD),
                            width: 1.5,
                          )
                        : BorderSide(color: Color(0xFFCC9E40), width: 1.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFCC9E40), width: 1.5),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF434345), width: 1.5),
                  ),
                  hintText: widget.hint,
                  hintStyle: widget.hintStyle ??
                      GoogleFonts.raleway(
                        fontSize: 14.0,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w600,
                        color: ThemeDefaults.inactiveColor,
                      ),
                  contentPadding:
                      EdgeInsets.only(right: 40, bottom: 3, left: 40),
                  isDense: true,
                  alignLabelWithHint: true,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: widget.obscureText
                      ? () => setState(() {
                            _obscureText = !_obscureText;
                          })
                      : null,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5, right: 21),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: _getEyeIcon(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 7),
            child: Center(
              child: widget.errorText.isEmpty || _controller.text.isEmpty
                  ? Text(
                      widget.commentText,
                      style: GoogleFonts.raleway(
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF4F4F4F),
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      widget.errorText,
                      style: GoogleFonts.raleway(
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFFF450F),
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getLeadingIcon() {
    if (widget.errorText.isEmpty || _controller.text.isEmpty) {
      if (_controller.text.isEmpty) {
        return _leadingIcon ?? SizedBox(width: 13);
      } else {
        return _leadingActiveIcon ?? SizedBox(width: 13);
      }
    } else {
      return _leadingErrorIcon ?? SizedBox(width: 13);
    }
  }

  Widget _getEyeIcon() {
    var iconColor = Color(0xFFBDBDBD);
    if (_controller.text.isNotEmpty) {
      iconColor = Color(0xFF434345);
    }
    var iconWidth = 13.0;

    if (_controller.text.isEmpty) {
      return SizedBox(width: iconWidth);
    } else if (_obscureText) {
      if (widget.eyeIconPath == null) {
        return SizedBox(width: iconWidth);
      } else {
        return SvgPicture.asset(
          widget.eyeIconPath,
          color: iconColor,
        );
      }
    } else {
      if (widget.crossedOutEyeIconPath == null) {
        return SizedBox(width: iconWidth);
      } else {
        return SvgPicture.asset(
          widget.crossedOutEyeIconPath,
          color: iconColor,
        );
      }
    }
  }
}
