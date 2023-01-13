import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/constants/theme_defaults.dart';
import 'package:trophyapp/model/countries.dart';
import 'package:trophyapp/screens/common_widgets/trophy_textfield.dart';
import 'package:trophyapp/screens/leader_board/leader_board_provider.dart';

class LeaderBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LeaderBoardProvider provider = Provider.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LeaderAppBar(provider),
            LeaderBody(provider),
            LeaderList(provider),
          ],
        ),
      ),
    );
  }
}

class LeaderAppBar extends StatelessWidget {
  final LeaderBoardProvider provider;

  LeaderAppBar(this.provider);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            EdgeInsets.only(left: 28.0, right: 28.0, top: 64.0, bottom: 24.0),
        height: 165.0,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 0),
              spreadRadius: 5.0,
              blurRadius: 6.0)
        ]),
        child: Column(
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/img/arrow_back_appbar.png',
                      width: 16,
                      height: 12,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Leaderboard',
                    style: GoogleFonts.raleway(
                        fontFeatures: [FontFeature.enable('lnum')],
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 24.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => provider.changeTab(0),
                    child: Container(
                        alignment: Alignment.center,
                        color: provider.tabIndex == 0
                            ? ThemeDefaults.primaryColor
                            : ThemeDefaults.containerColor,
                        height: 32.0,
                        child: Text(
                          'The week',
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.0,
                              color: provider.tabIndex == 0
                                  ? Colors.white
                                  : Colors.black),
                        )),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => provider.changeTab(1),
                    child: Container(
                        alignment: Alignment.center,
                        color: provider.tabIndex == 1
                            ? ThemeDefaults.primaryColor
                            : ThemeDefaults.containerColor,
                        height: 32.0,
                        child: Text(
                          'This month',
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.0,
                              color: provider.tabIndex == 1
                                  ? Colors.white
                                  : Colors.black),
                        )),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => provider.changeTab(2),
                    child: Container(
                        alignment: Alignment.center,
                        color: provider.tabIndex == 2
                            ? ThemeDefaults.primaryColor
                            : ThemeDefaults.containerColor,
                        height: 32.0,
                        child: Text(
                          'All time',
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.0,
                              color: provider.tabIndex == 2
                                  ? Colors.white
                                  : Colors.black),
                        )),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

class LeaderBody extends StatefulWidget {
  final LeaderBoardProvider provider;

  LeaderBody(this.provider);

  @override
  _LeaderBodyState createState() => _LeaderBodyState();
}

class _LeaderBodyState extends State<LeaderBody> {
  Future<CountryList> _countries;
  @override
  void initState() {
    _countries = context.read<LeaderBoardProvider>().getCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final LeaderBoardProvider provider = Provider.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 28.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => widget.provider.checkBox(),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 16.0,
                      height: 16.0,
                      decoration: BoxDecoration(
                          color: widget.provider.showVerify
                              ? ThemeDefaults.secondaryColor
                              : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: widget.provider.showVerify
                                  ? ThemeDefaults.secondaryColor
                                  : ThemeDefaults.inactiveColor)),
                      child: SvgPicture.asset(
                        'assets/img/checkbox_checkmark.svg',
                        width: 9.0,
                        height: 6.0,
                      ),
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    Text(
                      'Only verified users',
                      style: GoogleFonts.raleway(
                          fontSize: 14.0, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _filterDialog(context),
                child: Container(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset('assets/img/leaderboard_filter.svg'),
                ),
              )
            ],
          ),
          SizedBox(
            height: 80.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/img/rating_up.svg'),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          '2',
                          style: GoogleFonts.raleway(
                              fontFeatures: [FontFeature.enable('lnum')],
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 32.0,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              NetworkImage(provider.usersForShow[1].avatar),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: ThemeDefaults.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '2',
                            style: GoogleFonts.raleway(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      provider.usersForShow[1].name,
                      style: GoogleFonts.raleway(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        fontFeatures: [FontFeature.enable('lnum')],
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      provider.usersForShow[1].point.toString(),
                      style: GoogleFonts.raleway(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        fontFeatures: [FontFeature.enable('lnum')],
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/img/rating.svg'),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          '1',
                          style: GoogleFonts.raleway(
                              fontFeatures: [FontFeature.enable('lnum')],
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 48.0,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              NetworkImage(provider.usersForShow[0].avatar),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 6.0),
                          alignment: Alignment.center,
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '1',
                            style: GoogleFonts.raleway(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      provider.usersForShow[0].name,
                      style: GoogleFonts.raleway(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        fontFeatures: [FontFeature.enable('lnum')],
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      provider.usersForShow[0].point.toString(),
                      style: GoogleFonts.raleway(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        fontFeatures: [FontFeature.enable('lnum')],
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/img/rating_down.svg'),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          '3',
                          style: GoogleFonts.raleway(
                              fontFeatures: [FontFeature.enable('lnum')],
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                            provider.usersForShow[2].avatar,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: ThemeDefaults.secondaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '3',
                            style: GoogleFonts.raleway(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                fontFeatures: [FontFeature.enable('lnum')]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      provider.usersForShow[2].name,
                      style: GoogleFonts.raleway(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        fontFeatures: [FontFeature.enable('lnum')],
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      provider.usersForShow[2].point.toString(),
                      style: GoogleFonts.raleway(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        fontFeatures: [FontFeature.enable('lnum')],
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _filterDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return ChangeNotifierProvider(
            create: (_) => LeaderBoardProvider(),
            child: Consumer<LeaderBoardProvider>(
                builder: (context, provider, child) {
              return SimpleDialog(
                title: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                            child: SvgPicture.asset('assets/img/dismis_X.svg'),
                            onTap: () => Navigator.pop(context)),
                      ],
                    ),
                  ],
                ),
                titlePadding: EdgeInsets.all(25.0),
                contentPadding:
                    EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
                children: [
                  Center(
                    child: Text(
                      'Raduis',
                      style: GoogleFonts.raleway(
                          fontFeatures: [FontFeature.enable('lnum')],
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => provider.setMiles(25),
                        child: Container(
                            alignment: Alignment.center,
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.black, width: 1.5)),
                            child: Container(
                              width: 12.0,
                              height: 12.0,
                              decoration: BoxDecoration(
                                  color: provider.miles == 25
                                      ? ThemeDefaults.primaryColor
                                      : Colors.white,
                                  shape: BoxShape.circle),
                            )),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        '25 mile',
                        style: GoogleFonts.raleway(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            fontFeatures: [FontFeature.enable('lnum')]),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => provider.setMiles(50),
                        child: Container(
                            alignment: Alignment.center,
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.black, width: 1.5)),
                            child: Container(
                              width: 12.0,
                              height: 12.0,
                              decoration: BoxDecoration(
                                  color: provider.miles == 50
                                      ? ThemeDefaults.primaryColor
                                      : Colors.white,
                                  shape: BoxShape.circle),
                            )),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        '50 mile',
                        style: GoogleFonts.raleway(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            fontFeatures: [FontFeature.enable('lnum')]),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => provider.setMiles(100),
                        child: Container(
                            alignment: Alignment.center,
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.black, width: 1.5)),
                            child: Container(
                              width: 12.0,
                              height: 12.0,
                              decoration: BoxDecoration(
                                  color: provider.miles == 100
                                      ? ThemeDefaults.primaryColor
                                      : Colors.white,
                                  shape: BoxShape.circle),
                            )),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        '100 mile',
                        style: GoogleFonts.raleway(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            fontFeatures: [FontFeature.enable('lnum')]),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Center(
                      child: Text(
                    'Region',
                    style: GoogleFonts.raleway(
                        fontSize: 24.0, fontWeight: FontWeight.w700),
                  )),
                  SizedBox(
                    height: 32.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Country',
                      style: GoogleFonts.raleway(
                          fontFeatures: [FontFeature.enable('lnum')],
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    height: 50.0,
                    color: ThemeDefaults.tfFillColor,
                    child: FutureBuilder<CountryList>(
                        future: _countries,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return DropdownButtonFormField(
                              isExpanded: true,
                              style: GoogleFonts.raleway(
                                  fontFeatures: [FontFeature.enable('lnum')],
                                  color: ThemeDefaults.textColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                              items: _getItems(snapshot.data.countryList),
                              onChanged: (val) => null,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(right: 10.0, left: 10.0),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: ThemeDefaults.tfFillColor,
                                hintText: 'Indicate your country',
                                hintStyle: GoogleFonts.raleway(
                                    fontFeatures: [FontFeature.enable('lnum')],
                                    color: ThemeDefaults.textColor,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }
                          if (snapshot.hasError)
                            return Text(snapshot.error.toString());
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TrophyTextField('State', (val) => provider.setState(val)),
                  TrophyTextField('City', (val) => provider.setCity(val)),
                  SizedBox(
                    height: 20.0,
                  ),
                  Opacity(
                    opacity: provider.canContinue ? 1.0 : 0.3,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 40.0,
                        color: ThemeDefaults.primaryColor,
                        alignment: Alignment.center,
                        child: Text(
                          'Apply',
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w800,
                              fontSize: 18.0,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
          );
        });
  }

  List<DropdownMenuItem<String>> _getItems(List<Country> data) {
    final items = data.map((e) {
      return DropdownMenuItem(
        value: e.name,
        child: Text(
          e.name,
          style: GoogleFonts.raleway(
              fontFeatures: [FontFeature.enable('lnum')],
              fontWeight: FontWeight.bold,
              fontSize: 18.0),
        ),
      );
    }).toList();
    return items;
  }
}

class LeaderList extends StatelessWidget {
  final LeaderBoardProvider provider;

  LeaderList(this.provider);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
          itemCount: provider.mockedUsers.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) => index < 3
              ? Container()
              : Divider(
                  indent: 110.0,
                  endIndent: 15,
                ),
          itemBuilder: (context, index) {
            return index < 3
                ? Container()
                : ListTile(
                    leading: Container(
                      width: 80.0,
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/img/rating_up.svg'),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            (index + 1).toString(),
                            style: GoogleFonts.raleway(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                fontFeatures: [FontFeature.enable('lnum')]),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                provider.usersForShow[index].avatar),
                            backgroundColor: Colors.white,
                            radius: 20.0,
                          )
                        ],
                      ),
                    ),
                    title: Text(
                      provider.usersForShow[index].name,
                      style: GoogleFonts.raleway(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          fontFeatures: [FontFeature.enable('lnum')]),
                    ),
                    trailing: Text(
                        provider.usersForShow[index].point.toString(),
                        style: GoogleFonts.raleway(
                            fontFeatures: [FontFeature.enable('lnum')],
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0)),
                  );
          }),
    );
  }
}
