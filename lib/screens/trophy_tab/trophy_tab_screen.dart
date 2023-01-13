import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/client/app_provider.dart';
import 'package:trophyapp/constants/theme_defaults.dart';
import 'package:trophyapp/model/user.dart';
import 'package:trophyapp/model/trophy.dart';
import 'package:trophyapp/screens/common_widgets/trophy_grid_cell.dart';
import 'package:trophyapp/screens/profile/user_profile/user_profile.dart';
import 'package:trophyapp/screens/profile/user_profile/user_profile_provider.dart';
import 'package:trophyapp/screens/trophy_details/trophy_details.dart';
import 'package:trophyapp/screens/trophy_details/trophy_details_provider.dart';
import 'package:trophyapp/screens/trophy_tab/trophy_tab_provider.dart';

//TODO: For testing frontend only
final bool userModer = true;

class TrophyTabScreen extends StatefulWidget {
  @override
  _TrophyTabScreenState createState() => _TrophyTabScreenState();
}

class _TrophyTabScreenState extends State<TrophyTabScreen> {
  Future<List<User>> users;
  Future<List<Trophy>> trophies;
  String _uId;

  @override
  void initState() {
    _uId = context.read<AppProvider>().currentUser.uid;
    users = context.read<TrophyTabProvider>().getUsers(_uId);
    trophies = context.read<TrophyTabProvider>().getTrophy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrophyTabProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              child: Column(
                children: [
                  _HeaderView(),
                  SizedBox(height: 12),
                  provider.gridState == TrophyGridState.showsTrophies
                      ? provider.isSearching
                          ? _GridTrophy(snapshot: provider.searchTrophyList)
                          : FutureBuilder<List<Trophy>>(
                              future: trophies,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return _GridTrophy(snapshot: snapshot.data);
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text(snapshot.error.toString()));
                                }
                                return Center(
                                    child: CircularProgressIndicator());
                              })
                      : provider.isSearching
                          ? _GridUsers(snapshot: provider.searchUserList)
                          : FutureBuilder<List<User>>(
                              future: users,
                              builder: (context, snapshot) {
                                if (snapshot.hasData)
                                  return _GridUsers(snapshot: snapshot.data);
                                if (snapshot.hasError)
                                  return Text(snapshot.error.toString());

                                return Container(
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrophyTabProvider>(context);
    return Column(children: [
      Stack(
        children: [
          Column(
            children: [
              Align(alignment: Alignment.center),
              Container(
                //width: 414,
                height: 158,
                decoration: BoxDecoration(
                  color: Color(0xFFCC9E40),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      offset: Offset(0.0, 7),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 25.0),
              Padding(
                padding: EdgeInsets.all(30),
                child: Container(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    onChanged: (String val) {
                      provider.gridState == TrophyGridState.showsTrophies
                          ? provider.searchTrophy(val)
                          : provider.searchUsers(val);
                    },
                    style: GoogleFonts.raleway(
                        color: ThemeDefaults.textColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFeatures: [FontFeature.enable('lnum')]),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      contentPadding: EdgeInsets.only(
                          top: 20, right: 30, bottom: 10, left: 30),
                      hintText: 'Search',
                      prefixIcon: Container(
                        padding: EdgeInsets.only(
                            top: 20, right: 30, bottom: 10, left: 30),
                        child: SvgPicture.asset(
                          'assets/img/search_icon.svg',
                          width: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => provider
                              .setGridState(TrophyGridState.showsTrophies),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5.0,
                                  offset: Offset(0.0, 7),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                height: 32.0,
                                color: provider.gridState ==
                                        TrophyGridState.showsTrophies
                                    ? ThemeDefaults.textColor
                                    : ThemeDefaults.tfFillColor,
                                child: Text(
                                  'IRLAs',
                                  style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: provider.gridState ==
                                              TrophyGridState.showsTrophies
                                          ? Color(0xFFCC9E40)
                                          : Colors.black,
                                      fontFeatures: [
                                        FontFeature.enable('lnum')
                                      ]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              provider.setGridState(TrophyGridState.showsUsers),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5.0,
                                  offset: Offset(0.0, 7),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                topRight: Radius.circular(20.0),
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.circular(20.0),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                height: 32.0,
                                color: provider.gridState ==
                                        TrophyGridState.showsUsers
                                    ? ThemeDefaults.textColor
                                    : ThemeDefaults.tfFillColor,
                                child: Text(
                                  'Users',
                                  style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      fontFeatures: [
                                        FontFeature.enable('lnum')
                                      ],
                                      color: provider.gridState ==
                                              TrophyGridState.showsTrophies
                                          ? Colors.black
                                          : Color(0xFFCC9E40)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                    ],
                  ),
                  userModer ? _ModerBar(provider) : Container()
                ],
              ),
            ],
          ),
        ],
      )
    ]);
  }
}

bool _showAll = false;

class _ModerBar extends StatefulWidget {
  final TrophyTabProvider provider;

  _ModerBar(this.provider);

  @override
  __ModerBarState createState() => __ModerBarState();
}

class __ModerBarState extends State<_ModerBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0, right: 0, bottom: 40, left: 0),
        ),
        SizedBox(width: 30.0),

        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _showAll = !_showAll;
                });
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFCC9E40),
                  // color: Colors.white,
                ),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: !_showAll
                        ? Icon(
                            Icons.check,
                            size: 15.0,
                            color: Colors.black,
                          )
                        : Icon(
                            Icons.check_box_outline_blank,
                            size: 15.0,
                            color: Color(0xFFCC9E40),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(width: 10.0),
        Expanded(
          child: GestureDetector(
            onTap: () =>
                widget.provider.setGridState(TrophyGridState.showsTrophies),
            child: Container(
              child: Text(
                widget.provider.gridState == TrophyGridState.showsTrophies
                    ? 'All IRLAs'
                    : 'All users',
                style: GoogleFonts.raleway(
                    fontFeatures: [FontFeature.enable('lnum')],
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: widget.provider.showAll
                        ? ThemeDefaults.textColor
                        : ThemeDefaults.inactiveColor),
              ),
            ),
          ),
        ),
        // SizedBox(width: 10),

        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _showAll = !_showAll;
                });
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFCC9E40),
                  // color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: _showAll
                      ? Icon(
                          Icons.check,
                          size: 15.0,
                          color: Colors.black,
                        )
                      : Icon(
                          Icons.check_box_outline_blank,
                          size: 15.0,
                          color: Color(0xFFCC9E40),
                        ),
                ),
              ),
            ),
          ],
        ),
        // Row(
        //   children: [
        //     GestureDetector(
        //       behavior: HitTestBehavior.opaque,
        //       onTap: () => widget._provider.setModerState(),
        //       child: Container(
        //         width: 20,
        //         height: 20,
        //         child: MaterialButton(
        //           shape: CircleBorder(
        //               side: BorderSide(
        //                   width: 2,
        //                   color: Colors.black,
        //                   style: BorderStyle.solid)),
        //           // color: Colors.white,
        //           textColor: Colors.amber,
        //           color: widget._provider.showAll
        //               ? ThemeDefaults.containerColor
        //               : ThemeDefaults.textColor,
        //           onPressed: () {},
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => widget.provider.setModerState(),
            child: Row(
              children: [
                Text(
                  'Waiting for Approval',
                  style: GoogleFonts.raleway(
                      fontFeatures: [FontFeature.enable('lnum')],
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                      color: widget.provider.showAll
                          ? ThemeDefaults.textColor
                          : ThemeDefaults.containerColor),
                ),
              ],
            ),
          ),
        ),
        //SizedBox(width: 50),
      ],
    );
  }
}

class _GridTrophy extends StatelessWidget {
  final int index;
  final List<Trophy> snapshot;

  _GridTrophy({this.index, this.snapshot});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: snapshot.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 5.0),
                  child: Text(
                    '${index.toString()} Category',
                    style: GoogleFonts.raleway(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      fontFeatures: [FontFeature.enable('lnum')],
                    ),
                  ),
                ),
                GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider(
                                          create: (_) => TrophyDetailProvider(),
                                          child: TrophyDetails(
                                            trophy: snapshot[index],
                                          ),
                                        )));
                          },
                          child:
                              TrophyGridCell(trophy: snapshot, index: index));
                    }),
              ],
            ),
          );
        });
  }
}

class _GridUsers extends StatelessWidget {
  final List<User> snapshot;

  _GridUsers({this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 5.0),
          ),
          GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      User user = snapshot[index];
                      print('User data : ${user.id}');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                  create: (_) => UserProfileProvider(),
                                  child: UserProfile(
                                    user: user,
                                  ))));
                    },
                    child: UserGridCell(
                      user: snapshot,
                      index: index,
                    ));
              }),
        ],
      ),
    );
  }
}
