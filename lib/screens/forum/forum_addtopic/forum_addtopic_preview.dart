import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/discourse/discourse.dart';
import 'package:trophyapp/helpers/snackbar_presenter.dart';
import 'package:trophyapp/screens/common_widgets/trophy_text_button.dart';
import 'package:trophyapp/screens/forum/forum_addtopic/forum_addtopic_provider.dart';

class AddTopicPreview extends StatelessWidget {
  final AddTopicProvider provider;

  AddTopicPreview({this.provider});

  @override
  Widget build(BuildContext context) {
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
                  color: Color(0x12000000))
            ],
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
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
                      child: SvgPicture.asset('assets/img/close_icon.svg'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.39),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Add Topic',
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
        child: Container(
          padding: EdgeInsets.only(
            top: 21,
            right: 26,
            bottom: 28,
            left: 26,
          ),
          margin: EdgeInsets.only(
            top: 21,
            right: 14.0,
            left: 14.0,
            bottom: 21,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x18000000),
                spreadRadius: 0,
                blurRadius: 3,
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: ChangeNotifierProvider.value(
            value: provider,
            child: Builder(builder: (context) {
              final provider = Provider.of<AddTopicProvider>(context);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.title,
                    style: GoogleFonts.raleway(
                      color: Color(0xFF434345),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  FutureBuilder<User>(
                    future:
                        Discourse().getUserById(id: Discourse().currentUserId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  NetworkImage(snapshot.data.avatar500px),
                            ),
                            SizedBox(
                              width: 12.0,
                            ),
                            Text(
                              snapshot.data.username,
                              style: GoogleFonts.raleway(
                                color: Color(0xFF434345),
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFCC9E40),
                          ),
                        );
                      } else {
                        print(
                            'Debug: when get user for preview: ${snapshot.error}');
                        return Text(
                          'Cannot load Discourse user data',
                          style: GoogleFonts.raleway(
                            color: Color(0xFF434345),
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 26.0,
                  ),
                  Text(
                    provider.text,
                    style: GoogleFonts.raleway(
                      color: Color(0xFF434345),
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  provider.imageFile == null
                      ? SizedBox.shrink()
                      : Container(
                          constraints: BoxConstraints(maxHeight: 230),
                          child: Image.file(
                            File(provider.imageFile.path),
                            frameBuilder: (context, child, frame,
                                wasSynchronouslyLoaded) {
                              final image = ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: child,
                              );
                              if (wasSynchronouslyLoaded) {
                                return image;
                              }
                              return AnimatedOpacity(
                                child: image,
                                opacity: frame == null ? 0 : 1,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeOut,
                              );
                            },
                          ),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: provider.isLoading
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/img/arrow_left_icon.svg',
                            ),
                            SizedBox(
                              width: 9.0,
                            ),
                            Text(
                              'Hide Preview',
                              style: GoogleFonts.raleway(
                                  color: Color(0xFF434345),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 34),
                    child: provider.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFCC9E40),
                            ),
                          )
                        : Builder(
                            builder: (context) {
                              return TrophyTextButton(
                                text: 'Add',
                                textStyle: GoogleFonts.raleway(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF434345),
                                ),
                                backgroundColor: Color(0xFFCC9E40),
                                onPressed: () {
                                  provider.imageFile == null
                                      ? provider
                                          .createTopic(context)
                                          .catchError((error) {
                                          print(
                                              'DEBUG: $error : ${StackTrace.current}');
                                          SnackbarPresenter
                                              .showErrorMessageSnackbar(
                                                  context, error.toString());
                                        })
                                      : provider
                                          .uploadImage(context)
                                          .catchError((error) {
                                          print(
                                              'DEBUG: $error : ${StackTrace.current}');
                                          SnackbarPresenter
                                              .showErrorMessageSnackbar(
                                                  context, error.toString());
                                        });
                                },
                              );
                            },
                          ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
