import 'dart:ui';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:share/share.dart';
import 'package:trophyapp/constants/theme_defaults.dart';
import 'package:trophyapp/helpers/snackbar_presenter.dart';
import 'package:trophyapp/screens/add_trophy/add_trophy_provider.dart';
import 'package:video_player/video_player.dart';

class AddTrophy extends StatefulWidget {
  @override
  _AddTrophyState createState() => _AddTrophyState();
}

class _AddTrophyState extends State<AddTrophy> {
  VideoPlayerController _videoPlayerController;
  TextEditingController _controller = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    AddTrophyProvider provider = Provider.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            padding: EdgeInsets.all(40.0),
            child: Column(
              children: [
                Container(
                  height: 100.0,
                  padding: EdgeInsets.all(0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                                height: 40.0,
                                width: 40.0,
                                padding: EdgeInsets.all(10.0),
                                child:
                                    SvgPicture.asset('assets/img/cancel.svg'))),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Add IRLA',
                          style: GoogleFonts.raleway(
                              fontFeatures: [FontFeature.enable('lnum')],
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Serial number *',
                          style: GoogleFonts.raleway(
                              fontFeatures: [FontFeature.enable('lnum')],
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4F4F4F)),
                        ),
                        provider.barcodeValid
                            ? SvgPicture.asset('assets/img/textfield_ok.svg')
                            : SizedBox()
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Container(
                        color: ThemeDefaults.tfFillColor,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.raleway(
                                    fontFeatures: [FontFeature.enable('lnum')],
                                    color: ThemeDefaults.textColor,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                                controller: _controller,
                                onChanged: (String value) {
                                  provider.setBarcode(value);
                                },
                                decoration: InputDecoration(
                                  fillColor: ThemeDefaults.tfFillColor,
                                  filled: true,
                                  hintText: '12 characters ',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon:
                                    SvgPicture.asset('assets/img/scan_qr.svg'),
                                onPressed: () async {
                                  Route route = MaterialPageRoute(
                                      builder: (context) =>
                                          ChangeNotifierProvider(
                                              create: (_) =>
                                                  AddTrophyProvider(),
                                              child: Scanner()));
                                  var result =
                                      await Navigator.push(context, route);
                                  if (result != null) {
                                    provider.setBarcode(result);
                                    _controller.text = provider.scanValue;
                                  }
                                },
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: ThemeDefaults.inactiveColor, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '1. Upload a picture/video of yourself completing the IRLA',
                        style: GoogleFonts.raleway(
                            fontFeatures: [FontFeature.enable('lnum')],
                            fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      if (provider.eventPic != null ||
                          provider.eventVideo != null)
                        provider.isEventVideo
                            ? _videoEvent(
                                context, provider, _videoPlayerController)
                            : Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                      child: provider.eventPic == null
                                          ? null
                                          : Image.file(provider.eventPic)),
                                  GestureDetector(
                                    onTap: () => provider.disposeEventPic(),
                                    child: Container(
                                        padding: EdgeInsets.all(12.0),
                                        child: SvgPicture.asset(
                                            'assets/img/dispose_media.svg')),
                                  ),
                                ],
                              ),
                      SizedBox(
                        height: 6.0,
                      ),
                      Container(
                        height: 32.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: ThemeDefaults.primaryColor)),
                        child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(0.0),
                            ),
                            onPressed: () => _loadEvent(context, provider,
                                _videoPlayerController, true, 1),
                            child: Text(
                              'Upload',
                              style: GoogleFonts.raleway(
                                  fontFeatures: [FontFeature.enable('lnum')],
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeDefaults.primaryColor),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: ThemeDefaults.inactiveColor, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '2. Upload a picture/video of yourself holding the IRLA',
                        style: GoogleFonts.raleway(
                            fontFeatures: [FontFeature.enable('lnum')],
                            fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      // TODO: it seems to be dupcicate of code above
                      if (provider.holdTrophyPic != null ||
                          provider.holdVideo != null)
                        provider.isHoldVideo
                            ? _videoHold(
                                context, provider, _videoPlayerController)
                            : Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                      child: provider.holdTrophyPic == null
                                          ? null
                                          : Image.file(provider.holdTrophyPic)),
                                  GestureDetector(
                                    onTap: () => provider.disposeHoldPic(),
                                    child: Container(
                                        padding: EdgeInsets.all(12.0),
                                        child: SvgPicture.asset(
                                            'assets/img/dispose_media.svg')),
                                  ),
                                ],
                              ),
                      SizedBox(
                        height: 6.0,
                      ),
                      Container(
                        height: 32.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: ThemeDefaults.primaryColor)),
                        child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(0.0),
                            ),
                            onPressed: () => _loadEvent(
                                context,
                                provider,
                                _videoPlayerController,
                                // TODO(REFACOTR): make "false" more readble and understandable
                                false,
                                // TODO(REFACOTR): make "2" more readble and understandable
                                2),
                            child: Text(
                              'Upload',
                              style: GoogleFonts.raleway(
                                  fontFeatures: [FontFeature.enable('lnum')],
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeDefaults.primaryColor),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: ThemeDefaults.inactiveColor, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Container(
                    color: ThemeDefaults.tfFillColor,
                    padding: EdgeInsets.only(left: 3.0),
                    child: TextField(
                      onChanged: (String value) =>
                          provider.setDescription(value),
                      maxLines: 5,
                      style: GoogleFonts.raleway(
                          fontFeatures: [FontFeature.enable('lnum')],
                          fontSize: 14.0,
                          color: ThemeDefaults.textColor),
                      cursorColor: ThemeDefaults.textColor,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(5.0),
                        hintText:
                            '3. Add a journal entry to help you remember how you earned this IRLA (optional)',
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.raleway(
                            fontFeatures: [FontFeature.enable('lnum')],
                            fontSize: 14.0,
                            color: ThemeDefaults.textColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  'If you choose to upload memories for this IRLA, you will be eligible for additional leaderboard points (once verified by a moderator).',
                  style: GoogleFonts.raleway(color: Colors.red, fontSize: 12.0),
                ),
                SizedBox(height: 12.0),
                Container(
                  width: double.infinity,
                  height: 40.0,
                  child: Builder(
                    builder: (context) {
                      return TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(0.0),
                          backgroundColor: provider.canContinue
                              ? ThemeDefaults.primaryColor
                              : ThemeDefaults.inactiveColor,
                        ),
                        onPressed: provider.canContinue
                            ? () async {
                                try {
                                  await provider.addTrophy();

                                  Navigator.pop(context);
                                  _addDialog(context);
                                } catch (e) {
                                  print('DEBUG: Error on add IRLA: $e');
                                  SnackbarPresenter.showErrorMessageSnackbar(
                                      context, e.toString());
                                }
                              }
                            : null,
                        child: Text(
                          'Add IRLA',
                          style: GoogleFonts.raleway(
                              fontFeatures: [FontFeature.enable('lnum')],
                              fontWeight: FontWeight.w800,
                              fontSize: 18.0,
                              color: Colors.white),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            titlePadding: EdgeInsets.all(25.0),
            contentPadding: EdgeInsets.only(bottom: 29.0),
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        child: SvgPicture.asset('assets/img/dismis_X.svg'),
                        onTap: () => Navigator.pop(context)),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Congratulations!',
                      style: GoogleFonts.raleway(
                          fontFeatures: [FontFeature.enable('lnum')],
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Image.asset('assets/img/congratulations.png'),
                    SizedBox(
                      height: 24.0,
                    ),
                    Text(
                      'You have just added a new IRLA to your\n collection. Share this achievement with your \nfriends',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          fontSize: 14.0, color: Colors.black.withOpacity(0.6)),
                    )
                  ],
                ),
              ],
            ),
            children: [
              Center(
                  child: GestureDetector(
                onTap: () {
                  final RenderBox box = context.findRenderObject();
                  Share.share('Look at my trophy',
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                },
                child: Container(
                  width: 89.0,
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
              ))
            ],
          );
        });
  }

  _videoEvent(BuildContext context, AddTrophyProvider provider,
      VideoPlayerController controller) {
    return AspectRatio(
      aspectRatio: provider.eventVideo.value.aspectRatio,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          VideoPlayer(provider.eventVideo),
          GestureDetector(
            onTap: () => provider.disposeEventVideo(),
            child: Container(
                padding: EdgeInsets.all(12.0),
                child: SvgPicture.asset('assets/img/dispose_media.svg')),
          ),
        ],
      ),
    );
  }

  _videoHold(BuildContext context, AddTrophyProvider provider,
      VideoPlayerController controller) {
    return AspectRatio(
        aspectRatio: provider.holdVideo.value.aspectRatio,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            VideoPlayer(
              provider.holdVideo,
            ),
            GestureDetector(
              onTap: () => provider.disposeHoldVideo(),
              child: Container(
                  padding: EdgeInsets.all(12.0),
                  child: SvgPicture.asset('assets/img/dispose_media.svg')),
            )
          ],
        ));
  }
}

_loadEvent(
    BuildContext context,
    AddTrophyProvider provider,
    VideoPlayerController videoPlayerController,
    bool isEvent,
    int mediaNumber) {
  return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Center(
            child: Text(
              'Choose an Option',
              style: GoogleFonts.raleway(
                  fontFeatures: [FontFeature.enable('lnum')],
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
          children: <Widget>[
            SimpleDialogOption(
                onPressed: () {},
                child: Container(
                  height: 32.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: ThemeDefaults.primaryColor)),
                  child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0.0),
                      ),
                      onPressed: () async {
                        var _image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (_image != null) {
                          if (mediaNumber == 1) {
                            final File imageFile = File(_image.path);
                            provider.setPhotoMedia1(imageFile);
                            await provider.addMedia1Photo();
                          } else if (mediaNumber == 2) {
                            final File imageFile = File(_image.path);
                            provider.setPhotoMedia2(imageFile);
                            await provider.addMedia2Photo();
                          }
                        } else {
                          return;
                        }
                        isEvent
                            ? provider.setEventPic(File(_image.path), false)
                            : provider.setHoldTrophyPic(
                                File(_image.path), false);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Upload Photo',
                        style: GoogleFonts.raleway(
                            fontFeatures: [FontFeature.enable('lnum')],
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: ThemeDefaults.primaryColor),
                      )),
                )),
            SimpleDialogOption(
                onPressed: () {},
                child: Container(
                  height: 32.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: ThemeDefaults.primaryColor)),
                  child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0.0),
                      ),
                      onPressed: () async {
                        var video = await ImagePicker()
                            .pickVideo(source: ImageSource.gallery);
                        if (video != null) {
                          if (mediaNumber == 1) {
                            final File videoFile = File(video.path);
                            provider.setPhotoMedia1(videoFile);
                            await provider.addMedia1Photo();
                          } else if (mediaNumber == 2) {
                            final File videoFile = File(video.path);
                            provider.setPhotoMedia2(videoFile);
                            await provider.addMedia2Photo();
                          }
                        } else {
                          return;
                        }

                        var videoFile = File(video.path);
                        videoPlayerController = VideoPlayerController.file(
                            videoFile,
                            videoPlayerOptions:
                                VideoPlayerOptions(mixWithOthers: true));
                        if (isEvent) {
                          provider.playEventVideo(videoPlayerController);
                          provider.setEventPic(videoFile, true);
                        } else {
                          provider.playHoldTrophyVideo(videoPlayerController);
                          provider.setHoldTrophyPic(videoFile, true);
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Upload Video',
                        style: GoogleFonts.raleway(
                            fontFeatures: [FontFeature.enable('lnum')],
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: ThemeDefaults.primaryColor),
                      )),
                )),
            SimpleDialogOption(
                onPressed: () {},
                child: Container(
                  height: 32.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: ThemeDefaults.primaryColor)),
                  child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0.0),
                      ),
                      onPressed: () async {
                        var image = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        if (image != null) {
                          if (mediaNumber == 1) {
                            final File imageFile = File(image.path);
                            provider.setPhotoMedia1(imageFile);
                            await provider.addMedia1Photo();
                          } else if (mediaNumber == 2) {
                            final File imageFile = File(image.path);
                            provider.setPhotoMedia2(imageFile);
                            await provider.addMedia2Photo();
                          }
                        } else {
                          return;
                        }
                        isEvent
                            ? provider.setEventPic(File(image.path), false)
                            : provider.setHoldTrophyPic(
                                File(image.path), false);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Take Photo',
                        style: GoogleFonts.raleway(
                            fontFeatures: [FontFeature.enable('lnum')],
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: ThemeDefaults.primaryColor),
                      )),
                )),
            // TODO(REFACOTR): seems to be duplicate of code above
            SimpleDialogOption(
                onPressed: () {},
                child: Container(
                  height: 32.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: ThemeDefaults.primaryColor)),
                  child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0.0),
                      ),
                      onPressed: () async {
                        var video = await ImagePicker()
                            .pickVideo(source: ImageSource.camera);
                        if (video != null) {
                          if (mediaNumber == 1) {
                            final File videoFile = File(video.path);
                            provider.setPhotoMedia1(videoFile);
                            await provider.addMedia1Photo();
                          } else if (mediaNumber == 2) {
                            final File videoFile = File(video.path);
                            provider.setPhotoMedia2(videoFile);
                            await provider.addMedia2Photo();
                          }
                        } else {
                          return;
                        }

                        var videoFile = File(video.path);
                        videoPlayerController =
                            VideoPlayerController.file(videoFile);
                        if (isEvent) {
                          provider.playEventVideo(videoPlayerController);
                          provider.setEventPic(videoFile, true);
                        } else {
                          provider.playHoldTrophyVideo(videoPlayerController);
                          provider.setHoldTrophyPic(videoFile, true);
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Take Video',
                        style: GoogleFonts.raleway(
                            fontFeatures: [FontFeature.enable('lnum')],
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: ThemeDefaults.primaryColor),
                      )),
                )),
          ],
        );
      });
}

class Scanner extends StatefulWidget {
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  @override
  Widget build(BuildContext context) {
    AddTrophyProvider provider = Provider.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.0),
        child: Container(
          height: 120.0,
          padding: EdgeInsets.only(top: 32.0),
          child: AppBar(
              centerTitle: false,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: SvgPicture.asset('assets/img/cancel.svg'),
              ),
              elevation: 0.0,
              shadowColor: Colors.white,
              iconTheme: IconThemeData(color: Color(0xFF333333)),
              backgroundColor: Colors.white,
              title: Text(
                'Scan Serial Number',
                style: GoogleFonts.raleway(
                    fontFeatures: [FontFeature.enable('lnum')],
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              )),
        ),
      ),
      body: Container(
        child: QrCamera(
          qrCodeCallback: (String value) {
            provider.setBarcode(value.replaceAll('A', ''));
          },
          child: Container(
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 46.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    provider.scanValue != null
                        ? Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white)),
                            height: 130.0,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 13.0),
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                provider.scanValue,
                                style: GoogleFonts.raleway(
                                    fontFeatures: [FontFeature.enable('lnum')],
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 41.0,
                    ),
                    provider.scanValue != null
                        ? Container(
                            width: double.infinity,
                            height: 40.0,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(0.0),
                                backgroundColor: ThemeDefaults.primaryColor,
                              ),
                              onPressed: () =>
                                  Navigator.pop(context, provider.scanValue),
                              child: Text(
                                'OK',
                                style: GoogleFonts.raleway(
                                    fontFeatures: [FontFeature.enable('lnum')],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
