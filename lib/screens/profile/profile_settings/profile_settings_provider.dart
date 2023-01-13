import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:trophyapp/client/client.dart';
import 'package:trophyapp/model/countries.dart';
import 'package:trophyapp/model/user.dart' as usr;
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ProfileSettingsProvider with ChangeNotifier {
  File _image;
  String _username;
  String _country;
  String _state;
  String _city;
  bool _isLoading = false;

  setImage(File image) {
    _image = image;
    notifyListeners();
  }

  setUsername(String val) => _username = val;
  void setCountry(String val) {
    _country = val;
    notifyListeners();
  }

  setState(String val) => _state = val;
  setCity(String val) => _city = val;

  String get username => _username;
  String get country => _country;
  String get state => _state;
  String get city => _city;
  File get image => _image;
  bool get isLoading => _isLoading;

  Future<usr.User> getUser(String uId) async {
    var response =
        await FirebaseFirestore.instance.collection('users').doc(uId).get();
    return usr.User.fromFirebase(response.data());
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

  void saveChanges(usr.User user) async {
    _isLoading = true;
    notifyListeners();
    String userName = _username ?? user.name;
    String country = _country ?? user.country;
    String state = _state ?? user.state;
    String city = _city ?? user.city;
    String _avatarUrl = user.avatar;
    if (_image != null) {
      await FirebaseStorage.instance
          .ref()
          .child('/userAvatars/${basename(_image.path)}')
          .putFile(File(_image.path))
          .then((value) => value.ref.getDownloadURL().then((value) =>
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.id)
                  .update(usr.User(
                          name: userName,
                          country: country,
                          state: state,
                          city: city,
                          avatar: value,
                          id: user.id,
                          email: user.email)
                      .toFirebase())));
    } else {
      FirebaseFirestore.instance.collection('users').doc(user.id).update(
          usr.User(
                  name: userName,
                  country: country,
                  state: state,
                  city: city,
                  avatar: _avatarUrl,
                  id: user.id,
                  email: user.email)
              .toFirebase());
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> canChangePassword(String email) async {
    return !(await Client.instance.canUserSignInWithFacebook(email));
  }

  void setCountryName(newValue) {}
}
