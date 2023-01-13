import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/constants/theme_defaults.dart';
import 'package:trophyapp/model/ref_trophy_category.dart';
import 'package:trophyapp/screens/profile/user_profile/user_profile_provider.dart';
import 'package:trophyapp/model/user.dart' as usr;
import 'package:trophyapp/screens/trophy_achivements/trophy_achivements.dart';
import 'package:trophyapp/screens/trophy_achivements/trophy_achivements_provider.dart';
import 'package:trophyapp/screens/trophy_list/trophy_list.dart';

//TODO: это страница пользователей выбраных в друзьях или в списке пользователей
class UserProfile extends StatefulWidget {
  final usr.User user;
  final String _userId = FirebaseAuth.instance.currentUser.uid;
  UserProfile({this.user});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Future<usr.User> currentUser;

  @override
  void initState() {
    context
        .read<UserProfileProvider>()
        .checkFriend(widget._userId, widget.user.id);
    context.read<UserProfileProvider>().getProfileData(widget.user.id);
    currentUser =
        context.read<UserProfileProvider>().getCurrentUser(widget._userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProfileProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: 60.0, left: 8.0, right: 8.0, bottom: 28.0),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(-3, 5))
                ]),
                child: _header(context, provider),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        color: provider.statScreen
                                            ? ThemeDefaults.inactiveColor
                                            : ThemeDefaults.primaryColor,
                                        width: 1.0))),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(0.0),
                              ),
                              onPressed: () => provider.changeScreen(),
                              child: Text('IRLAs',
                                  style: provider.statScreen
                                      ? GoogleFonts.raleway(
                                          fontFeatures: [
                                              FontFeature.enable('lnum')
                                            ],
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)
                                      : GoogleFonts.raleway(
                                          fontFeatures: [
                                              FontFeature.enable('lnum')
                                            ],
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: ThemeDefaults.primaryColor)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        color: provider.statScreen
                                            ? ThemeDefaults.primaryColor
                                            : ThemeDefaults.inactiveColor,
                                        width: 1.0))),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(0.0),
                              ),
                              onPressed: () => provider.changeScreen(),
                              child: Text(
                                'CATEGORIES',
                                style: provider.statScreen
                                    ? GoogleFonts.raleway(
                                        fontFeatures: [
                                            FontFeature.enable('lnum')
                                          ],
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: ThemeDefaults.primaryColor)
                                    : GoogleFonts.raleway(
                                        fontFeatures: [
                                            FontFeature.enable('lnum')
                                          ],
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 28.0, right: 28.0, top: 40.0, bottom: 14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '13 IRLAs',
                            style: GoogleFonts.raleway(
                                fontFeatures: [FontFeature.enable('lnum')],
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600),
                          ),
                          Text('12132 points',
                              style: GoogleFonts.raleway(
                                  fontFeatures: [FontFeature.enable('lnum')],
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              provider.statScreen
                  ? _trophyChart(context, provider)
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) => _GridView(
                            category: index,
                          )),
            ],
          ),
        ),
      ),
    );
  }

  _header(BuildContext context, UserProfileProvider provider) {
    return Column(
      children: [
        Container(
          height: 40.0,
          padding: EdgeInsets.only(left: 0.0),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/img/arrow_back_appbar.png',
                    width: 10,
                    height: 17,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'User',
                  style: GoogleFonts.raleway(
                      fontFeatures: [FontFeature.enable('lnum')],
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 29.0,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50.0,
                              backgroundImage: NetworkImage(widget.user.avatar),
                            ),
                            //_getUserCheckmark(widget.user.type.id),
                            _getUserCheckmark(
                                userType: widget.user.type,
                                isVerified: widget.user.isVerified)
                          ],
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // widget.user.name,
                              // // overflow: TextOverflow.clip,
                              widget.user.name.length <= 13
                                  ? widget.user.name
                                  : widget.user.name.substring(0, 13) + '..',
                              style: GoogleFonts.raleway(
                                  fontFeatures: [FontFeature.enable('lnum')],
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset('assets/img/geopoint.svg'),
                                SizedBox(
                                  width: 4.0,
                                ),
                                Text(
                                  widget.user.country,
                                  style: GoogleFonts.raleway(
                                      fontFeatures: [
                                        FontFeature.enable('lnum')
                                      ],
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              widget.user.email,
                              style: GoogleFonts.raleway(
                                  fontFeatures: [FontFeature.enable('lnum')],
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.5)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
              )
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(top: 28.0, left: 10.0, right: 10.0),
                  padding: EdgeInsets.all(8.0),
                  height: 60.0,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5.0,
                        offset: Offset(0.0, 3))
                  ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset('assets/img/level.png'),
                              Text(widget.user.level.id.toString())
                            ],
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('lvl ${widget.user.level.id}',
                                  style: GoogleFonts.raleway(
                                      fontFeatures: [
                                        FontFeature.enable('lnum')
                                      ],
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeDefaults.inactiveColor)),
                              Text(
                                'Piratik',
                                style: GoogleFonts.raleway(
                                    fontFeatures: [FontFeature.enable('lnum')],
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    color: ThemeDefaults.textColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 140.0,
                              child: LinearProgressIndicator(
                                  value: 0.75,
                                  backgroundColor: Color(0xFFF2F2F2),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      ThemeDefaults.progressIndicator)),
                            ),
                            Text(
                              '${widget.user.point.toString()}/1400',
                              style: GoogleFonts.raleway(
                                  fontFeatures: [FontFeature.enable('lnum')],
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            )
          ],
        ),
        Container(
          padding: EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            top: 28.0,
          ),
          child: Row(children: [
            Expanded(
                child: Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                        color: provider.isFollowing
                            ? Colors.white
                            : ThemeDefaults.primaryColor,
                        border: Border.all(
                            color: ThemeDefaults.primaryColor, width: 1.0)),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0.0),
                      ),
                      onPressed: () async => await provider.followButton(
                          widget._userId, widget.user.id),
                      child: Text(
                        provider.isFollowing ? 'Unfollow' : 'Follow',
                        style: GoogleFonts.raleway(
                          fontFeatures: [FontFeature.enable('lnum')],
                          color: provider.isFollowing
                              ? ThemeDefaults.primaryColor
                              : Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ))),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                            create: (_) => TrophyAchivementsProvider(),
                            child: TrophyAchivements()))),
                child: Container(
                    height: 40.0,
                    color: ThemeDefaults.secondaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tracked IRLAs',
                          style: GoogleFonts.raleway(
                              fontFeatures: [FontFeature.enable('lnum')],
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16.0),
                        ),
                        SizedBox(
                          width: 6.0,
                        ),
                        SvgPicture.asset(
                          'assets/img/bookmark_icon.svg',
                          width: 16.0,
                          height: 16.0,
                        ),
                      ],
                    )),
              ),
            )
          ]),
        ),
        FutureBuilder<usr.User>(
            future: currentUser,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data.type == 2 || widget.user.type != 2
                    ? Container(
                        padding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 10.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 40.0,
                                decoration: BoxDecoration(
                                    color: widget.user.type == 1
                                        ? Colors.white
                                        : Colors.red,
                                    border: widget.user.type == 1
                                        ? Border.all(color: Colors.red)
                                        : null),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(0.0),
                                  ),
                                  onPressed: () async =>
                                      await provider.verifyButton(widget.user),
                                  child: Text(
                                    provider.isVerified == true
                                        ? 'Unverify'
                                        : 'Verify',
                                    style: GoogleFonts.raleway(
                                        fontFeatures: [
                                          FontFeature.enable('lnum')
                                        ],
                                        fontSize: 18.0,
                                        fontWeight: widget.user.type == 1
                                            ? FontWeight.w800
                                            : FontWeight.w800,
                                        color: widget.user.type == 1
                                            ? Colors.red
                                            : Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container();
              }
              return Container();
            })
      ],
    );
  }

  _trophyChart(BuildContext context, UserProfileProvider provider) {
    return Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.all(24.0),
        padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 12.0),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 3,
              offset: Offset(0, 5))
        ]),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Completed IRLAs',
                    style: GoogleFonts.raleway(
                        fontFeatures: [FontFeature.enable('lnum')],
                        fontSize: 22.0,
                        fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _modal(context),
                      child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 40,
                          child: SvgPicture.asset(
                            'assets/img/filter.svg',
                            color: Color(0xFF828282),
                          )))
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              PieChart(
                dataMap: provider.data,
                legendStyle: GoogleFonts.raleway(
                    fontFeatures: [FontFeature.enable('lnum')],
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500),
                chartValueStyle: GoogleFonts.dmSans(
                    fontSize: 16.0, fontWeight: FontWeight.w500),
                animationDuration: Duration(seconds: 1),
                chartLegendSpacing: 10.0,
                chartRadius: 196.0,
                showChartValuesInPercentage: true,
                showChartValues: true,
                showChartValuesOutside: false,
                colorList: [
                  Color(0xFF56CCF2),
                  Color(0xFF219653),
                  Colors.red,
                  ThemeDefaults.primaryColor,
                  ThemeDefaults.secondaryColor,
                ],
                legendPosition: LegendPosition.bottom,
                showLegends: true,
                decimalPlaces: 1,
                legendRow: false,
                legendRounded: true,
                initialAngle: 0,
              ),
            ],
          ),
        ));
  }

  _modal(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return ChangeNotifierProvider(
            create: (_) => UserProfileProvider(),
            child: SimpleDialog(
              titlePadding: EdgeInsets.all(25.0),
              title: Column(
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text('Select',
                            style: GoogleFonts.raleway(
                                fontSize: 24.0, fontWeight: FontWeight.w700)),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            child: SvgPicture.asset('assets/img/dismis_X.svg'),
                            onTap: () => Navigator.pop(context)),
                      ),
                    ],
                  ),
                ],
              ),
              children: [
                Consumer<UserProfileProvider>(builder: (context, value, child) {
                  return Container(
                    padding: EdgeInsets.only(left: 20.0, top: 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => value.chartOption(1),
                          child: Container(
                            padding: EdgeInsets.all(2.0),
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black)),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: value.options == 1
                                    ? ThemeDefaults.primaryColor
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 26.0,
                        ),
                        Text(
                          '1 Category',
                          style: GoogleFonts.raleway(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              fontFeatures: [FontFeature.enable('lnum')]),
                        )
                      ],
                    ),
                  );
                }),
                Consumer<UserProfileProvider>(builder: (context, value, child) {
                  return Container(
                    padding: EdgeInsets.only(left: 20.0, top: 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => value.chartOption(2),
                          child: Container(
                            padding: EdgeInsets.all(2.0),
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black)),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: value.options == 2
                                    ? ThemeDefaults.primaryColor
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 26.0,
                        ),
                        Text(
                          '2 Category',
                          style: GoogleFonts.raleway(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              fontFeatures: [FontFeature.enable('lnum')]),
                        )
                      ],
                    ),
                  );
                }),
                Consumer<UserProfileProvider>(builder: (context, value, child) {
                  return Container(
                    padding: EdgeInsets.only(left: 20.0, top: 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => value.chartOption(3),
                          child: Container(
                            padding: EdgeInsets.all(2.0),
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black)),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: value.options == 3
                                    ? ThemeDefaults.primaryColor
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 26.0,
                        ),
                        Text(
                          '3 Category',
                          style: GoogleFonts.raleway(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              fontFeatures: [FontFeature.enable('lnum')]),
                        )
                      ],
                    ),
                  );
                }),
                Consumer<UserProfileProvider>(builder: (context, value, child) {
                  return Container(
                    padding: EdgeInsets.only(left: 20.0, top: 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => value.chartOption(4),
                          child: Container(
                            padding: EdgeInsets.all(2.0),
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black)),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: value.options == 4
                                    ? ThemeDefaults.primaryColor
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 26.0,
                        ),
                        Text(
                          '4 Category',
                          style: GoogleFonts.raleway(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              fontFeatures: [FontFeature.enable('lnum')]),
                        )
                      ],
                    ),
                  );
                }),
                Consumer<UserProfileProvider>(builder: (context, value, child) {
                  return Container(
                    padding: EdgeInsets.only(left: 20.0, top: 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => value.chartOption(5),
                          child: Container(
                            padding: EdgeInsets.all(2.0),
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black)),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: value.options == 5
                                    ? ThemeDefaults.primaryColor
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 26.0,
                        ),
                        Text(
                          '5 Category',
                          style: GoogleFonts.raleway(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              fontFeatures: [FontFeature.enable('lnum')]),
                        )
                      ],
                    ),
                  );
                }),
                Consumer<UserProfileProvider>(builder: (context, value, child) {
                  return GestureDetector(
                    onTap: value.options == 0
                        ? null
                        : () => Navigator.pop(context),
                    child: Container(
                      height: 40.0,
                      margin: EdgeInsets.all(20),
                      color: value.options == 0
                          ? ThemeDefaults.inactiveColor
                          : ThemeDefaults.primaryColor,
                      child: Center(
                          child: Text('OK',
                              style: GoogleFonts.raleway(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w800))),
                    ),
                  );
                })
              ],
            ),
          );
        });
  }

  Widget _getUserCheckmark({int userType, bool isVerified}) {
    if (userType == 0 && isVerified == true) {
      return Image.asset(
        'assets/img/checkmark_verified.png',
        width: 32.0,
      );
    } else if (userType == 1 && isVerified == true) {
      return Image.asset(
        'assets/img/checkmark_moderator.png',
        width: 32.0,
      );
    } else {
      return Container();
    }
  }
}

class _GridView extends StatelessWidget {
  final int category;

  _GridView({this.category});

  @override
  Widget build(BuildContext context) {
    // final _provider = Provider.of<UserProfileProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 5.0, right: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${category.toString()} Category',
                  style: GoogleFonts.raleway(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    fontFeatures: [FontFeature.enable('lnum')],
                  ),
                ),
                GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TrophyList(
                                  category: TrophyCategory(
                                      id: category,
                                      name: 'No Category',
                                      icon: ''),
                                ))),
                    child: Container(
                        alignment: Alignment.center,
                        height: 25.0,
                        width: 50.0,
                        child: Text(
                          'See All',
                          style: GoogleFonts.raleway(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              fontFeatures: [FontFeature.enable('lnum')],
                              color: Color(0xFF2D9CDB)),
                        ))),
              ],
            ),
          ),
          // GridView.builder(
          //     shrinkWrap: true,
          //     physics: NeverScrollableScrollPhysics(),
          //     itemCount: 2,
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          //     itemBuilder: (context, index) {
          //       return GestureDetector(
          //           behavior: HitTestBehavior.opaque,
          //           onTap: () => Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) =>
          //                       ChangeNotifierProvider(create: (_) => UserTrophyProvider(), child: UserTrophy()))),
          //           child: TrophyGridCellOld.forTrophy(_provider.mockedTrophies[index]));
          //     }),
        ],
      ),
    );
  }
}
