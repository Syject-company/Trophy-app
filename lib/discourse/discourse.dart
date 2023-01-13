import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

/// Represantion of type enum for create upload
///
/// See details: https://docs.discourse.org/#tag/Uploads/paths/~1uploads.json/post
enum UploadType {
  avatar,
  profileBackground,
  cardBackround,
  customEmoji,
  composer,
}

extension UploadTypeJson on UploadType {
  String toJson() {
    Map<UploadType, String> table = {
      UploadType.avatar: 'avatar',
      UploadType.profileBackground: 'profile_background',
      UploadType.cardBackround: 'card_background',
      UploadType.customEmoji: 'custom_emoji',
      UploadType.composer: 'composer',
    };

    return table[this];
  }
}

/// Representation of type enum for update avatar.
///
/// See details: https://docs.discourse.org/#tag/Users/paths/~1u~1{username}~1preferences~1avatar~1pick.json/put
enum UpdateAvatarType {
  uploaded,
  custom,
  gravatar,
  system,
}

extension UpdateAvatarTypeJson on UpdateAvatarType {
  String toJson() {
    return this.toString().split('.').last;
  }
}

/// Representation of flag enum for get a list of users.
///
/// See details: https://docs.discourse.org/#tag/Users/paths/~1admin~1users~1list~1{flag}.json/get
enum UserFlag {
  active,
  newUser,
  staff,
  suspended,
  blocked,
  suspect,
}

extension UserGlagJson on UserFlag {
  String toJson() {
    if (this == UserFlag.newUser) {
      return 'new';
    } else {
      return this.toString().split('.').last;
    }
  }
}

/// Represantion of order enum for get a list of users.
///
/// See details: https://docs.discourse.org/#tag/Users/paths/~1admin~1users~1list~1{flag}.json/get
enum UsersOrder {
  created,
  lastEmailed,
  seen,
  username,
  email,
  trustLevel,
  daysVisited,
  postsRead,
  topicsViewed,
  posts,
  readTime,
}

extension OrderJson on UsersOrder {
  String toJson() {
    Map<UsersOrder, String> table = {
      UsersOrder.created: 'created',
      UsersOrder.lastEmailed: 'last_emailed',
      UsersOrder.seen: 'seen',
      UsersOrder.username: 'username',
      UsersOrder.email: 'email',
      UsersOrder.trustLevel: 'trust_level',
      UsersOrder.daysVisited: 'days_visited',
      UsersOrder.postsRead: 'posts_read',
      UsersOrder.topicsViewed: 'topics_viewed',
      UsersOrder.posts: 'posts',
      UsersOrder.readTime: 'read_time',
    };

    return table[this];
  }
}

/// Represantion of order enum for get the latest topics.
///
/// See details: https://docs.discourse.org/#tag/Topics/paths/~1latest.json/get
enum TopicsOrder {
  defaultOrder,
  created,
  activity,
  views,
  posts,
  category,
  likes,
  opLikes,
  posters,
}

extension TopicssOrderJson on TopicsOrder {
  String toJson() {
    Map<TopicsOrder, String> table = {
      TopicsOrder.defaultOrder: 'default',
      TopicsOrder.created: 'created',
      TopicsOrder.activity: 'activity',
      TopicsOrder.views: 'views',
      TopicsOrder.posts: 'posts',
      TopicsOrder.category: 'category',
      TopicsOrder.likes: 'likes',
      TopicsOrder.opLikes: 'op_likes',
      TopicsOrder.posters: 'posters',
    };

    return table[this];
  }
}

class Discourse {
  /// When you create api key set "User Level" to Single
  static const String _adminUsername = 'mishkov';

  /// When you create api key it should has all needed scopes or should be the
  /// Global Key (allows all actions)
  static const String _adminApiKey =
      'c96757b94737487a9a7a70c457e7c8df7aaf9367e0e07918dc4cdf576a9c13bb';
  static const String _allUsersApiKey =
      'cbaee4470f8cff22c5083e0fcd14b99bf434ff3be42443380e370eaca7dac108';
  static const String defaultHost = 'community.irla.co';
  Map<String, String> _defaultHeaders = {
    'Api-Username': '$_adminUsername',
    'Api-Key': _adminApiKey,
    'Accept': 'application/json'
  };

  static const noUserId = -1;
  int _currentUserId = noUserId;

  static final Discourse _instance = Discourse._internal();

  factory Discourse() => _instance;

  Discourse._internal() {
    _loadCurrentUser();
  }

  int get currentUserId => _currentUserId;
  bool get hasCurrentUser => _currentUserId != noUserId;

  Map<String, String> getHeadersForUser(String username) {
    return {
      'Api-Username': '$username',
      'Api-Key': _allUsersApiKey,
      'Accept': 'application/json'
    };
  }

  Future<void> createCurrentUser({
    @required String name,
    @required String email,
    @required String password,
    @required String username,
    bool active = false,
    bool approved = false,
    List<String> userFields,
  }) async {
    _currentUserId = await createUser(
      name: name,
      email: email,
      password: password,
      username: username,
      active: active,
      approved: approved,
      userFields: userFields,
    );
    await _saveCurrentUser();
  }

  /// Creates new user.
  ///
  /// Returns id of created user.
  ///
  /// Name and email must be unique.
  /// Password length must be at least 10
  Future<int> createUser({
    @required String name,
    @required String email,
    @required String password,
    @required String username,
    bool active = false,
    bool approved = false,
    List<String> userFields,
  }) async {
    Map<String, String> requestBody = {
      'name': name,
      'email': email,
      'password': password,
      'username': username,
      'active': active.toString(),
      'approved': approved.toString(),
      'user_fields[1]': userFields.toString(),
    };
    final uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/users.json',
    );

    final response = await http.post(
      uri,
      headers: _defaultHeaders,
      body: requestBody,
    );

    if (response.statusCode != 200) {
      throw DiscourseException(
          'Create user failed. Connection error:${response.statusCode}:${response.reasonPhrase}');
    }

    final Map body = jsonDecode(response.body);
    if (!body.containsKey('success')) {
      throw DiscourseException(
          'Create user failed. Response body does not contain success value');
    }

    final success = body['success'];
    if (!success) {
      throw DiscourseException('Create user failed. Response body: $body');
    }

    if (!body.containsKey('user_id')) {
      throw DiscourseException(
          'Create user failed. Body does not contain user_id value: $body');
    }

    return body['user_id'];
  }

  Future<void> _saveCurrentUser() async {
    final secureStorage = new FlutterSecureStorage();

    final options = IOSOptions(accessibility: IOSAccessibility.first_unlock);
    await secureStorage.write(
      key: 'discourse_user_id',
      value: _currentUserId.toString(),
      iOptions: options,
    );
  }

  Future<void> _loadCurrentUser() async {
    final secureStorage = new FlutterSecureStorage();

    final options = IOSOptions(accessibility: IOSAccessibility.first_unlock);
    if (await secureStorage.containsKey(
        key: 'discourse_user_id', iOptions: options)) {
      _currentUserId = int.parse(await secureStorage.read(
          key: 'discourse_user_id', iOptions: options));
    }
  }

  Future<void> updateAvatarForCurrentUser({@required String filePath}) async {
    await updateAvatar(userId: _currentUserId, filePath: filePath);
  }

  /// Update avatar for current user.
  ///
  /// Need to call after after [CreateUser] e.c. otherwise will throw Exception
  Future<void> updateAvatar(
      {@required int userId, @required String filePath}) async {
    if (userId.isNegative) {
      throw DiscourseException(
          'Update avatar failed. Invalid id. Must be positive.');
    }
    final user = await getUserById(id: userId);
    final uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/u/${user.username}/preferences/avatar/pick.json',
    );
    final upload = await _createUpload(
      type: UploadType.avatar,
      userId: userId,
      filePath: filePath,
    );
    final Map<String, String> requestBody = {
      'upload_id': '${upload.id}',
      'type': UpdateAvatarType.uploaded.toJson(),
    };

    final response = await http.put(
      uri,
      headers: _defaultHeaders,
      body: requestBody,
    );

    if (response.statusCode != 200) {
      throw DiscourseException(
          'Update user avatar failed. Connection error:${response.statusCode}:${response.reasonPhrase}:${response.body}');
    }

    final Map body = jsonDecode(response.body);
    if (!body.containsKey('success')) {
      throw DiscourseException(
          'Update user avatar failed. Response body does not contain success value');
    }

    final success = body['success'];
    if (success != 'OK') {
      throw DiscourseException(
          'Update user avatar failed. Response body: $body');
    }
  }

  /// [userId] is requiered if type is UploadType.Avatar.
  Future<Upload> _createUpload({
    @required UploadType type,
    int userId,
    String filePath,
  }) async {
    if (type == UploadType.avatar) {
      if (userId == null) {
        throw DiscourseException(
            'userId is required if uploading an avatar! See: https://docs.discourse.org/#tag/Uploads/paths/~1uploads.json/post');
      } else if (userId.isNegative) {
        throw DiscourseException('id should be position or 0');
      }
    }

    Uri uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/uploads.json',
    );
    final Map<String, String> requestFields = {
      'type': type.toJson(),
      'user_id': (userId ?? 0).toString(),
      'synchronous': 'true',
    };
    final file = await http.MultipartFile.fromPath(
      'files[]',
      filePath,
      contentType: MediaType('multipart', 'form-data'),
    );
    final request = http.MultipartRequest('POST', uri)
      ..fields.addAll(requestFields)
      ..files.add(file)
      ..headers.addAll(_defaultHeaders);

    final response = await request.send();

    if (response.statusCode != 200) {
      throw DiscourseException(
          'Create upload failed. Connection error:${response.statusCode}:${response.reasonPhrase}');
    }

    final responseData = await response.stream.toBytes();
    final jsonBody = String.fromCharCodes(responseData);
    final Map body = jsonDecode(jsonBody);
    if (!body.containsKey('id')) {
      throw DiscourseException(
          'Create upload failed. Response body does not contain id value: $body');
    }

    return Upload.fromJson(body);
  }

  Future<User> getUserById({@required int id}) async {
    if (id.isNegative) {
      throw DiscourseException('id should be positive or 0');
    }
    final uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/admin/users/$id.json',
    );

    final response = await http.get(uri, headers: _defaultHeaders);

    if (response.statusCode != 200) {
      throw DiscourseException(
          'Get user by id failed. Connection error:${response.statusCode}:${response.reasonPhrase}');
    }

    final Map body = jsonDecode(response.body);
    if (!body.containsKey('id')) {
      throw DiscourseException('Get user by id failed. Response body: $body');
    }

    return User.fromJson(body);
  }

  Future<User> getUserByEmail({@required String email}) async {
    final uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/admin/users/list/active.json',
      queryParameters: {
        'filter': email,
      },
    );

    final response = await http.get(uri, headers: _defaultHeaders);

    if (response.statusCode != 200) {
      throw DiscourseException(
          'Get user by email failed. Connection error:${response.statusCode}:${response.reasonPhrase}');
    }

    final body = jsonDecode(response.body);
    if (body is! List) {
      throw DiscourseException(
          'Get user by email failed. Body is not List: $body');
    }
    if (body.isEmpty) {
      throw DiscourseException(
          'Get user by email failed. No user found: $body');
    }

    return User.fromJson(body.first);
  }

  Future<void> deleteUser({
    @required int id,
    bool deletePosts = false,
    bool blockEmail = false,
    bool blockUrls = false,
    bool blockIp = false,
  }) async {
    if (id.isNegative) {
      throw DiscourseException('id should be position or 0');
    }
    final uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/admin/users/$id.json',
    );

    /// This looks so because API works very strange. No matter you pass
    /// 'true' or 'false' any field will be true but when you pass nothing field
    /// will be false.
    Map<String, dynamic> requestBody;
    if (deletePosts) {
      requestBody['delete_posts'] = 'true';
    }
    if (blockEmail) {
      requestBody['block_email'] = 'true';
    }
    if (blockUrls) {
      requestBody['block_urls'] = 'true';
    }
    if (blockIp) {
      requestBody['block_ip'] = 'true';
    }

    final response = await http.delete(
      uri,
      headers: _defaultHeaders,
      body: requestBody,
    );

    if (response.statusCode != 200) {
      throw DiscourseException(
          'Delete user failed. Connection error:${response.statusCode}:${response.reasonPhrase}:${response.body}');
    }

    final Map body = jsonDecode(response.body);
    if (!body.containsKey('deleted')) {
      throw DiscourseException('Delete user failed. Response body:  $body');
    }

    if (!body['deleted']) {
      throw DiscourseException('Delete user failed. Response body:  $body');
    }
  }

  Future<void> deleteCurrentUser({
    bool deletePosts = false,
    bool blockEmail = false,
    bool blockUrls = false,
    bool blockIp = false,
  }) async {
    await deleteUser(
      id: _currentUserId,
      blockEmail: blockEmail,
      blockUrls: blockUrls,
      blockIp: blockIp,
    );
    _removeCurrentUser();
    _currentUserId = noUserId;
  }

  Future<void> _removeCurrentUser() async {
    final secureStorage = new FlutterSecureStorage();

    final options = IOSOptions(accessibility: IOSAccessibility.first_unlock);
    if (await secureStorage.containsKey(
        key: 'discourse_user_id', iOptions: options)) {
      await secureStorage.delete(key: 'discourse_user_id', iOptions: options);
    }
  }

  Future<List<User>> getUsers({
    @required UserFlag flag,
    UsersOrder order,
    bool ascending = false,
    int page,
    bool showEmails = false,
  }) async {
    if (page.isNegative) {
      throw DiscourseException('page should be positive or 0');
    }
    final Map<String, dynamic> queryParameters = {
      'order': order.toJson(),
      'asc': ascending.toString(),
      'page': page.toString(),
      'show_emails': showEmails.toString(),
    };
    final uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/admin/users/list/${flag.toJson()}.json',
      queryParameters: queryParameters,
    );

    final response = await http.get(uri, headers: _defaultHeaders);

    if (response.statusCode != 200) {
      throw DiscourseException(
          'Get a list of users failed. Connection error:${response.statusCode}:${response.reasonPhrase}');
    }

    final body = jsonDecode(response.body);
    if (body is! List) {
      throw DiscourseException(
          'Get a list of users failed. Body is not List: $body');
    }

    return List<User>.generate(body.length, (index) {
      return User.fromJson(body[index]);
    });
  }

  Future<void> setCurrentUser({@required int userId}) async {
    _currentUserId = userId;
    _saveCurrentUser();
  }

  Future<List<Topic>> getLatestTopics({
    TopicsOrder order = TopicsOrder.created,
    bool ascending = false,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'order': order.toJson(),
      'asc': ascending.toString(),
    };
    final uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/latest.json',
      queryParameters: queryParameters,
    );

    final user = await getUserById(id: _currentUserId);

    final response =
        await http.get(uri, headers: getHeadersForUser(user.username));

    if (response.statusCode != 200) {
      throw DiscourseException(
          'Get the latest topics failed. Connection error:${response.statusCode}:${response.reasonPhrase}');
    }

    final Map usersAndTopics = jsonDecode(response.body);
    if (!usersAndTopics.containsKey('topic_list')) {
      throw DiscourseException(
          'Get the latest topics failed. Body does not contain "topic_list" key: $usersAndTopics');
    }

    if (usersAndTopics['topic_list']['topics'].isEmpty) {
      return [];
    }

    if (!usersAndTopics.containsKey('users')) {
      throw DiscourseException(
          'Get the latest topics failed. Body does not contain "users" key: $usersAndTopics');
    }

    List<Topic> topics = await _parseTopics(usersAndTopics);

    return topics;
  }

  Future<List<Topic>> getTopTopics() async {
    final uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/top.json',
    );

    final response = await http.get(uri, headers: _defaultHeaders);

    if (response.statusCode != 200) {
      throw DiscourseException(
          'Get the top topics failed. Connection error:${response.statusCode}:${response.reasonPhrase}');
    }

    final Map usersAndTopics = jsonDecode(response.body);
    if (!usersAndTopics.containsKey('topic_list')) {
      throw DiscourseException(
          'Get the top topics failed. Body does not contain "topic_list" key: $usersAndTopics');
    }

    if (usersAndTopics['topic_list']['topics'].isEmpty) {
      return [];
    }

    if (!usersAndTopics.containsKey('users')) {
      throw DiscourseException(
          'Get the top topics failed. Body does not contain "users" key: $usersAndTopics');
    }

    List<Topic> topics = await _parseTopics(usersAndTopics);

    return topics;
  }

  Future<List<Topic>> _parseTopics(Map<dynamic, dynamic> usersAndTopics) async {
    final categories = await getCategories();

    final List jsonUsers = usersAndTopics['users'];
    final users = jsonUsers.map<User>((user) => User.fromJson(user)).toList();

    final List jsonTopics = usersAndTopics['topic_list']['topics'];
    List<Topic> topics = [];
    for (Map jsonTopic in jsonTopics) {
      Topic topic = Topic.fromJson(jsonTopic);
      topic.lastPosterUsername = jsonTopic['last_poster_username'];

      User lastPoster = users.firstWhere((user) {
        return user.username == topic.lastPosterUsername;
      });
      topic.lastPosterAvatar500px = lastPoster.avatar500px;

      Category category = categories.firstWhere(
          (category) => category.id == topic.categoryId,
          orElse: () => null);
      if (category == null) {
        category = await getCategory(id: topic.categoryId);
      }
      topic.category = category;

      topics.add(topic);
    }
    return topics;
  }

  Future<List<Category>> getCategories() async {
    final uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/categories.json',
    );

    final response = await http.get(uri, headers: _defaultHeaders);

    if (response.statusCode != 200) {
      throw DiscourseException(
          'Get a list of categories failed. Connection error:${response.statusCode}:${response.reasonPhrase}');
    }

    final Map body = jsonDecode(response.body);
    if (!body.containsKey('category_list')) {
      throw DiscourseException(
          'Get a list of categories failed. Body does not contain "categories_list" key: $body');
    }

    final List jsonCategories = body['category_list']['categories'];
    return jsonCategories
        .map((category) => Category.fromJson(category))
        .toList();
  }

  Future<Category> getCategory({@required int id}) async {
    final uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/c/$id/show.json',
    );

    final response = await http.get(uri, headers: _defaultHeaders);

    if (response.statusCode != 200) {
      throw DiscourseException(
          'Get a category failed. Connection error:${response.statusCode}:${response.reasonPhrase}');
    }

    final Map body = jsonDecode(response.body);
    if (!body.containsKey('category')) {
      throw DiscourseException(
          'Get a category failed. Body does not contain "category" key: $body');
    }

    final Map jsonCategory = body['category'];
    return Category.fromJson(jsonCategory);
  }

  Future<List<Category>> getSubcategoriesOf(
      {@required Category category}) async {
    final uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/site.json',
    );

    final response = await http.get(uri, headers: _defaultHeaders);

    if (response.statusCode != 200) {
      throw DiscourseException(
          'Get a subcategory failed. Connection error:${response.statusCode}:${response.reasonPhrase}');
    }

    final Map body = jsonDecode(response.body);
    if (!body.containsKey('categories')) {
      throw DiscourseException(
          'Get a subcategory failed. Body does not contain "categories" key: $body');
    }

    final List jsonCategories = body['categories'];
    List<Category> subcategories = [];
    category.subcategoryIds.forEach((id) {
      Map subcategory = jsonCategories.firstWhere((category) {
        return category['id'] == id;
      });
      subcategories.add(Category.fromJson(subcategory));
    });

    return subcategories;
  }

  /// This method was created for optimised request.
  ///
  /// Instead of sending 'get Categories' request and then for each sending
  /// 'get Subcategories' request, we send only two request (for main categories
  /// and for all categories, because all categories does not contain hierarchy)
  /// and then parse those local.
  Future<List<Category>> getCategoriesAndSubcategories() async {
    final uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/site.json',
    );

    final response = await http.get(uri, headers: _defaultHeaders);

    if (response.statusCode != 200) {
      throw DiscourseException(
          'Get categories and subcategories failed. Connection error:${response.statusCode}:${response.reasonPhrase}');
    }

    final Map body = jsonDecode(response.body);
    if (!body.containsKey('categories')) {
      throw DiscourseException(
          'Get categories and subcategories failed. Body does not contain "categories" key: $body');
    }

    final List jsonAllCategories = body['categories'];

    final mainCategories = await getCategories();
    mainCategories.forEach((mainCategory) {
      List<Category> subcategories = [];

      mainCategory.subcategoryIds.forEach((id) {
        Map subcategory = jsonAllCategories.firstWhere((category) {
          return category['id'] == id;
        });
        subcategories.add(Category.fromJson(subcategory));
      });

      mainCategory.subcategories = subcategories;
    });

    return mainCategories;
  }

  Future<List<Topic>> searchTopics({@required String query}) async {
    final Map<String, dynamic> queryParameters = {
      'q': query,
    };
    final uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/search.json',
      queryParameters: queryParameters,
    );

    final response = await http.get(uri, headers: _defaultHeaders);

    if (response.statusCode != 200) {
      throw DiscourseException(
          'Search topics failed. Connection error:${response.statusCode}:${response.reasonPhrase}');
    }

    final Map searchResult = jsonDecode(response.body);
    if (!searchResult.containsKey('topics')) {
      throw DiscourseException(
          'Search topics failed. Body does not contain "topics" key: $searchResult');
    }

    List<Category> categories = await getCategoriesAndSubcategories();
    List jsonTopics = searchResult['topics'];
    List<Topic> topics = [];
    for (var jsonTopic in jsonTopics) {
      var topic = Topic.fromJson(jsonTopic);
      topic.category = categories.firstWhere((category) {
        return category.id == topic.categoryId;
      }, orElse: () {
        var subcategory;
        for (var mainCategory in categories) {
          subcategory = mainCategory.subcategories.firstWhere((category) {
            return category.id == topic.categoryId;
          }, orElse: () => null);
          if (subcategory != null) {
            break;
          }
        }
        return subcategory;
      });

      final jsonPostOfTopic = searchResult['posts'].firstWhere((post) {
        return post['topic_id'] == topic.id;
      });

      topic.lastPosterUsername = jsonPostOfTopic['username'];
      topic.lastPosterAvatar500px =
          "https://$defaultHost${jsonPostOfTopic['avatar_template'].replaceAll('\{size\}', '500')}";

      topics.add(topic);
    }

    return topics;
  }

  Future<Topic> getTopicById({@required int id}) async {
    final uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/t/$id.json',
    );

    final response = await http.get(uri, headers: _defaultHeaders);

    if (response.statusCode != 200) {
      throw DiscourseException(
          'Get single Topic failed. Connection error:${response.statusCode}:${response.reasonPhrase}');
    }

    final Map jsonTopic = jsonDecode(response.body);
    if (!jsonTopic.containsKey('id')) {
      throw DiscourseException(
          'Get single Topic failed. Body does not contain "id" key: $jsonTopic');
    }

    var topic = Topic.fromJson(jsonTopic);
    topic.category = await getCategory(id: topic.categoryId);
    topic.lastPosterUsername = jsonTopic['details']['last_poster']['username'];
    topic.lastPosterAvatar500px = jsonTopic['details']['last_poster']
            ['avatar_template']
        .replaceAll('{size}', '500');

    return topic;
  }

  /// Return id of created Topic.
  Future<int> createTopic({
    @required String title,
    @required String raw,
    @required int categoryId,
    File file,
  }) async {
    if (file != null) {
      final upload = await _createUpload(
        type: UploadType.composer,
        filePath: file.path,
      );
      final markdownFile = '![${upload.originalFilename}](${upload.shortUrl})';
      raw += '\n$markdownFile';
    }

    final uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/posts.json',
    );

    final Map<String, String> body = {
      'title': title,
      'raw': raw,
      'category': categoryId.toString(),
      'created_at': DateTime.now().toUtc().toIso8601String(),
    };

    final user = await getUserById(id: _currentUserId);

    final response = await http.post(
      uri,
      headers: getHeadersForUser(user.username),
      body: body,
    );

    if (response.statusCode != 200) {
      throw DiscourseException(
          'Create Topic failed. Connection error:${response.statusCode}:${response.reasonPhrase}:${response.body}');
    }

    final Map jsonTopic = jsonDecode(response.body);
    if (!jsonTopic.containsKey('id')) {
      throw DiscourseException(
          'Create Topic failed. Body does not contain "id" key: $jsonTopic');
    }

    return jsonTopic['topic_id'];
  }

  // TODO: cover with tests
  Future<void> notifyAuthor({@required int postId}) async {
    final uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/post_actions.json',
    );

    final Map<String, String> body = {
      "id": "$postId",
      // TODO: create enum for post action type
      "post_action_type_id": "6",
    };

    final user = await getUserById(id: _currentUserId);

    final response = await http.post(
      uri,
      headers: getHeadersForUser(user.username),
      body: body,
    );

    if (response.statusCode != 200) {
      throw DiscourseException(
          "Notify topic's author failed. Connection error:${response.statusCode}:${response.reasonPhrase}");
    }

    final Map jsonTopic = jsonDecode(response.body);
    if (!jsonTopic.containsKey('id')) {
      throw DiscourseException(
          "Notify topic's author failed. Body does not contain 'id' key: $jsonTopic");
    }
  }

  Future<void> likePost({@required int postId}) async {
    final uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/post_actions.json',
    );

    final Map<String, String> body = {
      "id": "$postId",
      // TODO: create enum for post action type
      "post_action_type_id": "2",
    };

    final user = await getUserById(id: _currentUserId);

    final response = await http.post(
      uri,
      headers: getHeadersForUser(user.username),
      body: body,
    );

    if (response.statusCode != 200) {
      throw DiscourseException(
          "Like a post failed. Connection error:${response.statusCode}:${response.reasonPhrase}");
    }

    final Map jsonTopic = jsonDecode(response.body);
    if (!jsonTopic.containsKey('id')) {
      throw DiscourseException(
          "Like a post failed. Body does not contain 'id' key: $jsonTopic");
    }
  }

  Future<void> unlikePost({@required int postId}) async {
    final uri = Uri(
      scheme: 'https',
      host: defaultHost,
      path: '/post_actions/$postId.json',
    );

    final Map<String, String> body = {
      // TODO: create enum for post action type
      "post_action_type_id": "2",
    };

    final user = await getUserById(id: _currentUserId);

    final response = await http.delete(
      uri,
      headers: getHeadersForUser(user.username),
      body: body,
    );

    if (response.statusCode != 200) {
      throw DiscourseException(
          "Unlike a post failed. Connection error:${response.statusCode}:${response.reasonPhrase}");
    }

    final Map jsonTopic = jsonDecode(response.body);
    if (!jsonTopic.containsKey('id')) {
      throw DiscourseException(
          "Unlike a post failed. Body does not contain 'id' key: $jsonTopic");
    }
  }
}

/// Partly representation of Topic of Discourse forum.
///
/// This class can consists of more fields. See details:
/// https://docs.discourse.org/#tag/Topics/paths/~1latest.json/get
class Topic {
  int id;
  String title;
  int categoryId;
  Category category;
  int replyCount;
  DateTime lastPostedTime;
  String lastPosterUsername;
  String lastPosterAvatar500px;

  Topic({
    this.id,
    this.title,
    this.categoryId,
    this.replyCount,
    this.lastPostedTime,
    this.lastPosterUsername,
    this.lastPosterAvatar500px,
  });

  Topic.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    title = json['title'] as String;
    categoryId = json['category_id'] as int;
    replyCount = json['reply_count'] as int;
    lastPostedTime = DateTime.parse(json['last_posted_at']);
  }
}

/// Partly representation of user of Discourse forum.
///
/// This class can consists of more fields. See details:
/// https://docs.discourse.org/#tag/Categories/paths/~1categories.json/get
class Category {
  int id;
  String name;
  String color;
  List<int> subcategoryIds;
  List<Category> subcategories;

  Category({
    this.id,
    this.name,
    this.color,
    this.subcategoryIds,
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
    if (json.containsKey('subcategory_ids')) {
      subcategoryIds = json['subcategory_ids'].map<int>((id) {
        return id as int;
      }).toList();
    }
  }
}

/// Partly representation of user of Discourse forum.
///
/// This class can consists of more fields. See details:
/// https://docs.discourse.org/#tag/Users/paths/~1admin~1users~1{id}.json/get
class User {
  static const String emptyAvatar =
      'https://${Discourse.defaultHost}/user_avatar/${Discourse.defaultHost}/mishkov/0/19_2.png';

  int id;
  String username;

  /// Looks like /user_avatar/community.irla.co/mishkov/{size}/19_2.png
  /// replace {size} with side of square of avatar in pixels
  String avatarTemplate;
  String avatar500px;

  User({this.id, this.username, this.avatarTemplate}) {
    if (avatarTemplate != null) {
      avatarTemplate = 'https://${Discourse.defaultHost}$avatarTemplate';
      avatar500px = avatarTemplate.replaceAll('{size}', '500');
    } else {
      avatar500px = emptyAvatar;
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      avatarTemplate: json['avatar_template'],
    );
  }
}

class Upload {
  int id;
  String url;
  String originalFilename;
  int filesize;
  int width;
  int height;
  int thumbnailWidth;
  int thumbnailHeight;
  String extension;
  String shortUrl;
  String shortPath;
  String retainHours;
  String humanFilesize;

  Upload(
      {this.id,
      this.url,
      this.originalFilename,
      this.filesize,
      this.width,
      this.height,
      this.thumbnailWidth,
      this.thumbnailHeight,
      this.extension,
      this.shortUrl,
      this.shortPath,
      this.retainHours,
      this.humanFilesize});

  Upload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    originalFilename = json['original_filename'];
    filesize = json['filesize'];
    width = json['width'];
    height = json['height'];
    thumbnailWidth = json['thumbnail_width'];
    thumbnailHeight = json['thumbnail_height'];
    extension = json['extension'];
    shortUrl = json['short_url'];
    shortPath = json['short_path'];
    retainHours = json['retain_hours'];
    humanFilesize = json['human_filesize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['original_filename'] = this.originalFilename;
    data['filesize'] = this.filesize;
    data['width'] = this.width;
    data['height'] = this.height;
    data['thumbnail_width'] = this.thumbnailWidth;
    data['thumbnail_height'] = this.thumbnailHeight;
    data['extension'] = this.extension;
    data['short_url'] = this.shortUrl;
    data['short_path'] = this.shortPath;
    data['retain_hours'] = this.retainHours;
    data['human_filesize'] = this.humanFilesize;
    return data;
  }
}

class DiscourseException implements Exception {
  String message;
  StackTrace stackTrace;

  DiscourseException([this.message]) {
    stackTrace = StackTrace.current;
  }

  @override
  String toString() {
    return 'DiscourseException: $message\n$stackTrace';
  }
}
