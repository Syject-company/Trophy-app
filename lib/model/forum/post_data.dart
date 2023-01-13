import 'package:trophyapp/model/forum/categories.dart';
import 'package:trophyapp/model/forum/topic_posts.dart';

class PostData {
  final TopicPosts post;
  final CategoryList categories;

  PostData({this.post, this.categories});

  factory PostData.toData(
          Map<String, dynamic> post, Map<String, dynamic> category) =>
      PostData(
          post: TopicPosts.fromJson(post),
          categories: CategoryList.fromJson(category));
}
