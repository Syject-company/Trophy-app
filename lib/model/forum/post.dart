import 'package:html/parser.dart';
import 'package:trophyapp/constants/discourse_rest.dart';
import 'package:trophyapp/model/forum/like.dart';

class Post {
  final int id;
  final String name;
  final String username;
  final String userAvatar;
  final int postNumber;
  final DateTime updateTime;
  final String postText;
  final bool isQuote;
  final String quoteAvatar;
  final String quoteUsername;
  final String quoteText;
  final int replyToPost;
  final Like likes;

  Post(
      {this.id,
      this.name,
      this.username,
      this.userAvatar,
      this.postNumber,
      this.updateTime,
      this.postText,
      this.isQuote,
      this.quoteAvatar,
      this.quoteUsername,
      this.quoteText,
      this.replyToPost,
      this.likes});

  factory Post.fromJson(Map<String, dynamic> json) {
    bool isQuote = false;
    String message;
    String quoteText;
    String quoteAvatar;
    String quoteUsername;
    Like likes;
    String userAvatar = json['avatar_template'];
    var likesJson = json['actions_summary'] as List;
    likesJson.forEach((element) {
      var data = Like.fromJson(element);

      if (data.id == 2) {
        likes = data;
      }
    });
    var postText = parse(json['cooked']);
    if (postText.getElementsByTagName('blockquote').isNotEmpty) {
      isQuote = true;
      quoteText = postText
          .getElementsByTagName('blockquote')[0]
          .outerHtml
          .replaceAll('<blockquote>', '');
      if (postText.getElementsByTagName('img').isNotEmpty) {
        quoteAvatar = postText
            .getElementsByTagName('img')[0]
            .attributes
            .values
            .toList()[3];
      }

      if (postText.getElementsByClassName('title').isNotEmpty) {
        quoteUsername = postText
            .getElementsByClassName('title')[0]
            .text
            .replaceAll(':', '')
            .trim();
      }

      // getting message without quote text
      int quotePcount = postText
          .getElementsByTagName('blockquote')[0]
          .getElementsByTagName('p')
          .length;
      List pList = postText.getElementsByTagName('p');
      pList.removeRange(0, quotePcount - 1);
      pList.forEach((element) {
        message = '' + element.outerHtml.toString();
      });
    } else {
      isQuote = false;
      message = json['cooked'];
    }
    return Post(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      userAvatar:
          DiscourseRest.forumUrl + userAvatar.replaceAll('{size}', '40'),
      postNumber: json['post_number'] as int,
      updateTime: DateTime.parse(json['updated_at']),
      postText: message,
      quoteText: quoteText,
      quoteAvatar: quoteAvatar,
      quoteUsername: quoteUsername,
      isQuote: isQuote,
      replyToPost: json['reply_to_post_number'],
      likes: likes,
    );
  }
}
