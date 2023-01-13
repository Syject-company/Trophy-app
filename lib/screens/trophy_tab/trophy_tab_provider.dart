import 'package:flutter/material.dart';
import 'package:trophyapp/model/trophy.dart';
import 'package:trophyapp/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum TrophyGridState { showsTrophies, showsUsers }

class TrophyTabProvider with ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  TrophyGridState _gridState = TrophyGridState.showsTrophies;
  String _searchBarValue = '';
  bool showAll = true;

  List<User> _searchUserList = [];
  List<Trophy> _searchTrophyList = [];
  List<User> _users;
  List<Trophy> _trophies;

  TrophyGridState get gridState => _gridState;

  List<User> get searchUserList => _searchUserList;

  List<Trophy> get searchTrophyList => _searchTrophyList;

  String get searchBarValue => _searchBarValue;

  List<User> get users => _users;

  List<Trophy> get trophies => _trophies;

  bool isSearching = false;
  bool isLoading = false;

  setModerState() {
    showAll = !showAll;
    notifyListeners();
  }

  setGridState(TrophyGridState newVal) {
    _gridState = newVal;
    notifyListeners();
  }

  setSearchbarValue(String newVal) {
    _searchBarValue = newVal;
    isSearching = _needStartSearch();
    notifyListeners();
  }

  bool _needStartSearch() {
    return _searchBarValue.isNotEmpty;
  }

  List<Trophy> searchTrophy(String val) {
    _searchTrophyList.clear();
    if (val.length >= 3) {
      isSearching = true;
      _trophies.forEach((element) {
        if (element.name.toLowerCase().startsWith(val.toLowerCase()))
          _searchTrophyList.add(element);
      });
    } else {
      isSearching = false;
    }
    notifyListeners();
    return _searchTrophyList;
  }

  List<User> searchUsers(String val) {
    _searchUserList.clear();
    if (val.length >= 3) {
      isSearching = true;
      _users.forEach((element) {
        if (element.name.toLowerCase().startsWith(val.toLowerCase()))
          _searchUserList.add(element);
      });
    } else {
      isSearching = false;
    }
    notifyListeners();
    return _searchUserList;
  }

  Future<List<Trophy>> getTrophy() async {
    var snapshot = await _fireStore.collection('trophy').get();
    _trophies =
        snapshot.docs.map((e) => Trophy.fromFirebase(e.data())).toList();
    return _trophies;
  }

//TODO: DONT WORKED MUST FIX
  Future<List<User>> getUsers(String uId) async {
    var snapshot = await _fireStore.collection('users').get();
    //_users = snapshot.docs.map((e) => e.get(User.fromFirebase(e.data()))).toList();
    _users = snapshot.docs.map((e) => User.fromFirebase(e.data())).toList();
    _users.removeWhere((element) => element.id == uId);
    return _users;
  }

  final List<User> mockedUsers = [
    User(
        name: "Chuk Norris",
        email: "qwerty@qwerty.qw",
        country: "World",
        achievements: [],
        avatar:
            'https://images02.military.com/sites/default/files/media/veteran-jobs/content-images/2016/03/chucknorris.jpg'),
    User(
        name: "Jamie",
        email: "qwerty@qwerty.qw",
        country: "USA",
        achievements: [],
        avatar:
            'https://pbs.twimg.com/profile_images/877872917995859971/0iN84zuy.jpg'),
    User(
        name: "Adam",
        email: "qwerty@qwerty.qw",
        country: "USA",
        achievements: [],
        avatar:
            'https://speaking.com/wp-content/uploads/2017/06/Adam-Savage.jpg'),
    User(
        name: "Ben",
        email: "qwerty@qwerty.qw",
        country: "United Kingdom",
        achievements: [],
        avatar:
            'https://www.atlassian.com/ru/dam/jcr:ba03a215-2f45-40f5-8540-b2015223c918/Max-R_Headshot%20(1).jpg'),
    User(
        name: "Michael",
        email: "qwerty@qwerty.qw",
        country: "Russia",
        achievements: [],
        avatar:
            'https://img.gazeta.ru/files3/843/12562843/9797-pic905-895x505-76253.jpg'),
    User(
        name: "David",
        email: "qwerty@qwerty.qw",
        country: "Bulgaria",
        achievements: [],
        avatar:
            'https://static.hdrezka.ac/i/2016/5/29/b0e741b17f060tx20f96d.jpg'),
    User(
        name: "Sergey",
        email: "svidetel@mail.ru",
        country: "Fryazino",
        achievements: [],
        avatar:
            'https://i.pinimg.com/280x280_RS/55/51/7d/55517d19f559ad7c8aa3730302152715.jpg'),
    User(
        name: "Leonardo",
        email: "qwerty@qwerty.qw",
        country: "Bulgaria",
        achievements: [],
        avatar:
            'https://s00.yaplakal.com/pics/pics_original/1/3/2/6919231.jpg'),
    User(
        name: "Jason",
        email: "qwerty@qwerty.qw",
        country: "Ukraine",
        achievements: [],
        avatar:
            'https://images11.cosmopolitan.ru/upload/img_cache/744/7445fb552e06ac7b1121a6b31303f85d_cropped_460x460.jpg')
  ];
}
