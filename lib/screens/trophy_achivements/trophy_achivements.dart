import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/constants/theme_defaults.dart';
import 'package:trophyapp/screens/trophy_achivements/trophy_achivements_provider.dart';
import 'package:trophyapp/screens/trophy_details/trophy_details.dart';
import 'package:trophyapp/screens/trophy_details/trophy_details_provider.dart';

class TrophyAchivements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrophyAchivementsProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(-3, 5))
            ]),
            height: 125.0,
            child: Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 30.0,
                      child: Container(
                        width: 16.0,
                        height: 14.0,
                        child: Image.asset('assets/img/arrow_back_appbar.png'),
                      ),
                    ),
                    Text(
                      'Tracked IRLAs',
                      style: GoogleFonts.raleway(
                          fontFeatures: [FontFeature.enable('lnum')],
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.zero,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: ThemeDefaults.primaryColor,
                    pinned: false,
                    leading: Container(),
                    flexibleSpace: _header(),
                    expandedHeight: 164.0,
                  ),
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    pinned: true,
                    expandedHeight: 40.0,
                    leading: Container(),
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Completed IRLAs',
                            style: GoogleFonts.raleway(
                                fontFeatures: [FontFeature.enable('lnum')],
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () => showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: _modalBottomSheet(context, provider),
                                );
                              },
                            ),
                            child: Container(
                              child: SvgPicture.asset('assets/img/filter.svg'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            provider
                                .getTrophy()
                                .then((trophies) => Navigator.push(
                                    (context),
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChangeNotifierProvider(
                                        create: (_) => TrophyDetailProvider(),
                                        child: TrophyDetails(
                                            trophy: trophies[index]),
                                      ),
                                    )));
                          },
                          child: Container(
                            margin: EdgeInsets.all(4),
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                  color: ThemeDefaults.inactiveColor,
                                  offset: Offset(0, 2),
                                  blurRadius: 2.0,
                                  spreadRadius: 0.0)
                            ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  //backgroundImage: NetworkImage(_provider.mockedTrophies[index].imageURL),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: null,
                                    // _provider.mockedTrophies[index].trophyType == TrophyType.verified
                                    //     ? Image.asset(
                                    //         'assets/img/checkmark_verified.png',
                                    //         width: 24.0,
                                    //       )
                                    //     : null, //_getUserCheckMark(),
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      //_provider.mockedTrophies[index].name,
                                      'Name',
                                      style: GoogleFonts.raleway(
                                          fontFeatures: [
                                            FontFeature.enable('lnum')
                                          ],
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      // 'Completed for ${_provider.mockedTrophies[index].trackDays} Days',
                                      'Completed for ?? Days',
                                      style: GoogleFonts.raleway(
                                          fontFeatures: [
                                            FontFeature.enable('lnum')
                                          ],
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: 3,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _header() {
    return FlexibleSpaceBar(
      background: Container(
        padding: EdgeInsets.only(left: 28.0, top: 36.0),
        child: Column(
          children: [
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
                                ClipRRect(
                                  child: Image.asset(
                                    'assets/img/account_photo_placeholder.png',
                                    width: 80.0,
                                  ),
                                ),
                                Image.asset(
                                  'assets/img/checkmark_verified.png',
                                  width: 32.0,
                                )
                              ],
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jane',
                                  style: GoogleFonts.raleway(
                                      fontFeatures: [
                                        FontFeature.enable('lnum')
                                      ],
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  'Bow St, Covent Garden, London',
                                  style: GoogleFonts.raleway(
                                      fontFeatures: [
                                        FontFeature.enable('lnum')
                                      ],
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  'my-mail@gmail.com',
                                  style: GoogleFonts.raleway(
                                      fontFeatures: [
                                        FontFeature.enable('lnum')
                                      ],
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
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
            PreferredSize(
              preferredSize: Size(100, 45),
              child: DefaultTabController(
                length: 2,
                child: TabBar(
                  indicatorColor: Colors.white,
                  unselectedLabelStyle: GoogleFonts.raleway(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9)),
                  labelStyle: GoogleFonts.raleway(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                  tabs: [
                    Tab(text: 'IN PROGRESS'),
                    Tab(text: 'COMPLETED'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _modalBottomSheet(BuildContext context, TrophyAchivementsProvider provider) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 28.0),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    alignment: Alignment.centerLeft,
                    child: SvgPicture.asset('assets/img/dismis_X.svg'),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Select',
                      style: GoogleFonts.raleway(
                          fontFeatures: [FontFeature.enable('lnum')],
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        provider.sortOption(0);
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Container(
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
                                color: provider.sort == 0
                                    ? ThemeDefaults.primaryColor
                                    : Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 26.0,
                          ),
                          Text(
                            'A-Z',
                            style: GoogleFonts.raleway(
                                fontSize: 16.0, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            provider.sortOption(1);
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Container(
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
                                    color: provider.sort == 1
                                        ? ThemeDefaults.primaryColor
                                        : Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 26.0,
                              ),
                              Text(
                                'Z-A',
                                style: GoogleFonts.raleway(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            provider.sortOption(2);
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Container(
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
                                    color: provider.sort == 2
                                        ? ThemeDefaults.primaryColor
                                        : Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 26.0,
                              ),
                              Text(
                                'Ascending',
                                style: GoogleFonts.raleway(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            provider.sortOption(3);
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Container(
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
                                    color: provider.sort == 3
                                        ? ThemeDefaults.primaryColor
                                        : Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 26.0,
                              ),
                              Text(
                                'Descending',
                                style: GoogleFonts.raleway(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            provider.sortOption(4);
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Container(
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
                                    color: provider.sort == 4
                                        ? ThemeDefaults.primaryColor
                                        : Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 26.0,
                              ),
                              Text(
                                'Categories',
                                style: GoogleFonts.raleway(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 26.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        );
      },
    );
  }
}
