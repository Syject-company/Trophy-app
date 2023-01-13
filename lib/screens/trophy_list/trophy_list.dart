import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/model/achivement.dart';
import 'package:trophyapp/model/ref_trophy_category.dart';
import 'package:trophyapp/model/trophy.dart';
import 'package:trophyapp/screens/common_widgets/trophy_grid_cell.dart';
import 'package:trophyapp/screens/trophy_details/trophy_details.dart';
import 'package:trophyapp/screens/trophy_details/trophy_details_provider.dart';

// TODO: this screen should shows earned by specified user irlas of a specified category
class TrophyList extends StatelessWidget {
  final TrophyCategory category;
  final List<Achievement> achievements;

  TrophyList({this.category, this.achievements});

  final List<Trophy> mockedTrophies = [
    Trophy(
        name: "Trophy 0",
        point: 1234,
        image:
            'https://purepng.com/public/uploads/large/purepng.com-krugerrand-gold-coincoinsmetalgolddollarkangaroo-14215264843254phx9.png',
        description: 'Description'),
    Trophy(
        name: "Trophy 1",
        point: 1234,
        image:
            'https://c7.hotpng.com/preview/636/213/275/millennium-falcon-wookieepedia-star-wars-bandai-plastic-model-chewbacca-thumbnail.jpg',
        description: 'Description'),
    Trophy(
        name: "Trophy 2",
        point: 1234,
        image:
            'https://www.meme-arsenal.com/memes/0c87d4d0829d2be228c3a581c046bd97.jpg',
        description: 'Description'),
    Trophy(
        name: "Trophy 3",
        point: 1234,
        image:
            'https://e7.pngegg.com/pngimages/130/602/png-clipart-nicholas-cage-illustration-nicolas-cage-national-treasure-celebrity-mask-actor-actor-celebrities-face.png',
        description: 'Description'),
    Trophy(
        name: "Trophy 4",
        point: 1234,
        image:
            'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',
        description: 'Description'),
    Trophy(
        name: "Trophy 5",
        point: 1234,
        image:
            'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',
        description: 'Description'),
    Trophy(
        name: "Trophy 6",
        point: 1234,
        image:
            'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',
        description: 'Description'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    padding: EdgeInsets.all(15.0),
                    child: Image.asset(
                      'assets/img/arrow_back_appbar.png',
                      width: 10,
                      height: 17,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Profile',
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
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 5.0),
              child: Text(
                '${category.name} Category',
                style: GoogleFonts.raleway(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  fontFeatures: [FontFeature.enable('lnum')],
                ),
              ),
            ),
            GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: mockedTrophies.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                      create: (_) => TrophyDetailProvider(),
                                      child: TrophyDetails(
                                        trophy: mockedTrophies[index],
                                      ),
                                    )));
                      },
                      child:
                          TrophyGridCell(trophy: mockedTrophies, index: index));
                }),
          ],
        ),
      )),
    );
  }
}
