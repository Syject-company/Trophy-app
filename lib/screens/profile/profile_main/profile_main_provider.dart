import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trophyapp/model/achivement.dart';
import 'package:trophyapp/model/level.dart';
import 'package:trophyapp/model/ref_trophy_category.dart';
import 'package:trophyapp/model/trophy.dart';
import 'package:trophyapp/model/user.dart' as usr;

class ProfileMainProvider with ChangeNotifier {
  bool _isFollowing = true;
  bool _isVerified = true;
  bool _statScreen = false;
  bool _isTracked = false;
  String levelName = '';
  int levelvalue = 0;
  int pointsToNextLevel = 0;

  bool get isFollowing => _isFollowing;
  bool get isVerified => _isVerified;
  bool get statScreen => _statScreen;
  bool get isTracked => _isTracked;

  Future<usr.User> getUser(String uId) async {
    final response =
        await FirebaseFirestore.instance.collection('users').doc(uId).get();
    if (!response.exists) {
      throw Exception('User with Id $uId does not exists in FireStore'
          ' but exists in FirebaseAuth. Please contact the developers and tell '
          'them this id: $uId and email: '
          '${FirebaseAuth.instance.currentUser.email} that was used for '
          'registration. Developers will delete acount data from everywhere '
          'and you will be able to register again.');
    }
    var user = usr.User.fromFirebase(response.data());

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("level").get();
    List<Level> levels = querySnapshot.docs
        .map((doc) => Level.fromFirebase(doc.data()))
        .toList();
    levels.sort((level1, level2) => level1.point.compareTo(level2.point));

    if (user.point >= levels.last.point) {
      levelName = levels.last.name;
      levelvalue = levels.last.id;
      pointsToNextLevel = levels.last.point;
    } else {
      for (var i = 0; i < levels.length - 1; i++) {
        final currentLevel = levels[i];
        final nextLevel = levels[i + 1];

        if (currentLevel.point <= user.point && nextLevel.point > user.point) {
          levelName = currentLevel.name;
          levelvalue = currentLevel.id;
          pointsToNextLevel = nextLevel.point;
        }
      }
    }

    if (!response.exists) {
      throw Exception('User with Id $uId does not exists');
    }

    return user;
  }

  static Future<List<TrophyCategory>> getCategories() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('trophy_category').get();
    List<TrophyCategory> categories = querySnapshot.docs
        .map((doc) => TrophyCategory.fromFirebase(doc.data()))
        .toList();

    return categories;
  }

  Future<List<Trophy>> getTrophies(List<usr.User> userTrophy) async {
    List<Trophy> result = [];
    final response =
        await FirebaseFirestore.instance.collection('trophies').get();
    var data = response.docs.map((e) => Trophy.fromFirebase(e.data())).toList();
    data.forEach((trophies) {
      userTrophy.forEach((element) {
        //TODO: MUST CHECKED THIS TOSTRING()
        if (trophies.id.toString() == element.id) result.add(trophies);
      });
    });
    return result;
  }

  Future<List<Achievement>> getAchivments(String uId) async {
    List<Achievement> result = [];
    final response = await FirebaseFirestore.instance
        .collection('achievement')
        .where('userId', isEqualTo: uId)
        .get();
    result =
        response.docs.map((a) => Achievement.fromFirebase(a.data())).toList();
    return result;
  }

  // final List<Trophy> mockedTrophies = [
  //   TrophyOld(
  //       name: "Trophy 0",
  //       points: 1234,
  //       imageURLs: ['', ''],
  //       imageURL: 'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',
  //       trophyType: TrophyType.verified),
  //   TrophyOld(
  //       name: "Trophy 1",
  //       points: 1234,
  //       imageURLs: ['', ''],
  //       imageURL: 'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',
  //       trophyType: TrophyType.unverified),
  //   TrophyOld(
  //       name: "Trophy 2",
  //       points: 1234,
  //       imageURLs: ['', ''],
  //       imageURL: 'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',
  //       trophyType: TrophyType.unverified),
  //   TrophyOld(
  //       name: "Trophy 3",
  //       points: 1234,
  //       imageURLs: ['', ''],
  //       imageURL: 'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',
  //       trophyType: TrophyType.verified),
  //   TrophyOld(
  //       name: "Trophy 4",
  //       points: 1234,
  //       imageURLs: ['', ''],
  //       imageURL: 'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',
  //       trophyType: TrophyType.verified),
  //   TrophyOld(
  //       name: "Trophy 5",
  //       points: 1234,
  //       imageURLs: ['', ''],
  //       imageURL: 'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',
  //       trophyType: TrophyType.unverified),
  //   TrophyOld(
  //       name: "Trophy 6",
  //       points: 1234,
  //       imageURLs: ['', ''],
  //       imageURL: 'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',
  //       trophyType: TrophyType.verified),
  // ];

  // TODO: remove this shit after implementation
  final Map<String, double> data = {
    'Trophy 1': 24.0,
    'Trophy 2': 60.0,
    'Trophy 3': 16.0
  };

  int options = 0;

  chartOption(int val) {
    options = val;
    notifyListeners();
  }

  trackButton() {
    _isTracked = !_isTracked;
    notifyListeners();
  }

  verifyButton() {
    _isVerified = !_isVerified;
    notifyListeners();
  }

  followButton() {
    _isFollowing = !_isFollowing;
    notifyListeners();
  }

  changeScreen() {
    _statScreen = !_statScreen;
    notifyListeners();
  }
}
