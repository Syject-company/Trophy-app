import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trophyapp/model/forum/categories.dart';
import 'package:trophyapp/screens/forum/forum_topic/forum_topic.dart';
import 'package:trophyapp/screens/forum/forum_topic/forum_topic_provider.dart';
import 'package:trophyapp/discourse/discourse.dart' as discourse;

class AddTopicProvider with ChangeNotifier {
  discourse.Category _category;
  discourse.Category _subcategory;

  String _topicTitle = '';
  String _topicText = '';
  bool isSubCategories = false;
  String titleError = '';
  String textError = '';
  XFile imageFile;
  bool _isLoading = false;

  String categoryName;
  List<Category> subCategoryList;

  discourse.Category get category => _category;
  set category(discourse.Category category) {
    _category = category;
    notifyListeners();
  }

  String get title => _topicTitle;
  String get text => _topicText;

  discourse.Category get subcategory => _subcategory;
  set subcategory(discourse.Category subcategory) {
    _subcategory = subcategory;
    notifyListeners();
  }

  get isLoading => _isLoading;

  setImage(XFile file) {
    imageFile = file;
    notifyListeners();
  }

  setContent(String text, String title) {
    _topicTitle = title;
    _topicText = text;
  }

  Future<void> createTopic(BuildContext context, {String filePath}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final category = _subcategory == null ? _category : _subcategory;
      final topicId = await discourse.Discourse().createTopic(
        title: _topicTitle,
        raw: _topicText,
        categoryId: category.id,
        file: imageFile == null ? null : File(imageFile.path),
      );

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => TopicProvider(),
            child: ForumTopic(
              topicId: topicId,
            ),
          ),
        ),
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Degub: $e, ${StackTrace.current}');
      _isLoading = false;
      notifyListeners();
      return Future.error(e, StackTrace.current);
    }
  }

  uploadImage(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    if (imageFile != null) {
      try {
        var uploadTask = FirebaseStorage.instance
            .ref()
            .child('/forum_images/${basename(imageFile.path)}')
            .putFile(File(imageFile.path));
        uploadTask
            .then((value) => value.ref.getDownloadURL().then(
                (value) => createTopic(context, filePath: value.toString())))
            .timeout(Duration(seconds: 20));

        _isLoading = false;
        notifyListeners();
      } catch (error) {
        _isLoading = false;
        notifyListeners();
        return Future.error(error, StackTrace.current);
      }
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  String titleValidate(String val) {
    if (val.length < 15) {
      titleError = 'Title must be at least 15 characters';
    } else {
      titleError = '';
    }

    _topicTitle = val;

    notifyListeners();
    return null;
  }

  String textValidate(String val) {
    if (val.length < 20) {
      textError = 'Body is too short (minimum is 20 characters)';
    } else {
      textError = '';
    }
    _topicText = val;

    notifyListeners();
    return null;
  }

  bool canContinue() {
    return _topicTitle.isNotEmpty &&
        titleError.isEmpty &&
        _topicText.isNotEmpty &&
        textError.isEmpty &&
        category != null;
  }
}
