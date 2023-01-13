import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/client/client.dart';
import 'package:trophyapp/helpers/snackbar_presenter.dart';
import 'package:trophyapp/screens/common_widgets/trophy_dialog.dart';
import 'package:trophyapp/screens/common_widgets/trophy_text_button.dart';
import 'package:trophyapp/screens/common_widgets/trophy_text_field.dart';
import 'package:trophyapp/screens/forgot_password/check_email/forgot_password_check_email_screen.dart';
import 'package:trophyapp/screens/forgot_password/enter_email/forgot_password_email_provider.dart';

class ForgotPasswordEmail extends StatelessWidget {
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 39, right: 14, left: 14),
              child: TrophyDialog(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ChangeNotifierProvider(
                    create: (_) => ForgotPasswordEmailProvider(),
                    child: Builder(
                      builder: (context) {
                        final provider =
                            Provider.of<ForgotPasswordEmailProvider>(context);
                        return Column(
                          children: [
                            SizedBox(height: 29.7),
                            Text(
                              'Restore Password',
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w800,
                                fontSize: 24,
                                color: Color(0xFF434345),
                              ),
                            ),
                            SizedBox(height: 9),
                            Text(
                              'We will send you a confirmation email',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0x99434345),
                              ),
                            ),
                            SizedBox(height: 42),
                            TrophyTextField(
                              hint: 'Email',
                              errorText: provider.emailError,
                              onChanged: provider.setEmail,
                              keyboardType: TextInputType.emailAddress,
                              leadingIconPath: 'assets/img/email_icon.svg',
                            ),
                            SizedBox(height: 9),
                            TrophyTextButton(
                              text: 'Send Email',
                              textStyle: GoogleFonts.raleway(
                                color: Color(0xFF434345),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: 0.48,
                              ),
                              backgroundColor: Color(0xFFCC9E40),
                              onPressed: provider.canContinue
                                  ? () async {
                                      if (await Client.instance
                                          .canUserSignInWithFacebook(
                                              provider.email)) {
                                        SnackbarPresenter
                                            .showErrorMessageSnackbar(
                                          context,
                                          "You can't change your password because you are registered with Facebook",
                                        );
                                        return;
                                      }
                                      String errorMessage;
                                      await provider
                                          .restorePassword()
                                          .catchError((error) {
                                        errorMessage = error.toString();
                                        SnackbarPresenter.showErrorMessageSnackbar(
                                            context,
                                            error.toString().replaceAll(
                                                '[firebase_auth/user-not-found] ',
                                                ''));
                                      });
                                      if (errorMessage == null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    ForgotPasswordCheckEmail(
                                                        email:
                                                            provider.email)));
                                      }
                                    }
                                  : null,
                            ),
                            SizedBox(height: 45.7),
                          ],
                        );
                      },
                    ),
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
