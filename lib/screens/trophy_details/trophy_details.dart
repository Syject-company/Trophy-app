import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart' as cube;
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trophyapp/constants/theme_defaults.dart';
import 'package:trophyapp/screens/trophy_details/trophy_details_provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trophyapp/model/trophy.dart';

// Экран с более 3д осмотром, где можно начать трекать трофей, поделиться им или купить.
class TrophyDetails extends StatelessWidget {
  final _controller = PageController(viewportFraction: 1.0);
  final Trophy trophy;

  TrophyDetails({this.trophy});

  @override
  Widget build(BuildContext context) {
    TrophyDetailProvider provider = Provider.of(context);
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
                    height: 50.0,
                    width: 50.0,
                    padding: EdgeInsets.all(16.0),
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
                ? _picture(context, provider, trophy.image)
                : TrophyModel(
                    model: trophy,
                  ),
            SizedBox(
              height: 24.0,
            ),
            _trophyContainer(context, provider, trophy),
          ],
        ),
      ),
    );
  }

  _picture(
      BuildContext context, TrophyDetailProvider provider, String _picture) {
    return Column(
      children: [
        Container(
          height: 330.0,
          padding: EdgeInsets.only(top: 60.0),
          child: PageView(
            controller: _controller,
            children: [Image.network(_picture)],
          ),
        ),
        SizedBox(
          height: 100.0,
        ),
        SmoothPageIndicator(
          controller: _controller,
          count: 1,
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

  _trophyContainer(
      BuildContext context, TrophyDetailProvider provider, Trophy _trophy) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => provider.changeView(),
            child: Container(
              height: 32.0,
              margin: EdgeInsets.symmetric(horizontal: 57.0, vertical: 10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border:
                    Border.all(color: ThemeDefaults.primaryColor, width: 2.0),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(child: _trophyInfo(context, provider, trophy)),
              Container(child: _trophyActions(context, provider, trophy)),
            ],
          ),
          SizedBox(
            height: 24.0,
          ),
          Text(
            trophy.howGet,
            style: GoogleFonts.raleway(
                fontFeatures: [FontFeature.enable('lnum')],
                fontSize: 14.0,
                color: ThemeDefaults.textColor,
                letterSpacing: 1.2,
                height: 1.455),
          ),
          SizedBox(height: 16),
          Divider(),
          //TODO: Change the IRLAs CARD
          SizedBox(height: 16),
          Text(
            trophy.setName,
            style: GoogleFonts.raleway(
                fontFeatures: [FontFeature.enable('lnum')],
                fontSize: 14.0,
                color: ThemeDefaults.textColor,
                letterSpacing: 1.2,
                height: 1.455),
          ),
          SizedBox(height: 16),
          Divider(),
          SizedBox(height: 24),
          Container(
            child: Text(
              _trophy.description,
              style: GoogleFonts.raleway(
                  fontFeatures: [FontFeature.enable('lnum')],
                  fontSize: 13.0,
                  color: ThemeDefaults.textColor,
                  letterSpacing: 1.2,
                  height: 1.455),
            ),
          ),
          SizedBox(
            height: 24.0,
          ),
          Container(
            height: 46.0,
            margin: EdgeInsets.only(bottom: 20),
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(0.0),
                backgroundColor: ThemeDefaults.secondaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Buy now',
                    style: GoogleFonts.raleway(
                        fontFeatures: [FontFeature.enable('lnum')],
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    'antsylabs.com',
                    style: GoogleFonts.raleway(
                        fontFeatures: [FontFeature.enable('lnum')],
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              ),
              onPressed: () => launch('http://google.com',
                  forceWebView: false, forceSafariVC: true),
            ),
          )
        ],
      ),
    );
  }

  _trophyInfo(
      BuildContext context, TrophyDetailProvider provider, Trophy _trophy) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _trophy.name,
          style: GoogleFonts.raleway(
              fontFeatures: [FontFeature.enable('lnum')],
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: ThemeDefaults.textColor),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          '${_trophy.point} points',
          style: GoogleFonts.raleway(
              fontFeatures: [FontFeature.enable('lnum')],
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
              color: ThemeDefaults.inactiveColor),
        )
      ],
    );
  }

  _trophyActions(
      BuildContext context, TrophyDetailProvider provider, Trophy _trophy) {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            final file = await provider.downloadImage(_trophy.image);
            final List<String> data = [file.toString()];
            Share.shareFiles(data,
                text:
                    '${_trophy.name} \n${_trophy.description}\n\nLook at my trophy');
          },
          child: Container(
            width: 88.0,
            height: 32.0,
            padding: EdgeInsets.symmetric(horizontal: 6.0),
            color: ThemeDefaults.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Share',
                  style: GoogleFonts.raleway(
                      fontFeatures: [FontFeature.enable('lnum')],
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    SvgPicture.asset(
                      'assets/img/share.svg',
                      color: Colors.white,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: 6.0,
        ),
        GestureDetector(
          onTap: () => provider.trackTrophy(),
          child: Container(
              padding: EdgeInsets.only(left: 6),
              width: 88,
              height: 32.0,
              color: provider.isTracked
                  ? ThemeDefaults.inactiveColor
                  : ThemeDefaults.secondaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Track',
                    style: GoogleFonts.raleway(
                        fontFeatures: [FontFeature.enable('lnum')],
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  SvgPicture.asset(
                    'assets/img/bookmark_icon.svg',
                    width: 24.0,
                    height: 24.0,
                  ),
                ],
              )),
        ),
      ],
    );
  }
}

class TrophyModel extends StatefulWidget {
  final Trophy model;

  TrophyModel({this.model});

  @override
  _TrophyModelState createState() => _TrophyModelState();
}

class _TrophyModelState extends State<TrophyModel> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TrophyDetailProvider>(context, listen: false);
    provider.get3dObjectWithTexture(widget.model);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrophyDetailProvider>(context);
    return Container(
        padding: EdgeInsets.only(top: 10.0),
        height: 366.0,
        child: provider.objectDescriptor == null
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
                    fileName: provider.objectDescriptor.objPath));
              }));
  }
}
