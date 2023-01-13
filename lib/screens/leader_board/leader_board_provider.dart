import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trophyapp/model/countries.dart';
import 'package:trophyapp/model/user.dart';
import 'package:http/http.dart' as http;

class LeaderBoardProvider with ChangeNotifier {
  int _tabIndex = 0;
  int _miles = 0;

  bool _showVerify = false;
  bool _canContinue = false;

  String _state = '';
  String _city = '';

  int get tabIndex => _tabIndex;
  int get miles => _miles;

  bool get showVerify => _showVerify;
  bool get canContinue => _canContinue;

  String get state => _state;
  String get city => _city;

  void changeTab(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  void checkBox() {
    _showVerify = !showVerify;
    notifyListeners();
  }

  void setMiles(int val) {
    if (val == _miles) {
      _canContinue = false;
      _miles = 0;
    } else {
      _canContinue = true;
      _miles = val;
    }
    notifyListeners();
  }

  void setState(String val) {
    _state = val;
    if (val.length == 0)
      _canContinue = false;
    else
      _canContinue = true;
    notifyListeners();
  }

  void setCity(String val) {
    _city = val;
    if (val.length == 0)
      _canContinue = false;
    else
      _canContinue = true;
    notifyListeners();
  }

  Future<CountryList> getCountries() async {
    CountryList data;
    final uri = Uri.parse('https://api.printful.com/countries');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      data = CountryList.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'getCountries error: ${response.statusCode} - ${response.reasonPhrase}');
    }
    return data;
  }

  final List<User> mockedUsers = [
    User(
        name: "Jamie",
        email: "qwerty@qwerty.qw",
        country: "USA",
        avatar:
            'https://pbs.twimg.com/profile_images/877872917995859971/0iN84zuy.jpg',
        point: 1337),
    User(
        name: "Adam",
        email: "qwerty@qwerty.qw",
        country: "USA",
        avatar:
            'https://speaking.com/wp-content/uploads/2017/06/Adam-Savage.jpg',
        point: 228),
    User(
        name: "Ben",
        email: "qwerty@qwerty.qw",
        country: "United Kingdom",
        avatar:
            'https://www.atlassian.com/ru/dam/jcr:ba03a215-2f45-40f5-8540-b2015223c918/Max-R_Headshot%20(1).jpg',
        point: 256),
    User(
        name: "Michael",
        email: "qwerty@qwerty.qw",
        country: "Russia",
        avatar:
            'https://img.gazeta.ru/files3/843/12562843/9797-pic905-895x505-76253.jpg',
        point: 186),
    User(
        name: "David",
        email: "qwerty@qwerty.qw",
        country: "Bulgaria",
        avatar:
            'https://static.hdrezka.ac/i/2016/5/29/b0e741b17f060tx20f96d.jpg',
        point: 546),
    User(
        name: "Sergey",
        email: "svidetel@mail.ru",
        country: "Fryazino",
        avatar:
            'https://i.pinimg.com/280x280_RS/55/51/7d/55517d19f559ad7c8aa3730302152715.jpg',
        point: 569),
    User(
        name: "Leonardo",
        email: "qwerty@qwerty.qw",
        country: "Bulgaria",
        avatar: 'https://s00.yaplakal.com/pics/pics_original/1/3/2/6919231.jpg',
        point: 579),
    User(
        name: "Jason",
        email: "qwerty@qwerty.qw",
        country: "Ukraine",
        avatar:
            'https://images11.cosmopolitan.ru/upload/img_cache/744/7445fb552e06ac7b1121a6b31303f85d_cropped_460x460.jpg',
        point: 925),
    User(
        name: "Chuk Norris",
        email: "qwerty@qwerty.qw",
        country: "Ukraine",
        avatar:
            'https://images02.military.com/sites/default/files/media/veteran-jobs/content-images/2016/03/chucknorris.jpg',
        point: 9999)
  ];

  List<User> usersForShow = [];

  LeaderBoardProvider() {
    usersForShow = mockedUsers.map((e) => e).toList();
    sortedUsers();
  }

  sortedUsers() {
    if (_showVerify) {
      usersForShow.removeWhere((element) => element.isVerified == true);
      usersForShow.sort((a, b) => b.point.compareTo(a.point));
      notifyListeners();
    } else {
      usersForShow = mockedUsers.map((e) => e).toList();
      usersForShow.sort((a, b) => b.point.compareTo(a.point));
      notifyListeners();
    }
  }
}
