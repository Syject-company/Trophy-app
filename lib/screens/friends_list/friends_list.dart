import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/constants/theme_defaults.dart';
import 'package:trophyapp/model/user.dart';
import 'package:trophyapp/model/user.dart' as usr;
import 'package:trophyapp/screens/common_widgets/trophy_grid_cell.dart';
import 'package:trophyapp/screens/common_widgets/trophy_text_field.dart';
import 'package:trophyapp/screens/friends_list/friends_list_provider.dart';
import 'package:trophyapp/screens/profile/user_profile/user_profile.dart';
import 'package:trophyapp/screens/profile/user_profile/user_profile_provider.dart';

class FriendsList extends StatefulWidget {
  final String currentUser;

  FriendsList({this.currentUser});

  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  Future<List<usr.User>> _getFriends;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _getFriends =
          context.read<FriendsListProvider>().getFriends(widget.currentUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FriendsListProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: _HeaderView(provider: provider),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: provider.needSearch
            ? _GridUsers(snapshot: provider.searchedFriends)
            : FutureBuilder<List<usr.User>>(
                future: _getFriends,
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return _GridUsers(snapshot: snapshot.data);
                  }
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return CircularProgressIndicator();
                },
              ),
      ),
    );
  }
}

class _HeaderView extends StatelessWidget with PreferredSizeWidget {
  final FriendsListProvider provider;

  _HeaderView({this.provider});

  @override
  Size get preferredSize => const Size.fromHeight(180.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 3.0,
            offset: Offset(0.0, 0.2),
            color: Colors.black.withOpacity(0.15),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTitle(),
              _buildLeaderboardButton(),
            ],
          ),
          const SizedBox(height: 10.0),
          _buildSearchFriendsInput(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'My Friends',
      style: GoogleFonts.raleway(
        fontSize: 24.0,
        letterSpacing: 0.48,
        fontWeight: FontWeight.w700,
        color: ThemeDefaults.primaryTextColor,
      ),
    );
  }

  Widget _buildLeaderboardButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        side: BorderSide(
          width: 2.0,
          color: ThemeDefaults.primaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: const Size(168.0, 40.0),
      ),
      child: Row(
        children: [
          Text(
            'Leaderboard',
            style: GoogleFonts.raleway(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: ThemeDefaults.primaryTextColor,
            ),
          ),
          const SizedBox(width: 5.0),
          SvgPicture.asset(
            'assets/img/leaderboard_icon.svg',
            color: ThemeDefaults.primaryTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFriendsInput() {
    return TrophyTextField(
      hint: 'Search',
      onChanged: provider.searchFriends,
      leadingIconPath: 'assets/img/search_icon.svg',
    );
  }
}

class _GridUsers extends StatelessWidget {
  final List<User> snapshot;

  _GridUsers({this.snapshot});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        User user = snapshot[index];
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
      ),
    );
  }
}
