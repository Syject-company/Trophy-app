import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/discourse/discourse.dart';
import 'package:trophyapp/screens/common_widgets/trophy_dropdown_button.dart';
import 'package:trophyapp/screens/common_widgets/trophy_text_button.dart';
import 'package:trophyapp/screens/common_widgets/trophy_text_field.dart';
import 'package:trophyapp/screens/forum/forum_addtopic/forum_addtopic.dart';
import 'package:trophyapp/screens/forum/forum_topic/forum_topic.dart';
import 'package:trophyapp/screens/forum/forum_topic/forum_topic_provider.dart';

import 'provider.dart';

class Forum extends StatefulWidget {
  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> with SingleTickerProviderStateMixin {
  Future<List<Category>> _categories;
  Future<List<Topic>> _topTopics;
  Future<List<Topic>> _latestTopics;
  Future<List<Topic>> _searchTopics;
  bool _isSearchResult = false;
  TextEditingController _searchQueryController;
  TabController _tabController;

  @override
  void initState() {
    _categories = Discourse().getCategoriesAndSubcategories();
    _topTopics = Discourse().getTopTopics();
    _latestTopics = Discourse().getLatestTopics();

    _searchQueryController = TextEditingController();

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ForumIndexProvider provider = Provider.of(context);
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final appBarHeight = 230 - statusBarHeight;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: appBarHeight + 18,
        flexibleSpace: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: Offset(0, 2),
                      color: Color(0x26000000))
                ],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 57),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 32),
                        child: Text(
                          'Forum',
                          style: GoogleFonts.raleway(
                            color: Color(0xFF434345),
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 40),
                        child: SizedBox(
                          width: 168,
                          child: TrophyTextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTopic(),
                                ),
                              );
                            },
                            text: 'Add Topic',
                            textStyle: GoogleFonts.raleway(
                              color: Color(0xFF434345),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            backgroundColor: Color(0xFFCC9E40),
                            shadows: [
                              BoxShadow(
                                color: Color(0x26000000),
                                blurRadius: 3,
                                spreadRadius: 0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 31, right: 25, bottom: 31, left: 31),
                    child: TrophyTextField(
                      hint: 'Search',
                      controller: _searchQueryController,
                      errorText: provider.searchError,
                      onChanged: (String val) => provider.validateSearch(val),
                      onSubmitted: provider.searchValid
                          ? (query) {
                              setState(() {
                                _isSearchResult = true;
                                _searchTopics =
                                    Discourse().searchTopics(query: query);
                              });
                            }
                          : null,
                      hintStyle: GoogleFonts.raleway(
                        color: Color(0xFF434345),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      leadingIconPath: 'assets/img/search_icon.svg',
                      defaultUnderLineColor: Color(0xFFD1D3D4),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 16,
              right: 16,
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                    color: Color(0xFFF5F6F7),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x26000000),
                        offset: Offset(0, 2),
                        blurRadius: 3,
                        spreadRadius: 0,
                      ),
                    ]),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _tabController.animateTo(0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _tabController.index == 0
                                ? Color(0xFFCC9E40)
                                : null,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Latest',
                              style: GoogleFonts.raleway(
                                color: Color(0xFF434345),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _tabController.index == 2,
                      child: VerticalDivider(
                        color: Color(0xFFD1D3D4),
                        indent: 3.5,
                        thickness: 1.5,
                        width: 1.5,
                        endIndent: 3.5,
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _tabController.animateTo(1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _tabController.index == 1
                                ? Color(0xFFCC9E40)
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Top',
                              style: GoogleFonts.raleway(
                                color: Color(0xFF434345),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _tabController.index == 0,
                      child: VerticalDivider(
                        color: Color(0xFFD1D3D4),
                        indent: 3.5,
                        thickness: 1.5,
                        width: 1.5,
                        endIndent: 3.5,
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _tabController.animateTo(2),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _tabController.index == 2
                                ? Color(0xFFCC9E40)
                                : null,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Category',
                              style: GoogleFonts.raleway(
                                color: Color(0xFF434345),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFFF5F6F7),
      body: TabBarView(
        controller: _tabController,
        children: [
          getTopicsList(
            _isSearchResult ? _searchTopics : _latestTopics,
            () {
              setState(() {
                if (_isSearchResult) {
                  _searchTopics =
                      Discourse().searchTopics(query: provider.searchQuery);
                } else {
                  _latestTopics = Discourse().getLatestTopics();
                }
              });
            },
          ),
          getTopicsList(
            _topTopics,
            () {
              setState(() {
                _topTopics = Discourse().getTopTopics();
              });
            },
          ),
          _categoryFilter(_categories, () {
            setState(() {
              _categories = Discourse().getCategoriesAndSubcategories();
            });
          }),
        ],
      ),
    );
  }

  Widget _categoryFilter(
      Future<List<Category>> categories, Function onTryAgain) {
    final provider = Provider.of<ForumIndexProvider>(context);
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 29, left: 28, right: 28.0),
        padding: EdgeInsets.only(
          top: 27,
          right: 12,
          bottom: 47,
          left: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              spreadRadius: 0,
              color: Color(0x26000000),
              offset: Offset(0, 2),
            )
          ],
        ),
        child: FutureBuilder<List<Category>>(
          future: categories,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TrophyDropdownButton(
                    hint: 'Select a Category',
                    hintStyle: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF434345),
                    ),
                    value: provider.category == null
                        ? null
                        : provider.category.name,
                    onChanged: (categoryName) {
                      final category = snapshot.data.firstWhere((category) {
                        return category.name == categoryName;
                      });
                      provider.category = category;
                      provider.subcategory = null;
                    },
                    items: _getMainCategoriesItems(snapshot.data),
                    leadingIcon: SvgPicture.asset(
                      'assets/img/required_icon.svg',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      bottom: 35,
                    ),
                    child: TrophyDropdownButton(
                      hint: 'Select a Sub-Category',
                      hintStyle: GoogleFonts.raleway(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Color(0xFF434345),
                      ),
                      value: provider.subcategory == null
                          ? null
                          : provider.subcategory.name,
                      onChanged: (categoryName) {
                        final category = provider.category.subcategories
                            .firstWhere((category) {
                          return category.name == categoryName;
                        });
                        provider.subcategory = category;
                      },
                      items: provider.category == null
                          ? []
                          : _getSubcategoriesItems(
                              provider.category.subcategories),
                    ),
                  ),
                  TrophyTextButton(
                    text: 'Apply',
                    backgroundColor: Color(0xFFCC9E40),
                    textStyle: GoogleFonts.raleway(
                      color: Color(0xFF434345),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.48,
                    ),
                    onPressed: provider.category != null
                        ? () {
                            provider.applyFilter();
                            _tabController.animateTo(0);
                          }
                        : null,
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Theme(
                  data: ThemeData(
                      colorScheme:
                          ColorScheme.dark(primary: Color(0xFFCC9E40))),
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Something went wrong...',
                      style: GoogleFonts.raleway(
                        color: Color(0xFF434345),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.48,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    SizedBox(
                      width: 100,
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
                        onPressed: onTryAgain,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getMainCategoriesItems(
      List<Category> categories) {
    return categories.map<DropdownMenuItem<String>>((category) {
      return DropdownMenuItem(
        value: category.name,
        child: Column(
          children: [
            categories.first == category
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
                  category.name,
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
  }

  List<DropdownMenuItem<String>> _getSubcategoriesItems(
      List<Category> subcategories) {
    if (subcategories == null) return [];
    return subcategories.map<DropdownMenuItem<String>>((category) {
      return DropdownMenuItem(
        value: category.name,
        child: Column(
          children: [
            subcategories.first == category
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
                  category.name,
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
  }

  Widget getTopicsList(Future<List<Topic>> topics, Function onTryAgain) {
    final provider = Provider.of<ForumIndexProvider>(context);
    return FutureBuilder<List<Topic>>(
      future: topics,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          var foundTopics = snapshot.data;
          if (provider.isFiltered) {
            if (provider.subcategory != null) {
              foundTopics = foundTopics.where((topic) {
                return topic.category.id == provider.subcategory.id;
              }).toList();
            } else {
              foundTopics = foundTopics.where((topic) {
                final equalCategory = topic.category.id == provider.category.id;
                final equalSubCategory =
                    provider.category.subcategories.any((subcategory) {
                  return subcategory.id == topic.categoryId;
                });
                return equalCategory || equalSubCategory;
              }).toList();
            }
          }
          return ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 100),
              child: Padding(
                padding: EdgeInsets.only(right: 28.0, left: 28),
                child: Column(
                  children: [
                    Visibility(
                      visible: provider.isFiltered,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 20,
                          bottom: 4,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                spreadRadius: 0,
                                color: Color(0x26000000),
                                offset: Offset(0, 2),
                              )
                            ]),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Row(children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 9,
                                      bottom: 9,
                                      left: 13,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 8),
                                          child: Text(
                                            'category',
                                            style: GoogleFonts.raleway(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF434345),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          provider.category == null
                                              ? 'No Category'
                                              : provider.category.name,
                                          style: GoogleFonts.raleway(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 9,
                                      bottom: 9,
                                      left: 32,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          child: Text(
                                            'sub-category',
                                            style: GoogleFonts.raleway(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Color(
                                                0xFF828282,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          provider.subcategory == null
                                              ? 'No subcategory'
                                              : provider.subcategory.name,
                                          style: GoogleFonts.raleway(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF434345),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                              GestureDetector(
                                onTap: () {
                                  provider.removeFilter();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFC4C4C4),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                  ),
                                  padding: EdgeInsets.only(
                                    right: 11.1,
                                    left: 12,
                                  ),
                                  child: SvgPicture.asset(
                                      'assets/img/close_icon.svg'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _isSearchResult,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Found ${foundTopics.length} Topics',
                              style: GoogleFonts.raleway(
                                  color: Color(0xFF434345),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isSearchResult = false;
                                  _searchQueryController.clear();
                                });
                              },
                              child:
                                  SvgPicture.asset('assets/img/close_icon.svg'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 24,
                        bottom: 7,
                      ),
                      child: foundTopics.isNotEmpty
                          ? ListView.separated(
                              physics: ClampingScrollPhysics(),
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 7);
                              },
                              shrinkWrap: true,
                              itemCount: foundTopics.length,
                              itemBuilder: (context, index) {
                                return _buildListTile(context, index,
                                    foundTopics[index], index % 2 == 0);
                              },
                            )
                          : Text(
                              'No Topics',
                              style: GoogleFonts.raleway(
                                color: Color(0xFF434345),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.48,
                              ),
                            ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE0E0E0),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Theme(
              data: ThemeData(
                  colorScheme: ColorScheme.dark(primary: Color(0xFFCC9E40))),
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Something went wrong...',
                  style: GoogleFonts.raleway(
                    color: Color(0xFF434345),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.48,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                SizedBox(
                  width: 100,
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
                    onPressed: onTryAgain,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildListTile(
    BuildContext context,
    int index,
    Topic topic,
    bool isOdd,
  ) {
    final provider = Provider.of<ForumIndexProvider>(context);
    return GestureDetector(
      onTap: () {
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => TopicProvider(),
              child: ForumTopic(
                topicId: topic.id,
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: index % 2 == 0 ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(11)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                right: 20,
                bottom: 10,
                left: 13,
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(topic.lastPosterAvatar500px),
                onBackgroundImageError: (error, stackTrace) {
                  print('Error: $error\nstackTrace');
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 7),
                        child: Text(
                          topic.title,
                          style: GoogleFonts.raleway(
                              color: Color(0xFF434345),
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 7),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: hexToColor(topic.category.color),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            topic.category.name,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.raleway(
                                color: Color(0xFF828282),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 8,
                right: 13,
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Text(
                      topic.replyCount.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.raleway(
                          color: Color(0xFF434345),
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0),
                    ),
                  ),
                  Text(
                    provider.getLastposted(topic.lastPostedTime).toString(),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.raleway(
                        color: Color(0xFF828282),
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construct a color from a hex code string, of the format #RRGGBB.
  Color hexToColor(String code) {
    return new Color(int.parse(code, radix: 16) + 0xFF000000);
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
