import 'package:trophyapp/model/forum/post_list.dart';
import 'package:trophyapp/model/forum/user_count.dart';

class TopicPosts {
  final PostsList topics;
  final String topicTitle;
  final DateTime createTime;
  final DateTime lastPostTime;
  final int replyCont;
  final int views;
  final int likes;
  final UsersCount usersCount;
  final int category;

  TopicPosts(
      {this.topics,
      this.topicTitle,
      this.createTime,
      this.lastPostTime,
      this.replyCont,
      this.views,
      this.likes,
      this.usersCount,
      this.category});

  factory TopicPosts.fromJson(Map<String, dynamic> json) => TopicPosts(
      topics: PostsList.fromJson(
        json['post_stream'],
      ),
      topicTitle: json['title'] as String,
      createTime: DateTime.parse(json['created_at']),
      lastPostTime: DateTime.parse(json['last_posted_at']),
      replyCont: json['reply_count'] as int,
      views: json['views'] as int,
      likes: json['like_count'] as int,
      usersCount: UsersCount.fromJson(json['details']),
      category: json['category_id']);
}
