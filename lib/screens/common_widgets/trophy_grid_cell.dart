import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trophyapp/model/trophy.dart';
import 'package:trophyapp/model/user.dart';

class TrophyGridCell extends GridCell {
  final List<Trophy> trophy;
  final int index;

  TrophyGridCell({this.trophy, this.index});

  @override
  Widget getCheckMark() => SizedBox.shrink();

  @override
  String getName() => trophy[index].name;

  @override
  Widget getIcon() => SizedBox.shrink();

  @override
  String getSubTitle() => '${trophy[index].point} points';

  @override
  ImageProvider getAvatar() => NetworkImage(trophy[index].image);
}

class UserGridCell extends GridCell {
  final List<User> user;
  final int index;

  UserGridCell({this.user, this.index});

  @override
  Widget getCheckMark() {
    if (user[index].type == 0 && user[index].isVerified == true) {
      return SvgPicture.asset(
        'assets/img/check_mark_in_a_circle.svg',
        width: 32.0,
      );
    } else if (user[index].type == 1 && user[index].isVerified == true) {
      return Image.asset(
        'assets/img/checkmark_moderator.png',
        width: 32.0,
      );
    }
    return null;
  }

  @override
  String getName() => user[index].name;

  @override
  Widget getIcon() => SvgPicture.asset(
        'assets/img/geopoint.svg',
        color: const Color(0xFF434345),
      );

  @override
  String getSubTitle() => user[index].country;

  @override
  ImageProvider getAvatar() {
    if (user[index].avatar != null) {
      return NetworkImage(user[index].avatar);
    } else {
      return AssetImage('assets/img/account_photo_placeholder.png');
    }
  }
}

abstract class GridCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x12000000),
              spreadRadius: 0.0,
              blurRadius: 3.0,
              offset: Offset(0, 2),
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 40,
                backgroundImage: getAvatar(),
                child: Align(
                  alignment: Alignment(2.7, -1.0),
                  child: getCheckMark(),
                ),
              ),
            ),
            SizedBox(
              height: 11,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getName(),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.raleway(
                    fontSize: 18.0,
                    letterSpacing: 0.48,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF434345),
                    fontFeatures: [FontFeature.liningFigures()],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getIcon(),
                SizedBox(
                  width: 4,
                ),
                Text(
                  getSubTitle(),
                  style: GoogleFonts.raleway(
                    fontSize: 14.0,
                    letterSpacing: 0.48,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF434345),
                    fontFeatures: [FontFeature.liningFigures()],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getCheckMark();

  String getName();

  Widget getIcon();

  String getSubTitle();

  ImageProvider getAvatar();
}
