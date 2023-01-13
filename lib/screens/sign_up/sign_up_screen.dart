import 'dart:io';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/helpers/snackbar_presenter.dart';
import 'package:trophyapp/geography/geography.dart' as geo;
import 'package:trophyapp/screens/common_widgets/trophy_dropdown_button.dart';
import 'package:trophyapp/screens/common_widgets/trophy_text_button.dart';
import 'package:trophyapp/screens/common_widgets/trophy_text_field.dart';
import 'package:trophyapp/screens/common_widgets/trophy_title.dart';
import 'package:trophyapp/screens/sign_up/sign_up_provider.dart';
import 'package:trophyapp/screens/sign_up_with_facebook/screen.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Future<List<geo.Country>> _countries = Future.value();
  Future<List<geo.State>> _states = Future.value([]);
  Future<List<geo.City>> _cities = Future.value([]);
  var _country;
  @override
  void initState() {
    _countries = geo.Geography().getCountries();
    super.initState();
  }

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
              padding: EdgeInsets.only(top: 34, right: 14, bottom: 8, left: 14),
              child: Container(
                padding: EdgeInsets.only(
                  top: 24,
                  right: 26,
                  bottom: 24.5,
                  left: 26,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        spreadRadius: 0,
                        offset: Offset(0, 2),
                        color: Color(0x12000000),
                      ),
                    ]),
                child: Builder(
                  builder: (context) {
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: TrophyTitle(
                            child: Text(
                              'Sign Up',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF434345),
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 22),
                        ChangeNotifierProvider(
                          create: (_) => SignUpProvider(),
                          child: Builder(builder: (context) {
                            final provider =
                                Provider.of<SignUpProvider>(context);

                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final _imagePicker = ImagePicker();
                                    final image = await _imagePicker
                                        .pickImage(source: ImageSource.gallery)
                                        .catchError((err) {
                                      SnackbarPresenter
                                          .showErrorMessageSnackbar(
                                              context, err.toString());
                                    });
                                    if (image != null) {
                                      provider.setImage(File(image.path));
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Color(0xFFE0E0E0),
                                    backgroundImage: provider.image == null
                                        ? AssetImage(
                                            'assets/img/avatar_icon.png')
                                        : FileImage(provider.image),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 8.0, bottom: 9.0),
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          height: 26,
                                          width: 26,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(13),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 7,
                                                  spreadRadius: 0,
                                                  offset: Offset(0, 0),
                                                  color: Color(0x1A000000),
                                                )
                                              ]),
                                          child: SvgPicture.asset(
                                            provider.image == null
                                                ? 'assets/img/add_avatar_icon.svg'
                                                : 'assets/img/edit_avatar_icon.svg',
                                            width: 19.0,
                                            height: 19.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 33),
                                TrophyTextField(
                                  hint: 'Email',
                                  commentText: "Won't be publicly displayed",
                                  errorText: provider.emailError,
                                  keyboardType: TextInputType.emailAddress,
                                  leadingIconPath: 'assets/img/email_icon.svg',
                                  onChanged: provider.setEmail,
                                ),
                                SizedBox(height: 8),
                                TrophyTextField(
                                  hint: 'Password*',
                                  commentText:
                                      'Password should have at least 10 symbols',
                                  errorText: provider.passwordError,
                                  leadingIconPath:
                                      'assets/img/password_icon.svg',
                                  eyeIconPath: 'assets/img/eye_icon.svg',
                                  crossedOutEyeIconPath:
                                      'assets/img/crossed_out_eye_icon.svg',
                                  obscureText: true,
                                  onChanged: provider.setPassword,
                                ),
                                SizedBox(height: 8),
                                TrophyTextField(
                                  hint: 'Confirm Password',
                                  errorText: provider.confirmPasswordError,
                                  leadingIconPath:
                                      'assets/img/password_icon.svg',
                                  eyeIconPath: 'assets/img/eye_icon.svg',
                                  crossedOutEyeIconPath:
                                      'assets/img/crossed_out_eye_icon.svg',
                                  obscureText: true,
                                  onChanged: provider.setConfirmPassword,
                                ),
                                SizedBox(height: 8),
                                TrophyTextField(
                                  hint: 'Username',
                                  errorText: provider.usernameError,
                                  leadingIconPath: 'assets/img/user_icon.svg',
                                  onChanged: provider.setUsername,
                                ),
                                FutureBuilder<List<geo.Country>>(
                                  future: _countries,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return TrophyDropdownButton(
                                        hint: 'Select a Country',
                                        hintStyle: GoogleFonts.raleway(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Color(0xFF434345),
                                        ),
                                        value: _country,
                                        onChanged: (newValue) {
                                          _country = newValue;
                                          provider.setCountryName(newValue);
                                          _states = geo.Geography()
                                              .getStates(newValue);
                                          _cities = Future.value([]);
                                        },
                                        items: _getItems(snapshot.data),
                                        leadingIcon: SvgPicture.asset(
                                          'assets/img/geo_icon.svg',
                                          color: Color(0xFF434345),
                                        ),
                                      );
                                    }
                                    if (snapshot.hasError)
                                      return Text(snapshot.error.toString());
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                ),
                                SizedBox(height: 20),
                                FutureBuilder<List<geo.State>>(
                                  future: _states,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return TrophyDropdownButton(
                                        hint: 'Select a State',
                                        hintStyle: GoogleFonts.raleway(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Color(0xFF434345),
                                        ),
                                        value: provider.state.isEmpty
                                            ? null
                                            : provider.state,
                                        onChanged: (newValue) {
                                          provider.state = newValue;
                                          _cities = geo.Geography().getCities(
                                              provider.countryName,
                                              provider.state);
                                        },
                                        items: _getStates(snapshot.data),
                                        leadingIcon: SvgPicture.asset(
                                          'assets/img/geo_icon.svg',
                                          color: Color(0xFF434345),
                                        ),
                                      );
                                    }
                                    if (snapshot.hasError)
                                      return Text(snapshot.error.toString());
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                ),
                                SizedBox(height: 20),
                                FutureBuilder<List<geo.City>>(
                                  future: _cities,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return TrophyDropdownButton(
                                        hint: 'Select a City',
                                        hintStyle: GoogleFonts.raleway(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Color(0xFF434345),
                                        ),
                                        value: provider.city.isEmpty
                                            ? null
                                            : provider.city,
                                        onChanged: (newValue) {
                                          provider.city = newValue;
                                        },
                                        items: _getCities(snapshot.data),
                                        leadingIcon: SvgPicture.asset(
                                          'assets/img/geo_icon.svg',
                                          color: Color(0xFF434345),
                                        ),
                                      );
                                    }
                                    if (snapshot.hasError)
                                      return Text(snapshot.error.toString());
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                ),
                                SizedBox(height: 43),
                                provider.isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : TrophyTextButton(
                                        text: 'Sign Up',
                                        backgroundColor: Color(0xFFCC9E40),
                                        textStyle: GoogleFonts.raleway(
                                          color: Color(0xFF434345),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          letterSpacing: 0.48,
                                        ),
                                        onPressed: provider.canContinue
                                            ? () async {
                                                try {
                                                  final result =
                                                      await provider.signUp();

                                                  if (result != null) {
                                                    // Only for iOS
                                                    await FirebaseMessaging
                                                        .instance
                                                        .requestPermission(
                                                      alert: true,
                                                      announcement: false,
                                                      badge: true,
                                                      carPlay: false,
                                                      criticalAlert: false,
                                                      provisional: false,
                                                      sound: true,
                                                    );
                                                    Navigator.pop(context);
                                                  }
                                                } catch (e) {
                                                  SnackbarPresenter
                                                      .showErrorMessageSnackbar(
                                                          context,
                                                          e.toString());
                                                }
                                              }
                                            : () {
                                                SnackbarPresenter
                                                    .showErrorMessageSnackbar(
                                                        context,
                                                        'Please enter all data');
                                              },
                                      ),
                              ],
                            );
                          }),
                        ),
                        SizedBox(height: 20),
                        TrophyTextButton(
                          text: 'Sign Up with Facebook',
                          textStyle: GoogleFonts.raleway(
                            color: Color(0xFF3B5998),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.48,
                          ),
                          backgroundColor: Colors.transparent,
                          borderWidth: 1.5,
                          borderColor: Color(0xFF3B5998),
                          icon:
                              SvgPicture.asset('assets/img/facebook_icon.svg'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        SignUpWithFacebookScreen()));
                          },
                        ),
                        SizedBox(height: 30),
                        SvgPicture.asset('assets/img/bottom_placeholder.svg'),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getItems(List<geo.Country> data) {
    final items = data.map((e) {
      return DropdownMenuItem(
        value: e.name,
        child: Column(
          children: [
            data.first == e
                ? SizedBox.shrink()
                : Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE0E0E0),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  e.name,
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
    return items;
  }

  List<DropdownMenuItem<String>> _getStates(List<geo.State> data) {
    final items = data.map((e) {
      return DropdownMenuItem(
        value: e.name,
        child: Column(
          children: [
            data.first == e
                ? SizedBox.shrink()
                : Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE0E0E0),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  e.name,
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
    return items;
  }

  List<DropdownMenuItem<String>> _getCities(List<geo.City> data) {
    final items = data.map((e) {
      return DropdownMenuItem(
        value: e.name,
        child: Column(
          children: [
            data.first == e
                ? SizedBox.shrink()
                : Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE0E0E0),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  e.name,
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
    return items;
  }
}
