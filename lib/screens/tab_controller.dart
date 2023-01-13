import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/screens/add_trophy/add_trophy.dart';
import 'package:trophyapp/screens/add_trophy/add_trophy_provider.dart';
import 'package:trophyapp/screens/forum/forum_index/provider.dart';
import 'package:trophyapp/screens/friends_list/friends_list.dart';
import 'package:trophyapp/screens/friends_list/friends_list_provider.dart';
import 'package:trophyapp/screens/profile/profile_main/profile_main.dart';
import 'package:trophyapp/screens/profile/profile_main/profile_main_provider.dart';
import 'package:trophyapp/screens/trophy_tab/trophy_tab_screen.dart';
import 'package:trophyapp/screens/forum/forum_index/forum_index.dart';

class TrophyTabController extends StatefulWidget {
  final String userId;

  TrophyTabController({this.userId});

  createState() => _TrophyTapControllerState();
}

class _TrophyTapControllerState extends State<TrophyTabController>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        body: _getBody(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(top: 22),
          child: SizedBox(
            width: 54,
            height: 54,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => AddTrophyProvider(),
                      child: AddTrophy(),
                    ),
                  ),
                );
              },
              child: Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  color: Color(0xFF242424),
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFCC9E40),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 6,
                    ),
                    child: SvgPicture.asset('assets/img/add_trophy_icon.svg'),
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: TrophyTabBar(
          tabController: _tabController,
          spaceWidth: 68,
        ),
      ),
    );
  }

  Widget _getBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        TrophyTabScreen(),
        ChangeNotifierProvider(
            create: (_) => ProfileMainProvider(), child: MyProfile()),
        ChangeNotifierProvider(
          create: (_) => FriendsListProvider(),
          child: FriendsList(
            currentUser: widget.userId,
          ),
        ),
        ChangeNotifierProvider(
            create: (_) => ForumIndexProvider(), child: Forum()),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class TrophyTabBar extends StatefulWidget {
  final TabController tabController;
  final double spaceWidth;

  const TrophyTabBar({Key key, this.tabController, this.spaceWidth = 0})
      : super(key: key);

  @override
  _TrophyTabBarState createState() => _TrophyTabBarState();
}

class _TrophyTabBarState extends State<TrophyTabBar> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tabWidth =
        (screenWidth - widget.spaceWidth) / widget.tabController.length;
    return Stack(
      children: [
        Container(
          color: Color(0xFFEBEBEC),
          height: 3.29,
        ),
        TabBar(
          controller: widget.tabController,
          indicatorColor: Colors.transparent,
          isScrollable: true,
          labelPadding: EdgeInsets.zero,
          tabs: [
            SizedBox(
              height: 82.14,
              width: tabWidth,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 3.29,
                    color: widget.tabController.index == 0
                        ? Color(0xFFCC9E40)
                        : null,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 17.86,
                    ),
                    child: widget.tabController.index == 0
                        ? SvgPicture.asset(
                            'assets/img/trophys_icon_selected.svg')
                        : SvgPicture.asset('assets/img/trophys_icon.svg'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: widget.spaceWidth / 2),
              child: SizedBox(
                height: 82.14,
                width: tabWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 3.29,
                      color: widget.tabController.index == 1
                          ? Color(0xFFCC9E40)
                          : null,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20.86,
                      ),
                      child: widget.tabController.index == 1
                          ? SvgPicture.asset('assets/img/me_icon_selected.svg')
                          : SvgPicture.asset('assets/img/me_icon.svg'),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: widget.spaceWidth / 2),
              child: SizedBox(
                height: 82.14,
                width: tabWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 3.29,
                      color: widget.tabController.index == 2
                          ? Color(0xFFCC9E40)
                          : null,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 22.86,
                      ),
                      child: widget.tabController.index == 2
                          ? SvgPicture.asset(
                              'assets/img/friends_icon_selected.svg')
                          : SvgPicture.asset('assets/img/friends_icon.svg'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 82.14,
              width: tabWidth,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 3.29,
                    color: widget.tabController.index == 3
                        ? Color(0xFFCC9E40)
                        : null,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24.86,
                      right: 27,
                      left: 27,
                    ),
                    child: widget.tabController.index == 3
                        ? SvgPicture.asset('assets/img/forum_icon_selected.svg')
                        : SvgPicture.asset('assets/img/forum_icon.svg'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
