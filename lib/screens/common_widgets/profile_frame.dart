import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/screens/my_success/my_success.dart';
import 'package:trophyapp/screens/my_success/my_success_provider.dart';
import 'package:trophyapp/screens/profile/profile_settings/profile_settings.dart';
import 'package:trophyapp/screens/profile/profile_settings/profile_settings_provider.dart';

class ProfileFrame extends StatelessWidget {
  final ImageProvider<Object> avatar;
  final String name;
  final int earnedPoints;
  final int pointsToNextLevel;
  final String levelName;
  final int levelValue;
  final bool isVerified;
  final String location;

  /// Need to redirect to settings.
  final String userId;

  ProfileFrame({
    this.avatar,
    Key key,
    this.name,
    this.earnedPoints,
    this.levelName,
    this.levelValue,
    this.isVerified,
    this.location,
    @required this.userId,
    this.pointsToNextLevel,
  }) : super(key: key) {
    assert(avatar != null);
    assert(name != null);
    assert(earnedPoints != null);
    assert(pointsToNextLevel != null);
    assert(levelName != null);
    assert(levelValue != null);
    assert(isVerified != null);
    assert(location != null);
    assert(pointsToNextLevel != null);
  }

  @override
  Widget build(BuildContext context) {
    final topAvatarCenterPadding = 62.2;
    final avatarRadius = (104.17 + _LevelProgressPainter.width) / 2;
    final topAvatarPadding = topAvatarCenterPadding - avatarRadius;
    return FutureBuilder<DrawableRoot>(
      future: _loadSvg(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
            width: 359,
            height: 242,
            child: Stack(
              children: [
                Positioned(
                  left: 21,
                  child: SizedBox(
                    width: 317,
                    height: 242,
                    child: CustomPaint(
                      painter: _FramePainter(svg: snapshot.data),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: topAvatarPadding,
                            child: CustomPaint(
                              painter: _LevelProgressPainter(
                                progress: earnedPoints / pointsToNextLevel,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    _LevelProgressPainter.width),
                                child: CircleAvatar(
                                  backgroundColor: Color(0xFFCC9E40),
                                  radius: 49.87,
                                  backgroundImage: avatar,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 130,
                            child: Text(
                              '$earnedPoints/$pointsToNextLevel',
                              style: GoogleFonts.raleway(
                                color: Color(0xFFCC9E40),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 150,
                            left: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider(
                                      create: (_) => MySuccessProvider(),
                                      child: MySuccess(
                                        points: earnedPoints,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Center(
                                child: Text(
                                  '$levelName Level $levelValue',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.raleway(
                                    color: Color(0xFFCC9E40),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 175,
                            left: 8,
                            right: 8,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        'User $name',
                                        style: GoogleFonts.raleway(
                                          color: Color(0xFF434345),
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.8),
                                    child: SvgPicture.asset(
                                      isVerified
                                          ? 'assets/img/verified_icon.svg'
                                          : 'assets/img/not_verified_icon.svg',
                                      width: 23.94,
                                      height: 23.75,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 210,
                            left: 8,
                            right: 8,
                            child: Center(
                              child: Text(
                                '$location',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.raleway(
                                  color: Color(0xFFA7A9Ac),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 38,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (_) => ProfileSettingsProvider(),
                            child: ProfileSettings(
                              uId: userId,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 44.13,
                      width: 42,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(23),
                          ),
                          color: Color(0xFFF5F6F7),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x4D000000),
                              offset: Offset(0, 0),
                              blurRadius: 5,
                              spreadRadius: 0,
                            )
                          ]),
                      child: Center(
                        child: SvgPicture.asset('assets/img/settings_icon.svg'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<DrawableRoot> _loadSvg() async {
    return await svg.fromSvgString(
        await rootBundle.loadString('assets/img/profile_frame.svg'),
        'SVG_DEBUG');
  }
}

class _FramePainter extends CustomPainter {
  DrawableRoot svg;
  _FramePainter({this.svg});

  @override
  void paint(Canvas canvas, Size size) {
    Size desiredSize = size;

    canvas.save();
    canvas.translate(0, 0);
    Size svgSize = svg.viewport.size;
    var matrix = Matrix4.identity();
    matrix.scale(
        desiredSize.width / svgSize.width, desiredSize.height / svgSize.height);
    canvas.transform(matrix.storage);
    svg.draw(canvas,
        null); // the second argument is not used in DrawableRoot.draw() method
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _LevelProgressPainter extends CustomPainter {
  static const double width = 5.0;

  final double progress;

  _LevelProgressPainter({this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Color(0xFFE0E0E0)
      ..strokeCap = StrokeCap.square
      ..strokeWidth = width;
    final levelPaint = Paint()
      ..color = Color(0xFFCC9E40)
      ..strokeCap = StrokeCap.square
      ..strokeWidth = width;
    final bounds = Rect.fromLTWH(0, 0, size.width, size.height);
    final startAngle = math.pi + math.pi / 2;
    final sweepAngle = -(2 * math.pi) * progress;

    canvas.drawArc(bounds, startAngle, 2 * math.pi, false, backgroundPaint);
    canvas.drawArc(bounds, startAngle, sweepAngle, true, levelPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
