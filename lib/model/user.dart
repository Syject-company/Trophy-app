import 'package:trophyapp/model/achivement.dart';
import 'package:trophyapp/model/level.dart';
import 'package:trophyapp/model/trophy.dart';

class User {
  static const friendsKey = 'friends';

  User({
    this.id,
    this.discourseId,
    this.isVerified,
    this.type,
    this.email,
    this.name,
    this.country,
    this.state,
    this.city,
    this.avatar,
    this.point,
    this.friends,
    this.achievements,
    this.trakedTrophies,
  }) : this.level = _setLevel(point);

  factory User.fromFirebase(Map<String, dynamic> data) {
    var friendsJson = data['friends'] as List;
    List<String> friendsList;
    if (friendsJson != null) {
      friendsList = friendsJson.cast<String>();
    } else {
      friendsList = [];
    }

    var achievementsJson = data['achievements'] as List;
    List<Achievement> achievements;
    if (achievementsJson != null) {
      achievements = achievementsJson.map((json) {
        return Achievement.fromFirebase(json);
      }).toList();
    } else {
      achievements = [];
    }

    return User(
      id: data['id'] as String,
      discourseId: data['discourseId'] as int,
      isVerified: data['isVerified'] as bool,
      avatar: data['avatar'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
      country: data['country'] as String,
      state: data['state'] as String,
      city: data['city'] as String,
      point: data['point'] as int,
      type: data['type'] as int, //UserType
      friends: friendsList,
      achievements: achievements,
    );
  }

  String id;
  int discourseId;
  final bool isVerified;
  final int type; //UserType
  final String email;
  final String name;
  final String country;
  final String state;
  final String city;
  final String avatar;
  final int point;
  final Level level; //setup in constructor
  //final List<User> friends; // Referense to users
  final List<String> friends;
  final List<Achievement> achievements; // Referense to achievements
  final List<Trophy> trakedTrophies; // Referense to trophies

  Map<String, dynamic> toFirebase() => {
        'id': this.id,
        'discourseId': this.discourseId,
        'isVerified': this.isVerified,
        'type': this.type,
        'email': this.email,
        'name': this.name,
        'country': this.country,
        'state': this.state,
        'city': this.city,
        'avatar': this.avatar ??
            'https://firebasestorage.googleapis.com/v0/b/irla-app.appspot.com/o/account_photo_placeholder.png?alt=media',
        'point': this.point ?? 1,
        'friends': this.friends ?? [],
        'achievements': this
            .achievements
            .map<Map<String, dynamic>>(
                (achievement) => achievement.toFirebase())
            .toList(),
        'trakedTrophies': this.trakedTrophies,
      };
}

// TODO: fix this shit
Level _setLevel(int point) {
  // WTF?????
  return Level(id: 1, name: 'Piratik', point: 3800);
}
