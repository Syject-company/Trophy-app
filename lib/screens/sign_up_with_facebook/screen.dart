import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/geography/geography.dart' as geo;
import 'package:trophyapp/helpers/snackbar_presenter.dart';
import 'package:trophyapp/screens/common_widgets/trophy_dropdown_button.dart';
import 'package:trophyapp/screens/common_widgets/trophy_text_button.dart';
import 'package:trophyapp/screens/common_widgets/trophy_text_field.dart';
import 'package:trophyapp/screens/common_widgets/trophy_title.dart';

import 'provider.dart';

class SignUpWithFacebookScreen extends StatefulWidget {
  const SignUpWithFacebookScreen({Key key}) : super(key: key);

  @override
  _SignUpWithFacebookScreenState createState() =>
      _SignUpWithFacebookScreenState();
}

class _SignUpWithFacebookScreenState extends State<SignUpWithFacebookScreen> {
  Future<List<geo.Country>> _countries = Future.value();
  Future<List<geo.State>> _states = Future.value([]);
  Future<List<geo.City>> _cities = Future.value([]);
  SignUpWithFacebookProvider _provider = SignUpWithFacebookProvider();
  Future<void> _getFacebookData;

  @override
  void initState() {
    _countries = geo.Geography().getCountries();
    _getFacebookData = _provider.initDataFromFacebook();
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
                      onTap: () async {
                        Navigator.pop(context);
                      },
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
                              'Sign Up With Facebook',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF434345),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 22),
                        ChangeNotifierProvider.value(
                          value: _provider,
                          child: Builder(builder: (context) {
                            final provider =
                                Provider.of<SignUpWithFacebookProvider>(
                                    context);
                            return FutureBuilder(
                              future: _getFacebookData,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasError) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    SnackbarPresenter.showErrorMessageSnackbar(
                                        context, snapshot.error.toString());
                                  });
                                  return TrophyTextButton(
                                    text: 'Login to Continue',
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
                                      _getFacebookData =
                                          provider.initDataFromFacebook();
                                    },
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          final _imagePicker = ImagePicker();
                                          final image = await _imagePicker
                                              .pickImage(
                                                  source: ImageSource.gallery)
                                              .catchError((err) {
                                            SnackbarPresenter
                                                .showErrorMessageSnackbar(
                                                    context, err.toString());
                                          });
                                          if (image != null) {
                                            provider
                                                .setImageFile(File(image.path));
                                          }
                                        },
                                        child: CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Color(0xFFE0E0E0),
                                          backgroundImage: _getAvatar(provider),
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
                                                        BorderRadius.circular(
                                                            13),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 7,
                                                        spreadRadius: 0,
                                                        offset: Offset(0, 0),
                                                        color:
                                                            Color(0x1A000000),
                                                      )
                                                    ]),
                                                child: SvgPicture.asset(
                                                  provider.imageUrl.isEmpty &&
                                                          provider
                                                              .imageLocalPath
                                                              .isEmpty
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
                                        initialValue: provider.email,
                                        commentText:
                                            "Won't be publicly displayed",
                                        errorText: provider.emailError,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        leadingIconPath:
                                            'assets/img/email_icon.svg',
                                        onChanged: (email) =>
                                            provider.email = email,
                                      ),
                                      SizedBox(height: 8),
                                      TrophyTextField(
                                        hint: 'Password for IRLA forums',
                                        commentText:
                                            'Password should have at least 10 symbols',
                                        errorText:
                                            provider.discoursePasswordError,
                                        leadingIconPath:
                                            'assets/img/password_icon.svg',
                                        eyeIconPath: 'assets/img/eye_icon.svg',
                                        crossedOutEyeIconPath:
                                            'assets/img/crossed_out_eye_icon.svg',
                                        obscureText: true,
                                        onChanged: (password) => provider
                                            .discoursePassword = password,
                                      ),
                                      SizedBox(height: 8),
                                      TrophyTextField(
                                        hint: 'Confirm Password',
                                        errorText: provider
                                            .confirmDiscoursePasswordError,
                                        leadingIconPath:
                                            'assets/img/password_icon.svg',
                                        eyeIconPath: 'assets/img/eye_icon.svg',
                                        crossedOutEyeIconPath:
                                            'assets/img/crossed_out_eye_icon.svg',
                                        obscureText: true,
                                        onChanged: (confirmPassword) =>
                                            provider.confirmDiscoursePassword =
                                                confirmPassword,
                                      ),
                                      SizedBox(height: 8),
                                      TrophyTextField(
                                        hint: 'Username',
                                        initialValue: provider.username,
                                        errorText: provider.usernameError,
                                        leadingIconPath:
                                            'assets/img/user_icon.svg',
                                        onChanged: (username) =>
                                            provider.username = username,
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
                                              value:
                                                  provider.countryName.isEmpty
                                                      ? null
                                                      : provider.countryName,
                                              onChanged: (newValue) {
                                                provider.countryName = newValue;
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
                                            return Text(
                                                snapshot.error.toString());
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
                                                _cities = geo.Geography()
                                                    .getCities(
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
                                            return Text(
                                                snapshot.error.toString());
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
                                            return Text(
                                                snapshot.error.toString());
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      ),
                                      SizedBox(height: 43),
                                      provider.isLoading
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : TrophyTextButton(
                                              text: 'Sign Up',
                                              textStyle: GoogleFonts.raleway(
                                                color: Color(0xFF3B5998),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.48,
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                              borderWidth: 1.5,
                                              borderColor: Color(0xFF3B5998),
                                              icon: SvgPicture.asset(
                                                  'assets/img/facebook_icon.svg'),
                                              onPressed: provider.canContinue()
                                                  ? () async {
                                                      try {
                                                        await provider
                                                            .signUpWithFacebook();
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
                                                        Navigator.popUntil(
                                                            context,
                                                            (route) =>
                                                                route.isFirst);
                                                      } catch (e) {
                                                        print(e);
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
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            );
                          }),
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

  Object _getAvatar(SignUpWithFacebookProvider provider) {
    if (provider.imageLocalPath.isNotEmpty) {
      return FileImage(File(provider.imageLocalPath));
    } else if (provider.imageUrl.isNotEmpty) {
      return NetworkImage(provider.imageUrl);
    } else {
      return AssetImage('assets/img/avatar_icon.png');
    }
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

  @override
  void dispose() {
    super.dispose();
    FacebookAuth.instance.logOut();
  }
}
