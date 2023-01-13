import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/discourse/discourse.dart' as discourse;
import 'package:trophyapp/helpers/snackbar_presenter.dart';
import 'package:trophyapp/screens/common_widgets/trophy_dialog.dart';
import 'package:trophyapp/screens/common_widgets/trophy_dropdown_button.dart';
import 'package:trophyapp/screens/common_widgets/trophy_text_button.dart';
import 'package:trophyapp/screens/common_widgets/trophy_text_field.dart';
import 'package:trophyapp/screens/forum/forum_addtopic/forum_addtopic_preview.dart';
import 'package:trophyapp/screens/forum/forum_addtopic/forum_addtopic_provider.dart';

class AddTopic extends StatefulWidget {
  @override
  _AddTopicState createState() => _AddTopicState();
}

class _AddTopicState extends State<AddTopic> {
  List categories;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var mainCategories;
  final _topicTitleController = TextEditingController(text: '');
  final _topicTextController = TextEditingController(text: '');
  XFile image;
  var data;
  String category;

  @override
  void initState() {
    mainCategories = discourse.Discourse().getCategoriesAndSubcategories();
    super.initState();
  }

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
        child: Padding(
          padding: EdgeInsets.only(
            top: 21,
            right: 24,
            bottom: 21,
            left: 14,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: TrophyDialog(
              child: Padding(
                padding: EdgeInsets.only(right: 22, left: 22),
                child: Form(
                  key: _formKey,
                  child: ChangeNotifierProvider(
                    create: (_) => AddTopicProvider(),
                    child: Builder(
                      builder: (context) {
                        AddTopicProvider provider =
                            Provider.of<AddTopicProvider>(context);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TrophyTextField(
                              hint: 'Type Title',
                              hintStyle: GoogleFonts.raleway(
                                color: Color(0xFF434345),
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0,
                              ),
                              errorText: provider.titleError,
                              commentText:
                                  'Title must be at least 15 characters',
                              onChanged: (String val) =>
                                  provider.titleValidate(val),
                              controller: _topicTitleController,
                            ),
                            FutureBuilder<List<discourse.Category>>(
                              future: mainCategories,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return TrophyDropdownButton(
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
                                      final category =
                                          snapshot.data.firstWhere((category) {
                                        return category.name == categoryName;
                                      });
                                      provider.category = category;
                                      provider.subcategory = null;
                                    },
                                    items:
                                        _getMainCategoriesItems(snapshot.data),
                                    leadingIcon: SvgPicture.asset(
                                      'assets/img/required_icon.svg',
                                    ),
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFCC9E40),
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Cannot Load Categories',
                                        style: GoogleFonts.raleway(
                                          color: Color(0xFF434345),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 11),
                            TrophyDropdownButton(
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
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 30, bottom: 6, left: 23),
                              child: Text(
                                'Text',
                                style: GoogleFonts.raleway(
                                    color: Color(0xFF434345),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17.0),
                              ),
                            ),
                            Container(
                              height: 174.0,
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
                                    provider.textValidate(val),
                                controller: _topicTextController,
                                maxLines: 10,
                                style: GoogleFonts.raleway(
                                    color: Color(0xFF434345),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.0),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  hintText:
                                      'Type here. Use markdown BBCode or HTML to format. Drag or Paste images.',
                                  errorText: provider.textError,
                                  hintStyle: GoogleFonts.raleway(
                                      color: Color(0xFF434345),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.0),
                                  focusColor: Colors.black,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () async {
                                          final _imagePicker = ImagePicker();
                                          image = await _imagePicker
                                              .pickImage(
                                                  source: ImageSource.gallery)
                                              .catchError((err, stackTrace) {
                                            print('DEBUG: $err : $stackTrace');
                                            SnackbarPresenter
                                                .showErrorMessageSnackbar(
                                                    context, err.toString());
                                          });
                                          provider.setImage(image);
                                        },
                                        child: SvgPicture.asset(
                                            'assets/img/attached_icon.svg'),
                                      ),
                                      Expanded(
                                        child: Visibility(
                                          visible: provider.imageFile != null,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              right: 8,
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
                                                    provider.imageFile == null
                                                        ? ''
                                                        : basename(provider
                                                            .imageFile.path),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.raleway(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFF434345),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 11,
                                                  ),
                                                  child: GestureDetector(
                                                      onTap: provider.isLoading
                                                          ? null
                                                          : () {
                                                              provider.setImage(
                                                                  null);
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
                                ),
                                GestureDetector(
                                  onTap: provider.canContinue() &&
                                          !provider.isLoading
                                      ? () {
                                          var data = {
                                            'title': _topicTitleController.text
                                                .toString(),
                                            'text': _topicTextController.text
                                                .toString(),
                                            'image': image
                                          };
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChangeNotifierProvider(
                                                        create: (_) =>
                                                            AddTopicProvider(),
                                                        child: AddTopicPreview(
                                                          provider: provider,
                                                        ))),
                                          );
                                        }
                                      : null,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Preview',
                                        style: GoogleFonts.raleway(
                                            color: Color(0xFF434345),
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 9.0,
                                      ),
                                      SvgPicture.asset(
                                          'assets/img/arrow_right_icon.svg'),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: !provider.isLoading
                                  ? TrophyTextButton(
                                      text: 'Add',
                                      textStyle: GoogleFonts.raleway(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF434345),
                                      ),
                                      backgroundColor: Color(0xFFCC9E40),
                                      onPressed: provider.canContinue()
                                          ? () {
                                              provider.setContent(
                                                  _topicTextController.text
                                                      .toString(),
                                                  _topicTitleController.text
                                                      .toString());
                                              provider
                                                  .createTopic(context)
                                                  .catchError((error) {
                                                print(
                                                    'DEBUG: $error : ${StackTrace.current}');
                                                SnackbarPresenter
                                                    .showErrorMessageSnackbar(
                                                        context,
                                                        error.toString());
                                              });
                                            }
                                          : null,
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFFCC9E40),
                                      ),
                                    ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getMainCategoriesItems(
      List<discourse.Category> categories) {
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
      List<discourse.Category> subcategories) {
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
}
