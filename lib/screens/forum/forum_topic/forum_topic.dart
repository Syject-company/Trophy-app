import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:trophyapp/constants/theme_defaults.dart';
import 'package:trophyapp/discourse/discourse.dart';
import 'package:trophyapp/helpers/snackbar_presenter.dart';
import 'package:trophyapp/model/forum/like.dart';
import 'package:trophyapp/model/forum/post.dart';
import 'package:trophyapp/model/forum/post_data.dart';
import 'package:trophyapp/model/forum/topic_posts.dart';
import 'package:trophyapp/screens/common_widgets/trophy_dialog.dart';
import 'package:trophyapp/screens/common_widgets/trophy_text_button.dart';
import 'package:trophyapp/screens/forum/forum_topic/forum_topic_provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class ForumTopic extends StatefulWidget {
  final int topicId;

  ForumTopic({this.topicId});

  @override
  _ForumTopicState createState() => _ForumTopicState(topicId: this.topicId);
}

class _ForumTopicState extends State<ForumTopic> {
  final int topicId;
  Future<PostData> posts;
  XFile image;
  final _replyTextController = TextEditingController(text: '');

  _ForumTopicState({this.topicId});

  @override
  void initState() {
    super.initState();

    posts = TopicProvider().getPosts(topicId);
  }

  @override
  Widget build(BuildContext context) {
    TopicProvider provider = Provider.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F7),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(78),
        child: Container(
          height: double.infinity,
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                spreadRadius: 0,
                offset: Offset(0, 2),
                color: Color(0x12000000),
              )
            ],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 26.1, left: 24),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset('assets/img/leave_page_icon.svg'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.39),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Discussion',
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF434345),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: FutureBuilder<PostData>(
          future: posts,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return Column(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: 30,
                          right: 30,
                          left: 26,
                          bottom: 45,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data.post.topicTitle,
                              style: GoogleFonts.raleway(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF434345),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 10.0,
                                  height: 10.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(
                                      int.parse(
                                            snapshot
                                                .data
                                                .categories
                                                .categoryList[
                                                    provider.getPostCategory(
                                              snapshot.data.categories,
                                              snapshot.data.post.category,
                                            )]
                                                .color,
                                            radix: 16,
                                          ) +
                                          0xFF000000,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                FutureBuilder<List<Category>>(
                                  future: Discourse()
                                      .getCategoriesAndSubcategories(),
                                  builder: (context, categoriesSnapshot) {
                                    if (categoriesSnapshot.hasData) {
                                      final topicCategoryId =
                                          snapshot.data.post.category;
                                      var category = 'No Category';
                                      categoriesSnapshot.data.forEach(
                                        (mainCategory) {
                                          if (topicCategoryId ==
                                              mainCategory.id) {
                                            category = mainCategory.name;
                                          } else {
                                            mainCategory.subcategories.forEach(
                                              (subcategory) {
                                                if (subcategory.id ==
                                                    topicCategoryId) {
                                                  category =
                                                      '${mainCategory.name}/${subcategory.name}';
                                                }
                                              },
                                            );
                                          }
                                        },
                                      );
                                      return Text(
                                        category,
                                        style: GoogleFonts.raleway(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF828282),
                                        ),
                                      );
                                    } else if (categoriesSnapshot.hasError) {
                                      return Text(
                                        'Error loading category',
                                        style: GoogleFonts.raleway(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF828282),
                                        ),
                                      );
                                    } else {
                                      return SizedBox(
                                        width: 50,
                                        child: LinearProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 22.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                        snapshot.data.post.topics.postsList
                                            .first.userAvatar,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        snapshot.data.post.topics.postsList
                                            .first.name,
                                        style: GoogleFonts.raleway(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF434345),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    provider.getLastposted(
                                        snapshot.data.post.createTime),
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.raleway(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF828282),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Html(
                              data: snapshot
                                  .data.post.topics.postsList.first.postText,
                              style: {
                                "p": Style(
                                  fontFamily: GoogleFonts.raleway().fontFamily,
                                  fontSize: FontSize(14.0),
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF434345),
                                ),
                              },
                              onImageError: (error, stackTrace) {
                                print(
                                    'Error when parse Image in HTML of the topic: $error\n$stackTrace');
                              },
                              onCssParseError: (error, messages) {
                                messages.forEach((message) {
                                  print(
                                      'Error when parse Css in HTML of the topic: $error');
                                });

                                return 'Error was thrown by the HTML widget';
                              },
                              onMathError: (param1, param2, param3) {
                                print(
                                    'Error when parse html:$param1:$param2:$param3');
                                return null;
                              },
                            ),
                            _actionBar(
                                context,
                                provider,
                                snapshot
                                    .data.post.topics.postsList.first.username,
                                snapshot.data.post.topics.postsList.first,
                                1),
                            SizedBox(height: 18),
                            TopicInfo(data: snapshot.data.post),
                            ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  snapshot.data.post.topics.postsList.length,
                              itemBuilder: (context, index) {
                                return index >= 1
                                    ? _forumPost(
                                        context,
                                        provider,
                                        snapshot
                                            .data.post.topics.postsList[index],
                                        snapshot.data.post.topics.postsList,
                                        index + 1,
                                      )
                                    : Container();
                              },
                              separatorBuilder: (context, index) => Divider(
                                height: 28,
                                color: Color(0xFFE0E0E0),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 120,
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFCC9E40),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _actionBar(context, TopicProvider provider, String username, Post data,
      int postNumber) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                await provider.makeLikes(
                    data.id, (data.likes ?? Like(acted: false)).acted);
                setState(() {
                  posts = provider.getPosts(topicId);
                });
              },
              behavior: HitTestBehavior.opaque,
              child: (data.likes ?? Like(acted: false)).acted
                  ? SvgPicture.asset(
                      'assets/img/heart_like.svg',
                    )
                  : SvgPicture.asset('assets/img/heart_no_likes.svg'),
            ),
            SizedBox(width: 4.3),
            (data.likes ?? Like(count: 0)).count > 0
                ? Text(
                    (data.likes ?? Like(count: 0)).count.toString(),
                    style: GoogleFonts.raleway(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF434345),
                    ),
                  )
                : Text('')
          ],
        ),
        GestureDetector(
          onTap: () =>
              _replyDialog(context, provider, username, data, postNumber),
          child: Container(
            width: 70,
            height: 18,
            child: Row(
              children: [
                SvgPicture.asset('assets/img/reply_icon.svg'),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  'Reply',
                  style: GoogleFonts.raleway(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF434345),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  _forumPost(BuildContext context, TopicProvider provider, Post data,
      List<Post> posts, int postNumber) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(data.userAvatar),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data.username,
                      style: GoogleFonts.raleway(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF434345),
                      ),
                    ),
                  ),
                ],
              ),
              data.replyToPost != null
                  ? Row(
                      children: [
                        Image.asset(
                          'assets/img/reply.png',
                          width: 10,
                          height: 8,
                          color: Color(0xFF828282),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        CircleAvatar(
                          radius: 10.0,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(posts[posts.indexWhere(
                                  (element) =>
                                      element.postNumber == data.replyToPost)]
                              .userAvatar),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          provider.getLastposted(data.updateTime),
                          style: GoogleFonts.raleway(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF828282),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      provider.getLastposted(data.updateTime),
                      style: GoogleFonts.raleway(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF828282),
                      ),
                    ),
            ],
          ),
          data.isQuote ? _quoteWidget(context, provider, data) : SizedBox(),
          Container(
            child: Html(
              data: data.postText,
              style: {
                "p": Style(
                    fontFamily: GoogleFonts.raleway().fontFamily,
                    fontFeatureSettings: [FontFeature.enable('lnum')],
                    fontSize: FontSize(14.0)),
              },
              onImageError: (error, stackTrace) {
                print(
                    'Error when parse Image in HTML of the topic: $error\n$stackTrace');
              },
              onCssParseError: (error, messages) {
                messages.forEach((message) {
                  print('Error when parse Css in HTML of the topic: $error');
                });

                return 'Error was thrown by the HTML widget';
              },
              onMathError: (param1, param2, param3) {
                print('Error when parse html:$param1:$param2:$param3');
                return null;
              },
            ),
          ),
          _actionBar(context, provider, data.username, data, postNumber),
        ],
      ),
    );
  }

  _quoteWidget(context, TopicProvider provider, Post data) {
    return Container(
      margin: EdgeInsets.only(top: 12.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Color(0x1A434345),
      ),
      child: Html(
        data: data.quoteText ?? '',
        style: {
          "p": Style(
            fontFamily: GoogleFonts.raleway().fontFamily,
            fontFeatureSettings: [FontFeature.enable('lnum')],
            fontSize: FontSize(14.0),
          ),
        },
        onImageError: (error, stackTrace) {
          print(
              'Error when parse Image in HTML of the topic: $error\n$stackTrace');
        },
        onCssParseError: (error, messages) {
          messages.forEach((message) {
            print('Error when parse Css in HTML of the topic: $error');
          });

          return 'Error was thrown by the HTML widget';
        },
        onMathError: (param1, param2, param3) {
          print('Error when parse html:$param1:$param2:$param3');
          return null;
        },
      ),
    );
  }

  _replyDialog(BuildContext context, TopicProvider topicProvider,
      String username, Post post, int postNumber) {
    return showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            right: 13,
            left: 15,
          ),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  TrophyDialog(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 27.8,
                        right: 23,
                        bottom: 35,
                        left: 21,
                      ),
                      child: ChangeNotifierProvider(
                        create: (_) => ReplyProvider(),
                        child: Builder(builder: (context) {
                          final replyProvider =
                              Provider.of<ReplyProvider>(context);

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: 17,
                                ),
                                child: Center(
                                  child: Text(
                                    'Reply',
                                    style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 24,
                                      color: Color(0xFF434345),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 24),
                                child: Text(
                                  "Reply to @${username}'s ${postNumber == 1 ? 'topic' : 'post'}",
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: Color(0xFF434345),
                                  ),
                                ),
                              ),
                              Container(
                                height: 174.0,
                                margin: EdgeInsets.only(
                                  top: 6,
                                  bottom: 12,
                                ),
                                padding: EdgeInsets.only(
                                  top: 15,
                                  right: 16.0,
                                  left: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  border: Border.all(
                                    color: Color(0xFF434345),
                                    width: 1.5,
                                  ),
                                ),
                                child: TextField(
                                  onChanged: (String val) =>
                                      replyProvider.validateReply(val),
                                  controller: _replyTextController,
                                  maxLines: 10,
                                  style: GoogleFonts.raleway(
                                      color: Color(0xFF434345),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.0),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintText: 'Add your reply',
                                    hintStyle: GoogleFonts.raleway(
                                        color: Color(0xFF434345),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.0),
                                    focusColor: Colors.black,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () async {
                                      final _imagePicker = ImagePicker();
                                      image = await _imagePicker
                                          .pickImage(
                                              source: ImageSource.gallery)
                                          .catchError((err) {
                                        SnackbarPresenter
                                            .showErrorMessageSnackbar(
                                                context, err.toString());
                                      });
                                      replyProvider.setImage(image);
                                    },
                                    child: SvgPicture.asset(
                                        'assets/img/attached_icon.svg'),
                                  ),
                                  Expanded(
                                    child: Visibility(
                                      visible: replyProvider.imageFile != null,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          left: 16.6,
                                        ),
                                        padding: EdgeInsets.only(
                                          top: 8,
                                          right: 16,
                                          bottom: 8,
                                          left: 16,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Color(0xFFF5F6F7),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            )),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                replyProvider.imageFile == null
                                                    ? ''
                                                    : path.basename(
                                                        replyProvider
                                                            .imageFile.path),
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.raleway(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF434345),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 11,
                                              ),
                                              child: GestureDetector(
                                                  onTap: replyProvider.isLoading
                                                      ? null
                                                      : () {
                                                          replyProvider
                                                              .setImage(null);
                                                        },
                                                  child: SvgPicture.asset(
                                                      'assets/img/close_icon.svg')),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 14.5,
                                ),
                                child: replyProvider.isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFFCC9E40),
                                        ),
                                      )
                                    : TrophyTextButton(
                                        text: 'Post',
                                        textStyle: GoogleFonts.raleway(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF434345),
                                        ),
                                        backgroundColor: Color(0xFFCC9E40),
                                        onPressed: replyProvider.isReplyValid
                                            ? () {
                                                (replyProvider.imageFile == null
                                                        ? replyProvider
                                                            .updatePost(
                                                                topicId,
                                                                post.id,
                                                                postNumber,
                                                                context)
                                                        : replyProvider
                                                            .uploadImage(
                                                                topicId,
                                                                post.id,
                                                                postNumber,
                                                                context))
                                                    .then((_) {
                                                  setState(() {
                                                    _replyTextController
                                                        .clear();
                                                    posts = topicProvider
                                                        .getPosts(topicId);
                                                  });
                                                });
                                              }
                                            : null,
                                      ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _replyTextController.clear();
                      },
                      child: Container(
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: SvgPicture.asset('assets/img/close_icon.svg'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((value) {
      _replyTextController.clear();
    });
  }
}

class TopicInfo extends StatelessWidget {
  final TopicPosts data;

  TopicInfo({this.data});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TopicInfoProvider(),
      child: Builder(builder: (context) {
        final provider = Provider.of<TopicInfoProvider>(context);
        return AnimatedContainer(
          duration: Duration(milliseconds: 400),
          height: provider.containerHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 2),
                color: Color(0x1A000000),
                blurRadius: 3,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Wrap(
                    clipBehavior: Clip.hardEdge,
                    spacing: 24,
                    runSpacing: 6,
                    children: [
                      TopicStat(
                        title: 'created',
                        content:
                            provider.getLastposted(data.createTime).toString(),
                      ),
                      TopicStat(
                        title: 'last reply',
                        content: provider
                            .getLastposted(data.lastPostTime)
                            .toString(),
                      ),
                      TopicStat(
                        title: 'replies',
                        content: data.replyCont.toString(),
                      ),
                      TopicStat(
                        title: 'views',
                        content: data.views.toString(),
                      ),
                      TopicStat(
                        title: 'users',
                        content: data.usersCount.usersCount.toString(),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                decoration: BoxDecoration(
                  color: Color(0x33CC9E40),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => provider.changeView(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(
                      width: 14.4,
                      height: 6.8,
                      child: !provider.valueFull
                          ? SvgPicture.asset(
                              'assets/img/hide_dropdown_icon.svg')
                          : SvgPicture.asset('assets/img/dropdown_icon.svg'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class TopicStat extends StatelessWidget {
  final String title;
  final String content;

  TopicStat({this.title = '', this.content = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w400,
            color: Color(0xFF828282),
            fontSize: 12,
          ),
        ),
        Text(
          content,
          style: GoogleFonts.raleway(
            color: Color(0xFF434345),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
