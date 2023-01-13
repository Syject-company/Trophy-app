class DiscourseRest {
  static const forumUrl = 'https://community.irla.co';
  static const urlLatestPosts = '$forumUrl/latest.json';
  static const urlTopPosts = '$forumUrl/top/weekly.json';
  static const urlCategories = '$forumUrl/site.json';
  static const urlMainCategories = '$forumUrl/categories.json';
  static const urlCreateTopic = '$forumUrl/posts.json';
  static const urlCreateUser = '$forumUrl/users.json';
  static const urlUpdateAvatar =
      '$forumUrl/u/{username}/preferences/avatar/pick.json';
  static const urlDeleteUser = '$forumUrl/admin/users/{id}.json';
  static const urlCreateUpload = '$forumUrl/uploads.json';

  //TODO: Api-Username change to user login
  static const Map<String, String> headers = {
    "Content-type": "application/json",
    'Api-Key':
        "c96757b94737487a9a7a70c457e7c8df7aaf9367e0e07918dc4cdf576a9c13bb",
    'Api-Username': 'mishkov'
  };

  //TODO: Api-Username change to user login
  static const Map<String, String> postHeaders = {
    "Content-type": 'application/x-www-form-urlencoded',
    'Api-Key':
        "c96757b94737487a9a7a70c457e7c8df7aaf9367e0e07918dc4cdf576a9c13bb",
    'Api-Username': 'mishkov'
  };
  static String urlTopic(int topicId) =>
      'https://community.irla.co/t/${topicId.toString()}.json';

  static String searchQuery(String val) =>
      'https://community.irla.co/search.json?q=$val';
}
