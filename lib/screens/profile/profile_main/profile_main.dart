import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/client/client.dart';
import 'package:trophyapp/model/ref_trophy_category.dart';
import 'package:trophyapp/model/trophy.dart';
import 'package:trophyapp/screens/add_trophy/add_trophy.dart';
import 'package:trophyapp/screens/add_trophy/add_trophy_provider.dart';
import 'package:trophyapp/screens/common_widgets/custom_list_tile.dart';
import 'package:trophyapp/screens/common_widgets/profile_frame.dart';
import 'package:trophyapp/screens/common_widgets/trophy_text_button.dart';
import 'package:trophyapp/screens/profile/profile_main/profile_main_provider.dart';
import 'package:trophyapp/screens/trophy_achivements/trophy_achivements.dart';
import 'package:trophyapp/screens/trophy_achivements/trophy_achivements_provider.dart';
import 'package:trophyapp/screens/trophy_list/trophy_list.dart';
import 'package:trophyapp/screens/user_trophy/user_trophy.dart';
import 'package:trophyapp/screens/user_trophy/user_trophy_provider.dart';
import 'package:trophyapp/client/app_provider.dart';
import 'package:trophyapp/model/user.dart' as usr;

//TODO: Это личная страна пользователя, на вкладке Profile

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    Future<List<TrophyCategory>> categories =
        ProfileMainProvider.getCategories();
    final _userProvider = Provider.of<AppProvider>(context);
    ProfileMainProvider provider = Provider.of(context);
    return FutureBuilder<usr.User>(
      future: provider.getUser(_userProvider.currentUser.uid),
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          final statusBarHeight = MediaQuery.of(context).padding.top;
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(371 - statusBarHeight),
              child: Container(
                height: double.infinity,
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
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 42.7),
                      child: ProfileFrame(
                        avatar: NetworkImage(snapshot.data.avatar ??
                            'https://firebasestorage.googleapis.com/v0/b/irla-app.appspot.com/o/account_photo_placeholder.png?alt=media'),
                        userId: snapshot.data.id,
                        earnedPoints: snapshot.data.point,
                        pointsToNextLevel: provider.pointsToNextLevel,
                        levelName: provider.levelName,
                        name: snapshot.data.name,
                        levelValue: provider.levelvalue,
                        isVerified: snapshot.data.isVerified,
                        location: snapshot.data.city.isEmpty
                            ? snapshot.data.country
                            : '${snapshot.data.city}, ${snapshot.data.country}',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 21.3),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28),
                        child: Row(
                          children: [
                            Expanded(
                              child: TrophyTextButton(
                                text: 'Add IRLA',
                                textStyle: GoogleFonts.raleway(
                                  color: Color(0xFFCC9E40),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.48,
                                ),
                                backgroundColor: Color(0xFF242424),
                                shadows: [
                                  BoxShadow(
                                    blurRadius: 7,
                                    spreadRadius: 0,
                                    offset: Offset.zero,
                                    color: Color(0xFFCC9E40),
                                  ),
                                ],
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChangeNotifierProvider(
                                        create: (_) => AddTrophyProvider(),
                                        child: AddTrophy(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 22),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChangeNotifierProvider(
                                        create: (_) =>
                                            TrophyAchivementsProvider(),
                                        child: TrophyAchivements(),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: Color(0xFF434345),
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Tracked IRLAs',
                                          style: GoogleFonts.raleway(
                                            color: Color(0xFF434345),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: SvgPicture.asset(
                                            'assets/img/tracked_irlas_icon.svg',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            backgroundColor: Color(0xFFF5F6F7),
            body: FutureBuilder<List<TrophyCategory>>(
              future: categories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    final categories = snapshot.data ?? [];
                    if (categories.isEmpty) {
                      return Center(
                        child: Text(
                          'No Category',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                            color: Color(0xFF434345),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.48,
                          ),
                        ),
                      );
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 111,
                          child: ListView.separated(
                            padding: EdgeInsets.only(
                              top: 30,
                              right: 22.5,
                              left: 22.5,
                            ),
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(width: 22.5);
                            },
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TrophyList(
                                        category: categories[index],
                                        achievements: user.achievements,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 61.5,
                                      width: 61.5,
                                      child: SvgPicture.network(
                                        categories[index].icon,
                                        color: Color(0xFF434345),
                                        placeholderBuilder: (_) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFFCC9340),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        categories[index].name,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.raleway(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: user.achievements.isEmpty
                              ? Center(
                                  child: Text(
                                    'No IRLAs',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.raleway(
                                      color: Color(0xFF434345),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 0.48,
                                    ),
                                  ),
                                )
                              : FutureBuilder<List<Trophy>>(
                                  future: Future.microtask(() async {
                                    List<Trophy> trophies = [];
                                    for (var achievement in user.achievements) {
                                      final firebaseTrophy =
                                          await FirebaseFirestore.instance
                                              .collection('trophy')
                                              .doc(achievement.trophyId)
                                              .get();
                                      trophies.add(Trophy.fromFirebase(
                                          firebaseTrophy.data()));
                                    }
                                    return trophies;
                                  }),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemCount: categories.length,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 32, horizontal: 28),
                                          itemBuilder:
                                              (context, categoryIndex) {
                                            final trophies = snapshot.data;
                                            if (trophies.any((trophy) {
                                              return trophy.category ==
                                                  categories[categoryIndex].id;
                                            })) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          categories[
                                                                  categoryIndex]
                                                              .name,
                                                          style: GoogleFonts
                                                              .raleway(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xFF434345),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                                  return TrophyList(
                                                                    category:
                                                                        categories[
                                                                            categoryIndex],
                                                                    achievements:
                                                                        user.achievements,
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          },
                                                          child: Text(
                                                            'See All',
                                                            style: GoogleFonts
                                                                .raleway(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color(
                                                                  0xFFCC9E40),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children:
                                                        List<Widget>.generate(
                                                      2,
                                                      (index) {
                                                        final trophiesOfCurrentCategory =
                                                            trophies.where(
                                                                (trophy) {
                                                          return trophy
                                                                  .category ==
                                                              categories[
                                                                      categoryIndex]
                                                                  .id;
                                                        }).toList();
                                                        if (index == 1 &&
                                                            trophiesOfCurrentCategory
                                                                    .length ==
                                                                1) {
                                                          return Expanded(
                                                            child: SizedBox(
                                                              height: 168,
                                                            ),
                                                          );
                                                        } else {
                                                          final trophy =
                                                              trophiesOfCurrentCategory[
                                                                  index];
                                                          final achievement = user
                                                              .achievements
                                                              .firstWhere(
                                                                  (achievement) {
                                                            return achievement
                                                                    .id ==
                                                                trophy.serial;
                                                          });

                                                          return Expanded(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                                      return ChangeNotifierProvider(
                                                                        create:
                                                                            (_) {
                                                                          return UserTrophyProvider();
                                                                        },
                                                                        child:
                                                                            UserTrophy(
                                                                          achievement: user
                                                                              .achievements
                                                                              .first,
                                                                          user:
                                                                              user,
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                              child: SizedBox(
                                                                height: 168,
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(
                                                                      right: index ==
                                                                              0
                                                                          ? 11
                                                                          : 0,
                                                                      left: index ==
                                                                              1
                                                                          ? 11
                                                                          : 0),
                                                                  child:
                                                                      CustomListTile(
                                                                    title: trophy
                                                                        .name,
                                                                    subtitle: achievement.isVerified
                                                                        ? trophy
                                                                            .point
                                                                            .toString()
                                                                        : trophy
                                                                            .point
                                                                            .toString(),
                                                                    image:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              8.0),
                                                                      child: Image.network(
                                                                          trophy
                                                                              .image),
                                                                    ),
                                                                    icon: achievement
                                                                            .isVerified
                                                                        ? SvgPicture.asset(
                                                                            'assets/img/verified_icon.svg')
                                                                        : SizedBox
                                                                            .shrink(),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return SizedBox.shrink();
                                            }
                                          },
                                        );
                                      } else if (snapshot.hasError) {
                                        print(
                                            'Error on get IRLAs: ${snapshot.error}');
                                        return Center(
                                          child: Text(
                                            'Error on get IRLAs',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.raleway(
                                              color: Color(0xFF434345),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              letterSpacing: 0.48,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: Text(
                                            'Unknown State',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.raleway(
                                              color: Color(0xFF434345),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              letterSpacing: 0.48,
                                            ),
                                          ),
                                        );
                                      }
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFFCC9340),
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: Text(
                                          'Unknown State',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.raleway(
                                            color: Color(0xFF434345),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            letterSpacing: 0.48,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Loading finished with error: ${snapshot.error.toString()}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.raleway(
                          color: Color(0xFF434345),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.48,
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Loading finished but result unknown.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.raleway(
                          color: Color(0xFF434345),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.48,
                        ),
                      ),
                    );
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFCC9340),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      'Undefinit state.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                        color: Color(0xFF434345),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.48,
                      ),
                    ),
                  );
                }
              },
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF434345),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: SizedBox(
                    width: 200,
                    child: TrophyTextButton(
                      text: 'Try Again',
                      textStyle: GoogleFonts.raleway(
                        color: Color(0xFF434345),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.48,
                      ),
                      backgroundColor: Colors.transparent,
                      borderWidth: 1.5,
                      borderColor: Color(0xFFCC9E40),
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Text(
                  'or',
                  style: GoogleFonts.raleway(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF434345),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: SizedBox(
                    width: 200,
                    child: TrophyTextButton(
                      text: 'Log out',
                      textStyle: GoogleFonts.raleway(
                        color: Color(0xFF434345),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.48,
                      ),
                      backgroundColor: Colors.transparent,
                      borderWidth: 1.5,
                      borderColor: Color(0xFFCC9E40),
                      onPressed: () async {
                        await Client.logout();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Unknown Response State',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF434345),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: SizedBox(
                    width: 200,
                    child: TrophyTextButton(
                      text: 'Try Again',
                      textStyle: GoogleFonts.raleway(
                        color: Color(0xFF434345),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.48,
                      ),
                      backgroundColor: Colors.transparent,
                      borderWidth: 1.5,
                      borderColor: Color(0xFFCC9E40),
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Text(
                  'or',
                  style: GoogleFonts.raleway(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF434345),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: SizedBox(
                    width: 200,
                    child: TrophyTextButton(
                      text: 'Log out',
                      textStyle: GoogleFonts.raleway(
                        color: Color(0xFF434345),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.48,
                      ),
                      backgroundColor: Colors.transparent,
                      borderWidth: 1.5,
                      borderColor: Color(0xFFCC9E40),
                      onPressed: () async {
                        await Client.logout();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
