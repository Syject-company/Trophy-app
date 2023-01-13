import 'package:trophyapp/model/forum/post.dart';

class PostsList {
  final List<Post> postsList;

  PostsList({this.postsList});

  factory PostsList.fromJson(Map<String, dynamic> json) {
    var postsJson = json['posts'] as List;
    List<Post> postsList = postsJson.map((e) => Post.fromJson(e)).toList();
    return PostsList(postsList: postsList);
  }
}
