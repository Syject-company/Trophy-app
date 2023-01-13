import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trophyapp/model/user.dart' as usr;

class FriendsListProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  bool _needSearch = false;
  bool get needSearch => _needSearch;

  /// для чего нужна эта переменная?
  List<usr.User> _friendsList = [];

  // List<usr.User> get friendsList => _friendsList;
  /// наверное, и этот геттер понадобиться?
  List<usr.User> _searchedFriends = [];

  List<usr.User> get searchedFriends => _searchedFriends;

  Future<List<usr.User>> getFriends(String userId) async {
    // return null;

    //DocumentSnapshot userResponse = await _firestore.collection('users').doc(userId).get();
    // usr.User friends = usr.User.fromFirebase(userResponse.data());
    // QuerySnapshot usersResponse = await _firestore.collection('users').get();
    // List<usr.User> userList = usersResponse.docs.map((e) => usr.User.fromFirebase(e.data())).toList();
    _friendsList.clear();

    DocumentSnapshot userResponse =
        await _firestore.collection('users').doc(userId).get();
    List<String> friends = usr.User.fromFirebase(userResponse.data()).friends;
    QuerySnapshot usersResponse = await _firestore.collection('users').get();
    List<usr.User> userList =
        usersResponse.docs.map((e) => usr.User.fromFirebase(e.data())).toList();
    friends.forEach((friendId) {
      userList.forEach((element) {
        if (element.id == friendId) _friendsList.add(element);
      });
    });

    return _friendsList;
  }

  List<usr.User> searchFriends(String friendName) {
    if (friendName != null && friendName.isNotEmpty) {
      _searchedFriends = _friendsList.where((friend) {
        return friend.name.toLowerCase().startsWith(friendName.toLowerCase());
      }).toList();
      _needSearch = true;
    } else {
      _searchedFriends.clear();
      _needSearch = false;
    }

    notifyListeners();
    return _searchedFriends;
  }
}
