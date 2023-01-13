import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/constants/theme_defaults.dart';
import 'package:trophyapp/helpers/snackbar_presenter.dart';
import 'package:trophyapp/screens/common_widgets/trophy_text_field.dart';
import 'package:trophyapp/screens/profile/profile_change_password/profile_change_password_provider.dart';

class ProfileChangePassword extends StatelessWidget {
  final String email;

  ProfileChangePassword(this.email);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F7),
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14.0, 32.0, 14.0, 14.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3.0,
                  offset: Offset(0.0, 2.0),
                  color: Colors.black.withOpacity(0.07),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SvgPicture.asset(
                      'assets/img/dialog_frame.svg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 30.0),
                      _buildNewPasswordInput(context),
                      const SizedBox(height: 40.0),
                      _buildFooter(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(106.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 3.0,
              offset: const Offset(0.0, 2.0),
              color: Colors.black.withOpacity(0.07),
            ),
          ],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0.0, 0.0, 26.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset('assets/img/close_icon.svg'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 24.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Change Password',
                  style: GoogleFonts.raleway(
                    fontSize: 18.0,
                    letterSpacing: 0.48,
                    fontWeight: FontWeight.w600,
                    color: ThemeDefaults.primaryTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewPasswordInput(BuildContext context) {
    final provider = context.watch<ChangePasswordProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(21.0, 0.0, 21.0, 0.0),
      child: Column(
        children: [
          TrophyTextField(
            hint: 'Old Password',
            leadingIconPath: 'assets/img/password_icon.svg',
            eyeIconPath: 'assets/img/eye_icon.svg',
            crossedOutEyeIconPath: 'assets/img/crossed_out_eye_icon.svg',
            obscureText: true,
            onChanged: provider.setPassword,
          ),
          TrophyTextField(
            hint: 'New Password',
            commentText: 'Min 6 characters',
            leadingIconPath: 'assets/img/password_icon.svg',
            eyeIconPath: 'assets/img/eye_icon.svg',
            crossedOutEyeIconPath: 'assets/img/crossed_out_eye_icon.svg',
            obscureText: true,
            onChanged: provider.newPassword,
          ),
          TrophyTextField(
            hint: 'Confirm New Password',
            leadingIconPath: 'assets/img/password_icon.svg',
            eyeIconPath: 'assets/img/eye_icon.svg',
            crossedOutEyeIconPath: 'assets/img/crossed_out_eye_icon.svg',
            obscureText: true,
            onChanged: provider.confirmPassword,
          ),
          const SizedBox(height: 40.0),
          ElevatedButton(
            onPressed: provider.canContinue
                ? () async {
                    final result =
                        await provider.submitPassword(email).catchError((e) {
                      SnackbarPresenter.showErrorMessageSnackbar(
                          context, e.toString());
                    });
                    if (result != null) {
                      SnackbarPresenter.showSuccessMessageSnackbar(
                          context, 'Password changed successfully!');
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              elevation: 0.0,
              primary: ThemeDefaults.primaryColor,
              minimumSize: const Size(double.infinity, 40.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              splashFactory: NoSplash.splashFactory,
            ),
            child: provider.isLoading
                ? Container(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      strokeWidth: 3.0,
                    ),
                  )
                : Text(
                    'Change Password',
                    style: GoogleFonts.raleway(
                      fontSize: 16.0,
                      letterSpacing: 0.48,
                      fontWeight: FontWeight.w600,
                      color: ThemeDefaults.primaryTextColor,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0.0),
          child: SvgPicture.asset(
            'assets/img/dialog_top.svg',
            width: constraints.maxWidth,
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 4.0),
          child: SvgPicture.asset(
            'assets/img/dialog_bottom.svg',
            width: constraints.maxWidth,
          ),
        );
      },
    );
  }
}
