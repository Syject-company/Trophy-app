import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/client/client.dart';
import 'package:trophyapp/helpers/snackbar_presenter.dart';
import 'package:trophyapp/screens/common_widgets/trophy_text_button.dart';
import 'package:trophyapp/screens/common_widgets/trophy_text_field.dart';
import 'package:trophyapp/screens/forgot_password/enter_email/forgot_password_email_screen.dart';
import 'package:trophyapp/screens/sign_in/sign_in_provider.dart';
import 'package:trophyapp/screens/sign_up/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  SignInProvider _provider = SignInProvider();
  Future _isInit;

  @override
  void initState() {
    _isInit = _provider.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFF5F6F7),
        height: double.infinity,
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
                  Radius.circular(15),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 21,
                          right: 8,
                          left: 8,
                        ),
                        child: SvgPicture.asset(
                          'assets/img/sign_in_logo.svg',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 26),
                      child: ChangeNotifierProvider.value(
                        value: _provider,
                        child: Builder(
                          builder: (context1) {
                            return FutureBuilder(
                                future: _isInit,
                                builder: (context, snapshot) {
                                  final provider =
                                      Provider.of<SignInProvider>(context);
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Column(
                                      children: [
                                        SizedBox(height: 34),
                                        TrophyTextField(
                                          hint: 'Email',
                                          initialValue: provider.email,
                                          errorText: provider.emailError,
                                          onChanged: provider.setEmail,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          leadingIconPath:
                                              'assets/img/email_icon.svg',
                                        ),
                                        TrophyTextField(
                                          hint: 'Password',
                                          initialValue: provider.password,
                                          errorText: provider.passwordError,
                                          obscureText: true,
                                          onChanged: provider.setPassword,
                                          leadingIconPath:
                                              'assets/img/password_icon.svg',
                                          eyeIconPath:
                                              'assets/img/eye_icon.svg',
                                          crossedOutEyeIconPath:
                                              'assets/img/crossed_out_eye_icon.svg',
                                        ),
                                        SizedBox(height: 33),
                                        TrophyTextButton(
                                          text: 'Log In',
                                          textStyle: GoogleFonts.raleway(
                                            color: Color(0xFF434345),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            letterSpacing: 0.48,
                                          ),
                                          backgroundColor: Color(0xFFCC9E40),
                                          onPressed: provider.canContinue
                                              ? () async {
                                                  provider.signInTapped();
                                                  Client.instance
                                                      .signInWithCredentials(
                                                          provider.email,
                                                          provider.password)
                                                      .catchError((onError) {
                                                    SnackbarPresenter
                                                        .showErrorMessageSnackbar(
                                                            context,
                                                            onError.toString());
                                                  });
                                                }
                                              : null,
                                        ),
                                        SizedBox(height: 20),
                                        TrophyTextButton(
                                          text: 'Log In With Facebook',
                                          textStyle: GoogleFonts.raleway(
                                            color: Color(0xFF3B5998),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            letterSpacing: 0.48,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          borderWidth: 1.5,
                                          borderColor: Color(0xFF3B5998),
                                          icon: SvgPicture.asset(
                                              'assets/img/facebook_icon.svg'),
                                          onPressed: () {
                                            Client.instance
                                                .signInWithFacebook()
                                                .catchError((e) {
                                              SnackbarPresenter
                                                  .showErrorMessageSnackbar(
                                                      context, '$e');
                                            });
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        SizedBox(
                                          height: 22,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Divider(
                                                  height: 1,
                                                  color: Color(0xFF434345),
                                                  endIndent: 8,
                                                ),
                                              ),
                                              Text(
                                                "Don't have an account?",
                                                style: GoogleFonts.raleway(
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF434345),
                                                  fontSize: 10,
                                                ),
                                              ),
                                              Expanded(
                                                child: Divider(
                                                  height: 1,
                                                  color: Color(0xFF434345),
                                                  indent: 8,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        TrophyTextButton(
                                          text: 'Sign Up',
                                          textStyle: GoogleFonts.raleway(
                                            color: Color(0xFF434345),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            letterSpacing: 0.48,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          borderWidth: 1.5,
                                          borderColor: Color(0xFFCC9E40),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => SignUp(),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(height: 27),
                                        Divider(
                                          height: 1.5,
                                          color: Color(0xFFCC9E40),
                                        ),
                                        SizedBox(height: 6.5),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        ForgotPasswordEmail()));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Forgot your password?',
                                                style: GoogleFonts.raleway(
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF434345),
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                ' CLICK HERE',
                                                style: GoogleFonts.raleway(
                                                  fontWeight: FontWeight.w800,
                                                  color: Color(0xFFCC9E40),
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
