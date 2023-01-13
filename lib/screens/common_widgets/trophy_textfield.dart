import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trophyapp/constants/theme_defaults.dart';

class TrophyTextField extends StatefulWidget {
  final String title;
  final String value;
  final String placeholder;
  final int maxLenght;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool showEyeButton;
  final bool isEditable;
  final IconButton button;
  final SvgPicture trailingImage;
  final SvgPicture leadingImage;
  final String errorMessage;
  final Function(String value) editingChanged;
  final String initVal;

  TrophyTextField(this.title, this.editingChanged,
      {this.value,
      this.obscureText,
      this.maxLenght,
      this.inputFormatters,
      this.keyboardType,
      this.showEyeButton,
      this.trailingImage,
      this.errorMessage,
      this.isEditable,
      this.button,
      this.leadingImage,
      this.placeholder,
      this.initVal}) {
    assert(
      title != null,
      'A non-null String title must be provided to a TrophyTextField widget.',
    );
    if (showEyeButton != null && showEyeButton) {
      assert(
        obscureText != null,
        'ShowEyeButton is true but obscureText is null!',
      );
    }
    if (value != null) {
      assert(initVal == null);
    }
  }

  @override
  State<StatefulWidget> createState() =>
      _TrophyTextFieldState(this.title, this.editingChanged,
          obscureText: this.obscureText,
          maxLenght: this.maxLenght,
          inputFormatters: this.inputFormatters,
          keyboardType: this.keyboardType,
          value: this.value,
          showEyeButton: this.showEyeButton,
          trailingImage: this.trailingImage,
          errorMessage: this.errorMessage,
          isEditable: this.isEditable,
          button: this.button,
          initVal: this.initVal);
}

class _TrophyTextFieldState extends State<TrophyTextField> {
  String title;
  String value;
  bool obscureText;
  int maxLenght;
  List<TextInputFormatter> inputFormatters;
  TextInputType keyboardType;
  bool showEyeButton;
  bool isEditable;
  IconButton button;
  SvgPicture trailingImage;
  String errorMessage;
  Function(String value) editingChanged;
  String initVal;

  _TrophyTextFieldState(this.title, this.editingChanged,
      {this.value,
      this.obscureText,
      this.maxLenght,
      this.inputFormatters,
      this.keyboardType,
      this.showEyeButton,
      this.trailingImage,
      this.errorMessage,
      this.isEditable,
      this.button,
      this.initVal});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.raleway(
                      fontFeatures: [FontFeature.enable('lnum')],
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ThemeDefaults.textColor),
                  textDirection: TextDirection.ltr,
                ),
              ),
              Visibility(
                visible: widget.trailingImage != null,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: widget.trailingImage),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Stack(alignment: Alignment.bottomRight, children: [
            TextFormField(
              textAlign: TextAlign.center,
              initialValue: initVal,
              keyboardType: this.keyboardType,
              inputFormatters: this.inputFormatters,
              maxLength: this.maxLenght,
              style: GoogleFonts.raleway(
                  fontFeatures: [FontFeature.enable('lnum')],
                  color: ThemeDefaults.textColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
              controller:
                  value == null ? null : TextEditingController(text: value),
              enabled: isEditable,
              obscureText: obscureText ?? false,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    style: BorderStyle.solid,
                    color: Color(0xFFF89808),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                suffixIcon: IconButton(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  icon: SvgPicture.asset(
                    'assets/img/me_icon_selected.svg',
                    height: 18.0,
                  ),
                ),
                //   suffixIcon: widget.button,
                filled: true,

                fillColor: ThemeDefaults.tfFillColor,

                hintText: widget.placeholder,
                border: InputBorder.none,
                icon: widget.leadingImage,
              ),
              onChanged: editingChanged,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Visibility(
                  visible: showEyeButton ?? false,
                  child: _getTrailingElement(),
                ),
              ),
            ),
          ]),
          SizedBox(
            height: 8,
          ),
          Visibility(
            visible: errorMessage != null,
            child: Text(
              errorMessage ?? '',
              style: GoogleFonts.raleway(
                  fontFeatures: [FontFeature.enable('lnum')],
                  fontStyle: FontStyle.italic,
                  color: Colors.red,
                  fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  Widget _getTrailingElement() {
    if (showEyeButton != null) {
      if (showEyeButton) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _toggleVisibility(),
          child: Container(
            height: 30.0,
            width: 30.0,
            padding: EdgeInsets.all(6.0),
            child: SvgPicture.asset(
              obscureText ? 'assets/img/eye.svg' : 'assets/img/eye_closed.svg',
            ),
          ),
        );
      } else {
        return SizedBox();
      }
    } else if (showEyeButton == null && trailingImage != null) {
      return trailingImage;
    } else {
      return SizedBox();
    }
  }

  _toggleVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
