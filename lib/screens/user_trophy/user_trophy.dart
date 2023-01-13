import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart' as cube;
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';

import 'package:trophyapp/constants/theme_defaults.dart';
import 'package:trophyapp/model/achivement.dart';
import 'package:trophyapp/model/trophy.dart';
import 'package:trophyapp/model/user.dart' as usr;
import 'package:trophyapp/screens/user_trophy/full_screen_video.dart';
import 'package:trophyapp/screens/user_trophy/user_trophy_provider.dart';

// TODO: somewhere here is an error that needs to be caught
class UserTrophy extends StatefulWidget {
  final Achievement achievement;
  final usr.User user;

  UserTrophy({Key key, this.achievement, this.user}) : super(key: key);

  @override
  _UserTrophyState createState() => _UserTrophyState();
}

class _UserTrophyState extends State<UserTrophy> {
  final _controller = PageController(viewportFraction: 1.0);
  final bool moder = true;
  Trophy _trophy;
  VideoPlayerController _playerController;
  Future<void> _initializeVideoPlayerFuture;

  var trophyImage;

  @override
  void initState() {
    super.initState();
    _playerController =
        VideoPlayerController.network(widget.achievement.medias[1]);
    _playerController = VideoPlayerController.network(
      widget.achievement.medias[1],
    );

    _initializeVideoPlayerFuture = _playerController.initialize();
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserTrophyProvider provider = Provider.of(context);

    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 3))
          ]),
          height: 120.0,
          padding: EdgeInsets.only(top: 32.0, left: 20.0, right: 29.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    padding: EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/img/arrow_back_appbar.png',
                      width: 16,
                      height: 12,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'IRLA',
                  style: GoogleFonts.raleway(
                      fontFeatures: [FontFeature.enable('lnum')],
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        preferredSize: Size.fromHeight(120.0),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            provider.pictureView
                ? _picture(context, provider)
                : TrophyModel(provider: provider),
            SizedBox(
              height: 24.0,
            ),
            _container(context, provider, _playerController)
          ],
        ),
      ),
    );
  }

  _picture(BuildContext context, UserTrophyProvider provider) {
    return Column(
      children: [
        Container(
          height: 330.0,
          padding: EdgeInsets.only(top: 60.0),
          child: PageView(
            controller: _controller,
            children: List.generate(
                6, (_) => Image.asset('assets/img/model_picture.png')),
          ),
        ),
        SizedBox(
          height: 100.0,
        ),
        SmoothPageIndicator(
          controller: _controller,
          count: 6,
          effect: JumpingDotEffect(
              dotColor: ThemeDefaults.tfFillColor,
              activeDotColor: ThemeDefaults.secondaryColor,
              dotWidth: 12,
              dotHeight: 12),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  _container(BuildContext context, UserTrophyProvider provider,
      VideoPlayerController _videoPlayerController) {
    return Container(
      padding:
          EdgeInsets.only(top: 12.0, right: 40.0, left: 40.0, bottom: 40.0),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    _trophy = await provider.getTrophyById();
                    await provider.get3dObjectWithTexture(_trophy);
                    provider.changeView();
                  },
                  child: Container(
                    height: 32.0,
                    margin:
                        EdgeInsets.symmetric(horizontal: 57.0, vertical: 10.0),
                    alignment: Alignment.center,
                    // margin: EdgeInsets.only(right: 29.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: ThemeDefaults.primaryColor, width: 2.0),
                    ),
                    child: Text(
                      provider.pictureView ? 'View in 3D' : 'View in 2D',
                      style: GoogleFonts.raleway(
                          fontFeatures: [FontFeature.enable('lnum')],
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: ThemeDefaults.primaryColor),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'IRLA',
                      style: GoogleFonts.raleway(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: ThemeDefaults.textColor,
                          fontFeatures: [FontFeature.enable('lnum')]),
                    ),
                    provider.isVerified || widget.achievement.isVerified == true
                        ? Image.asset(
                            'assets/img/checkmark_verified.png',
                            width: 32.0,
                          )
                        : Container()
                  ],
                ),
                Text(
                  '1213 points',
                  style: GoogleFonts.raleway(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: ThemeDefaults.inactiveColor,
                      fontFeatures: [FontFeature.enable('lnum')]),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundColor: ThemeDefaults.secondaryColor,
                    backgroundImage: NetworkImage(
                      widget.user.avatar ??
                          'https://firebasestorage.googleapis.com/v0/b/irla-app.appspot.com/o/account_photo_placeholder.png?alt=media',
                    ),
                  ),
                  widget.user.isVerified
                      ? Image.asset(
                          'assets/img/checkmark_verified.png',
                          width: 16.0,
                        )
                      : Container()
                ],
              ),
              SizedBox(
                width: 14.0,
              ),
              Text(widget.user.name,
                  style: GoogleFonts.raleway(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: ThemeDefaults.textColor,
                      fontFeatures: [FontFeature.enable('lnum')])),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque venenatis sed sapien',
              style: GoogleFonts.raleway(
                  fontSize: 14.0,
                  color: ThemeDefaults.textColor,
                  fontFeatures: [FontFeature.enable('lnum')]),
            ),
          ),
          Container(
            height: 200,
            width: double.infinity,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 24.0, bottom: 16.0),
            child: widget.achievement.medias.first == null
                ? Image.asset(
                    'assets/img/empty_trophy.png',
                  )
                : Image.network(
                    widget.achievement.medias.first,
                    width: double.infinity,
                  ),
          ),
          Text(
            'Event',
            style: GoogleFonts.raleway(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: ThemeDefaults.textColor,
                fontFeatures: [FontFeature.enable('lnum')]),
          ),
          Container(
            height: 300,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 24.0, bottom: 16.0),
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        child: VideoPlayer(_videoPlayerController),
                      ),
                      Positioned(
                        bottom: 10,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_videoPlayerController.value.isPlaying) {
                                _videoPlayerController.pause();
                              } else {
                                _videoPlayerController.play();
                              }
                            });
                          },
                          color: Colors.white,
                          icon: _videoPlayerController.value.isPlaying
                              ? Icon(Icons.pause)
                              : Icon(Icons.play_arrow),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_videoPlayerController.value.volume > 0.0) {
                                _videoPlayerController.setVolume(0.0);
                              } else {
                                _videoPlayerController.setVolume(100.0);
                              }
                            });
                          },
                          color: Colors.white,
                          icon: _videoPlayerController.value.volume == 0.0
                              ? Icon(Icons.volume_mute)
                              : Icon(Icons.volume_up),
                        ),
                      ),
                      Positioned(
                          bottom: 10,
                          right: 50,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreen(
                                      videoPlayerController:
                                          _videoPlayerController,
                                    ),
                                  ));
                            },
                            color: Colors.white,
                            icon: Icon(
                              Icons.fullscreen,
                            ),
                          )),
                      Positioned(
                          bottom: 10,
                          right: 90,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _videoPlayerController.initialize();
                              });
                            },
                            color: Colors.white,
                            icon: Icon(
                              Icons.replay,
                            ),
                          )),
                      VideoProgressIndicator(
                        _videoPlayerController,
                        allowScrubbing: true,
                        colors: VideoProgressColors(
                          playedColor: ThemeDefaults.primaryColor,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Text(
            'Holding Trophy',
            style: GoogleFonts.raleway(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: ThemeDefaults.textColor,
                fontFeatures: [FontFeature.enable('lnum')]),
          ),
          SizedBox(
            height: 37.0,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 32.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      color: Colors.white),
                  child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0.0),
                      ),
                      onPressed: () =>
                          _declineDialog(provider: provider, context: context),
                      child: Expanded(
                        child: Text('Decline',
                            style: GoogleFonts.raleway(
                                fontSize: 18.0,
                                color: Colors.red,
                                fontFeatures: [FontFeature.enable('lnum')])),
                      )),
                ),
              ),
              SizedBox(
                width: 36.0,
              ),
              widget.achievement.isVerified
                  ? Text('Following')
                  : Expanded(
                      child: Container(
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: provider.isVerified
                              ? Colors.white
                              : ThemeDefaults.primaryColor,
                          border: provider.isVerified
                              ? Border.all(color: Colors.red)
                              : null,
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0.0),
                          ),
                          onPressed: () =>
                              provider.verifyButton(widget.achievement),
                          child: Text(
                            provider.isVerified ? 'Unverify' : 'Verify',
                            style: GoogleFonts.raleway(
                                fontSize: 18.0,
                                fontWeight: provider.isVerified
                                    ? FontWeight.normal
                                    : FontWeight.w800,
                                color: provider.isVerified
                                    ? Colors.red
                                    : Colors.white,
                                fontFeatures: [FontFeature.enable('lnum')]),
                          ),
                        ),
                      ),
                    )
            ],
          )
        ],
      ),
    );
  }

  _declineDialog({BuildContext context, UserTrophyProvider provider}) {
    return showDialog(
        context: context,
        builder: (context) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: ChangeNotifierProvider(
              create: (_) => UserTrophyProvider(),
              child: SimpleDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Decline IRLA',
                      style: GoogleFonts.raleway(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          fontFeatures: [FontFeature.enable('lnum')]),
                    ),
                    IconButton(
                      icon: SvgPicture.asset('assets/img/cancel.svg'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Consumer<UserTrophyProvider>(
                                builder: (context, _value, child) {
                              return GestureDetector(
                                  onTap: () => _value.inaprovedCheckbox(),
                                  child: Container(
                                    width: 16.0,
                                    height: 16.0,
                                    decoration: BoxDecoration(
                                        color: _value.inaprovedContent
                                            ? ThemeDefaults.secondaryColor
                                            : Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color:
                                                ThemeDefaults.secondaryColor)),
                                    child: Center(
                                        child: SvgPicture.asset(
                                            'assets/img/checkbox_checkmark.svg')),
                                  ));
                            }),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              'Inappropriate content',
                              style: GoogleFonts.raleway(
                                  fontSize: 14.0,
                                  fontFeatures: [FontFeature.enable('lnum')]),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 24.0,
                        ),
                        Row(
                          children: [
                            Consumer<UserTrophyProvider>(
                                builder: (context, _value, child) {
                              return GestureDetector(
                                  onTap: () => _value.standartsCheckbox(),
                                  child: Container(
                                    width: 16.0,
                                    height: 16.0,
                                    decoration: BoxDecoration(
                                        color: _value.standartsContent
                                            ? ThemeDefaults.secondaryColor
                                            : Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color:
                                                ThemeDefaults.secondaryColor)),
                                    child: Center(
                                        child: SvgPicture.asset(
                                            'assets/img/checkbox_checkmark.svg')),
                                  ));
                            }),
                            SizedBox(
                              width: 8.0,
                            ),
                            Flexible(
                              child: Text(
                                'Content does not meet the standards for proof of completed achievement',
                                style: GoogleFonts.raleway(
                                    fontSize: 14.0,
                                    fontFeatures: [FontFeature.enable('lnum')]),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 24.0,
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Comment',
                                style: GoogleFonts.raleway(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: ThemeDefaults.textColor,
                                    fontFeatures: [FontFeature.enable('lnum')]),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                constraints: BoxConstraints(maxHeight: 140.0),
                                child: TextField(
                                  style: GoogleFonts.raleway(
                                      color: ThemeDefaults.textColor,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFeatures: [
                                        FontFeature.enable('lnum')
                                      ]),
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    fillColor: ThemeDefaults.tfFillColor,
                                    filled: true,
                                    hintText: 'short description',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.red),
                      ),
                      child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0.0),
                          ),
                          onPressed: () => provider
                              .declineButton(widget.achievement)
                              .then((value) => Navigator.of(context)
                                  .popUntil((route) => route.isFirst)),
                          child: Text(
                            'Decline',
                            style: GoogleFonts.raleway(
                                fontSize: 18.0,
                                color: Colors.red,
                                fontFeatures: [FontFeature.enable('lnum')]),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class TrophyModel extends StatefulWidget {
  final provider;

  const TrophyModel({Key key, @required this.provider}) : super(key: key);
  @override
  State<StatefulWidget> createState() => TrophyModelState();
}

class TrophyModelState extends State<TrophyModel> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 10.0),
        height: 366.0,
        child: widget.provider.objectDescriptor == null
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(ThemeDefaults.primaryColor),
                ),
              )
            : cube.Cube(onSceneCreated: (cube.Scene scene) {
                scene.world.add(cube.Object(
                    scale: cube.Vector3(15.0, 15, 15),
                    position: cube.Vector3(0.0, -3, 0),
                    isAsset: false,
                    fileName: widget.provider.objectDescriptor.objPath));
              }));
  }
}
