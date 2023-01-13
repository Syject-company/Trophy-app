import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trophyapp/model/user.dart' as usr;

class UserProfileProvider with ChangeNotifier {
  bool _isFollowing = false;
  bool _isVerified = false;
  bool _statScreen = false;
  int options = 0;
  usr.User _friendsList;

  bool get isFollowing => _isFollowing;
  bool get isVerified => _isVerified;
  bool get statScreen => _statScreen;

  usr.User _userProfile;

  Future<usr.User> getCurrentUser(String uId) async {
    usr.User user;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) => user = usr.User.fromFirebase(value.data()));
    return user;
  }

  Future<void> getProfileData(String uId) async {
    _userProfile = await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) => usr.User.fromFirebase(value.data()));
    print(_userProfile.email);
    if (_userProfile.isVerified == true) _isVerified = true;
    notifyListeners();
  }

  Future<void> checkFriend(String uId, String friendId) async {
    _friendsList = await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) => usr.User.fromFirebase(value.data()));
    for (int i = 0; i < _friendsList.friends.length; i++) {
      if (_friendsList.friends[i].toString() == friendId) {
        _isFollowing = true;
        break;
      } else {
        _isFollowing = false;
      }
    }
    notifyListeners();
  }

  Future<void> followButton(String uId, String friendId) async {
    if (!_isFollowing) {
      _friendsList.friends.add(friendId);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .set(_friendsList.toFirebase());
      _isFollowing = true;
    } else {
      _friendsList.friends.removeWhere((element) => element == friendId);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .set(_friendsList.toFirebase());
      _isFollowing = false;
    }
    notifyListeners();
  }

  Future<void> verifyButton(usr.User user) async {
    if (user.isVerified == true) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .update({'isVerified': false});
      _isVerified = false;
      notifyListeners();
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .update({'isVerified': true});
      _isVerified = true;
      notifyListeners();
    }
  }

  changeScreen() {
    _statScreen = !_statScreen;
    notifyListeners();
  }

  // TODO: Replace with backend
  chartOption(int val) {
    options = val;
    notifyListeners();
  }

  // final List<TrophyOld> mockedTrophies = [
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

  final Map<String, double> data = {
    'Category 1': 24.0,
    'Category 2': 30.0,
    'Category 3': 15.0,
    'Category 4': 16.0,
    'Category 5': 15.0
  };
}
