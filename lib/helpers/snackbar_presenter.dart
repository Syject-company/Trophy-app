import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SnackbarPresenter {
  static void showErrorMessageSnackbar(
      BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text(
        errorMessage,
        style: GoogleFonts.raleway(
            fontFeatures: [FontFeature.enable('lnum')], color: Colors.white),
      ),
    ));
  }

  static void showSuccessMessageSnackbar(
      BuildContext context, String successMessage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        successMessage,
        style: GoogleFonts.raleway(
            fontFeatures: [FontFeature.enable('lnum')], color: Colors.white),
      ),
    ));
  }
}
