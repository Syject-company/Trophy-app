import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/helpers/disposer.dart';
import 'package:trophyapp/helpers/snackbar_presenter.dart';
import 'package:trophyapp/screens/common_widgets/trophy_dialog.dart';
import 'package:trophyapp/screens/common_widgets/trophy_text_button.dart';
import 'package:trophyapp/screens/forgot_password/enter_email/forgot_password_email_provider.dart';

class ForgotPasswordCheckEmail extends StatelessWidget {
  final String email;

  ForgotPasswordCheckEmail({@required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(106),
        child: Container(
          height: double.infinity,
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 3,
                  spreadRadius: 0,
                  offset: Offset(0, 2),
                  color: Color(0x12000000))
            ],
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 26.1, left: 24),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset('assets/img/close_icon.svg'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.39),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SvgPicture.asset('assets/img/irla_logo.svg'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        color: Color(0xFFF5F6F7),
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 39, right: 14, left: 14),
              child: TrophyDialog(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(height: 29.7),
                      Text(
                        'Check your Email',
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                          color: Color(0xFF434345),
                        ),
                      ),
                      SizedBox(height: 9),
                      Text(
                        'A confirmation email has been sent',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0x99434345),
                        ),
                      ),
                      SizedBox(height: 29),
                      SvgPicture.asset('assets/img/email_image.svg'),
                      SizedBox(height: 23.5),
                      TrophyTextButton(
                        text: 'Ok',
                        textStyle: GoogleFonts.raleway(
                          color: Color(0xFF434345),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: 0.48,
                        ),
                        backgroundColor: Color(0xFFCC9E40),
                        onPressed: () {
                          Navigator.popUntil(context, (route) {
                            return route.isFirst;
                          });
                          Disposer.disposeProviders([
                            Provider.of<ForgotPasswordEmailProvider>(context),
                          ]);
                        },
                      ),
                      SizedBox(height: 20),
                      Builder(
                        builder: (context) => TrophyTextButton(
                          text: 'Send Again',
                          textStyle: GoogleFonts.raleway(
                            color: Color(0xFF434345),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.48,
                          ),
                          backgroundColor: Colors.transparent,
                          borderWidth: 1.5,
                          borderColor: Color(0xFFCC9E40),
                          onPressed: () async {
                            final provider = ForgotPasswordEmailProvider()
                              ..setEmail(email);
                            await provider
                                .restorePassword()
                                .catchError((error) {
                              SnackbarPresenter.showErrorMessageSnackbar(
                                  context,
                                  error.toString().replaceAll(
                                      '[firebase_auth/user-not-found] ', ''));
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 39.2),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
