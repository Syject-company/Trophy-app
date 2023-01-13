import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:trophyapp/constants/theme_defaults.dart';
import 'package:trophyapp/model/level.dart';
import 'package:trophyapp/screens/leader_board/leader_board.dart';
import 'package:trophyapp/screens/leader_board/leader_board_provider.dart';
import 'package:trophyapp/screens/my_success/my_success_provider.dart';

class MySuccess extends StatelessWidget {
  final int points;

  const MySuccess({this.points});

  @override
  Widget build(BuildContext context) {
    MySuccessProvider provider = Provider.of(context);
    // TODO(REFACTOR): make debug format
    print(points);
    return Scaffold(
      body: _body(context: context, provider: provider, userPoints: points),
    );
  }

  _appBar(BuildContext context) {
    return Container(
      height: 120.0,
      padding: EdgeInsets.only(top: 32.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 4),
            spreadRadius: 1.0,
            blurRadius: 3.0)
      ]),
      child: Container(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Image.asset(
                  'assets/img/arrow_back_appbar.png',
                  width: 10,
                  height: 17,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'My Success',
                style: GoogleFonts.raleway(
                    fontFeatures: [FontFeature.enable('lnum')],
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                              create: (_) => LeaderBoardProvider(),
                              child: LeaderBoard(),
                            ))),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset('assets/img/leader-first.svg'),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        'Leaderboard',
                        style: GoogleFonts.raleway(
                            fontFeatures: [FontFeature.enable('lnum')],
                            fontSize: 12.0,
                            color: ThemeDefaults.textColor,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _body({BuildContext context, MySuccessProvider provider, int userPoints}) {
    return Column(
      children: [
        _appBar(context),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
            child: FutureBuilder<List<Level>>(
              future: provider.getLvlInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: Alignment.center,
                        child: ListViewItem(
                          level: snapshot.data[index].id,
                          name: snapshot.data[index].name,
                          point: snapshot.data[index].point,
                          userPoints: userPoints,
                          // TODO: add image parametr.
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                          backgroundColor: ThemeDefaults.progressIndicator));
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ListViewItem extends StatelessWidget {
  final int level;
  // TODO(REFACTOR): rename
  final int point;
  final String name;
  final String image;
  final int userPoints;

  // TODO: add assertions
  ListViewItem(
      {this.level, this.point, this.name, this.image, this.userPoints});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: userPoints < point ? 0.3 : 1.0,
      child: Container(
        height: 100.0,
        padding: _levelPadding(level),
        width: 358.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 19.0),
              child: CustomPaint(
                painter: _getFirstLine(level),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset('assets/img/user_level.svg'),
                Text(
                  level.toString(),
                  style: GoogleFonts.raleway(
                      fontFeatures: [FontFeature.enable('lnum')],
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
            SizedBox(
              width: 5.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                    opacity: 0.7,
                    child: Text(
                      point.toString(),
                      style: GoogleFonts.raleway(
                          fontFeatures: [FontFeature.enable('lnum')],
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500),
                    )),
                Text(
                  name,
                  style: GoogleFonts.raleway(
                      fontFeatures: [FontFeature.enable('lnum')],
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
            SizedBox(
              width: 5.0,
            ),
            Container(
              margin: EdgeInsets.only(top: 19.0),
              child: CustomPaint(
                painter: _getLastLine(level),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _levelPadding(int level) {
    // TODO(REFACTOR): make more readble
    if (level == 0) {
      return EdgeInsets.only(left: 5);
    } else if (level.isOdd) {
      return EdgeInsets.only(left: 150.0);
    } else {
      return EdgeInsets.only(left: 86.0);
    }
  }

  CustomPainter _getFirstLine(int level) {
    // TODO(REFACTOR): make more readble
    if (level == 0 || level == 10) {
      // TODO(REFACTOR): do not return null
      return null;
    } else if (level.isEven) {
      return SuccessLeft();
    } else {
      // TODO(REFACTOR): do not return null
      return null;
    }
  }

  CustomPainter _getLastLine(int level) {
    // TODO(REFACTOR): make more readble
    if (level == 0) {
      return FirstSuccess();
    } else if (level.isOdd) {
      return SuccessRight();
    } else {
      // TODO(REFACTOR): do not return null
      return null;
    }
  }
}

// TODO(REFACTOR): rename class
class FirstSuccess extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ThemeDefaults.secondaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawArc(
        Rect.fromLTRB(-10, -10, 40, 40), -math.pi / 2, math.pi, false, paint);
    canvas.drawLine(Offset(15, 40), Offset(-35, 40), paint);
    canvas.drawArc(Rect.fromLTRB(-60, 40, -10, 90), math.pi / 2, math.pi, false,
        paint); // -65, 40, -5, 200
    canvas.drawLine(Offset(15, 90), Offset(-35, 90), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// TODO(REFACTOR): rename class
class SuccessRight extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ThemeDefaults.secondaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawArc(
        Rect.fromLTRB(-50, -10, 45, 90), -math.pi / 2, math.pi, false, paint);
    canvas.drawLine(Offset(0, 90), Offset(-65, 90), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// TODO(REFACTOR): rename class
class SuccessLeft extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ThemeDefaults.secondaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const globalXOffset = 0.0;
    canvas.drawLine(
        Offset(globalXOffset, -10), Offset(globalXOffset + 15, -10), paint);
    canvas.drawArc(
        Rect.fromLTRB(globalXOffset - 45, -10, globalXOffset + 45, 90),
        math.pi / 2,
        math.pi,
        false,
        paint);
    canvas.drawLine(
        Offset(globalXOffset, 90), Offset(globalXOffset + 90, 90), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
