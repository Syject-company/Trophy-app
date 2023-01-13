import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:trophyapp/constants/discourse_rest.dart';
import 'package:trophyapp/discourse/discourse.dart';
import 'package:trophyapp/model/forum/categories.dart';
import 'package:trophyapp/model/forum/post_data.dart';

class TopicProvider with ChangeNotifier {
  bool _liked = false;
  int likes = 0;
  IconData collapseIcon = Icons.arrow_drop_down;
  double opacity = 1.0;

  Future<void> makeLikes(int postId, bool isLiked) async {
    if (!_liked) {
      likes++;
      _liked = !_liked;
    } else {
      likes--;
      _liked = !_liked;
    }

    if (isLiked) {
      await Discourse().unlikePost(postId: postId);
    } else {
      await Discourse().likePost(postId: postId);
    }

    notifyListeners();
  }

  Future<PostData> getPosts(int topicId) async {
    PostData data;
    final uri = Uri.parse(DiscourseRest.urlTopic(topicId));
    var response = await http.get(uri, headers: DiscourseRest.headers);
    if (response.statusCode == 200) {
      final uri = Uri.parse(DiscourseRest.urlCategories);
      var catResponse = await http.get(uri, headers: DiscourseRest.headers);
      if (catResponse.statusCode == 200) {
        data = PostData.toData(
            json.decode(response.body), json.decode(catResponse.body));
      }
    }
    return data;
  }

  int getPostCategory(CategoryList category, int catId) =>
      category.categoryList.indexWhere((element) => element.id == catId);

  String getLastposted(DateTime lastpost) {
    Duration difference = DateTime.now().difference(lastpost);
    if (difference.inDays >= 1)
      return '${difference.inDays} d';
    else if (difference.inHours >= 1)
      return '${difference.inHours} h';
    else if (difference.inMinutes >= 1)
      return '${difference.inMinutes} m';
    else
      return '${difference.inSeconds} s';
  }
}

class TopicInfoProvider with ChangeNotifier {
  double containerHeight = 60.0;
  bool valueFull = true;
  IconData collapseIcon = Icons.arrow_drop_down;

  String getLastposted(DateTime lastpost) {
    Duration difference = DateTime.now().difference(lastpost);
    if (difference.inDays >= 1)
      return '${difference.inDays} d';
    else if (difference.inHours >= 1)
      return '${difference.inHours} h';
    else if (difference.inMinutes >= 1)
      return '${difference.inMinutes} m';
    else
      return '${difference.inSeconds} s';
  }

  void changeView() {
    valueFull = !valueFull;
    if (containerHeight == 100.0) {
      containerHeight = 60.0;
      collapseIcon = Icons.arrow_drop_down;
    } else {
      containerHeight = 100.0;
      collapseIcon = Icons.arrow_drop_up;
    }
    notifyListeners();
  }
}

class ReplyProvider with ChangeNotifier {
  bool isReplyValid = false;
  String replyText;
  XFile imageFile;
  bool isLoading = false;

  validateReply(String val) {
    if (val.length >= 20) {
      replyText = val;
      isReplyValid = true;
    } else {
      replyText = val;
      isReplyValid = false;
    }
    notifyListeners();
  }

  setImage(XFile file) {
    imageFile = file;
    notifyListeners();
  }

  updatePost(int topicId, int postId, int postNumber, BuildContext context,
      {String image}) async {
    String messageText = '';
    isLoading = true;
    isReplyValid = false;
    notifyListeners();
    if (image != null)
      messageText = replyText +
          '<br><img src=\"$image\" width=\"\" height=\"\" alt=\"\">';
    else
      messageText = replyText;

    Map<String, dynamic> raw = {
      'raw': messageText,
      'topic_id': topicId.toString(),
      'reply_to_post_number': '$postNumber',
    };
    final currentUser =
        await Discourse().getUserById(id: Discourse().currentUserId);
    final uri = Uri.parse(DiscourseRest.urlCreateTopic);
    var response = await http.post(uri,
        headers: Discourse().getHeadersForUser(currentUser.username),
        body: raw);
    if (response.statusCode == 200) {
      isLoading = false;
      isReplyValid = true;
      notifyListeners();
      return Navigator.pop(context);
    } else {
      isLoading = false;
      isReplyValid = true;
      notifyListeners();
      throw Exception('Error ${response.reasonPhrase}');
    }
  }

  uploadImage(
      int topicId, int postId, int postNumber, BuildContext context) async {
    isLoading = true;
    isReplyValid = false;
    notifyListeners();
    if (imageFile != null) {
      var uploadTask = FirebaseStorage.instance
          .ref()
          .child('/forum_images/${basename(imageFile.path)}')
          .putFile(File(imageFile.path));
      uploadTask
        ..then((value) => value.ref.getDownloadURL().then((value) => updatePost(
            topicId, postId, postNumber, context,
            image: value.toString())));
    }
  }
}
