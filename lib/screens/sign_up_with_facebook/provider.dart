import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:trophyapp/client/client.dart';
import 'package:trophyapp/helpers/validator.dart';
import 'package:http/http.dart' as http;

class SignUpWithFacebookProvider with ChangeNotifier {
  String _imageUrl = '';
  String _imageLocalPath = '';
  String _email = '';
  String _emailError = '';
  String _discoursePassword = '';
  String _discoursePasswordError = '';
  String _confirmDiscoursePassword = '';
  String _confirmDiscoursePasswordError = '';
  String _username = '';
  String _usernameError = '';
  String _countryName = '';
  String _state = '';
  String _city = '';
  bool _isCountryPicked = false;
  bool _isLoading = false;
  bool _isImagePicked = false;

  String get imageUrl => _imageUrl;
  String get imageLocalPath => _imageLocalPath;
  String get email => _email;
  String get emailError => _emailError;
  String get discoursePasswordError => _discoursePasswordError;
  String get confirmDiscoursePasswordError => _confirmDiscoursePasswordError;
  String get username => _username;
  String get usernameError => _usernameError;
  String get countryName => _countryName;
  String get state => _state;
  String get city => _city;
  bool get isLoading => _isLoading;

  Future<void> setImageFile(File image) async {
    final ref = FirebaseStorage.instance.ref();
    final imageBasename = basename(image.path);
    final child = ref.child('/userAvatars/$imageBasename');
    final task = await child.putFile(image);
    _imageUrl = await task.ref.getDownloadURL();
    _imageLocalPath = image.path;
    _isImagePicked = true;
    notifyListeners();
  }

  set email(String email) {
    _email = email;
    if (Validator.emailValidated(_email)) {
      _emailError = '';
    } else {
      _emailError = 'Invalid email';
    }

    notifyListeners();
  }

  set discoursePassword(String password) {
    _discoursePassword = password;
    if (_isDiscoursePasswordValid()) {
      _discoursePasswordError = '';
    } else {
      _discoursePasswordError = 'Password must be at least 10 characters';
    }
    if (_isConfirmDiscoursePasswordValid()) {
      _confirmDiscoursePasswordError = '';
    } else {
      _confirmDiscoursePasswordError = 'Passwords must match';
    }

    notifyListeners();
  }

  set confirmDiscoursePassword(String confirmPassword) {
    _confirmDiscoursePassword = confirmPassword;
    if (_isConfirmDiscoursePasswordValid()) {
      _confirmDiscoursePasswordError = '';
    } else {
      _confirmDiscoursePasswordError = 'Passwords must match';
    }
    notifyListeners();
  }

  set username(String username) {
    _username = username;
    final pattern = r"^[0-9A-Za-z-._]*$";
    if (_username.length < 3) {
      _usernameError = 'Username must be at least 3 charaters';
    } else if (!RegExp(pattern).hasMatch(_username)) {
      _usernameError =
          'Username must only include ASCII numbers, letters, dashes, dots, and underscores';
    } else {
      _usernameError = '';
    }
    notifyListeners();
  }

  set countryName(String name) {
    _countryName = name;
    _isCountryPicked = true;
    notifyListeners();
  }

  set state(String name) {
    _state = name;
    notifyListeners();
  }

  set city(String name) {
    _city = name;
    notifyListeners();
  }

  bool canContinue() {
    return Validator.emailValidated(_email) &&
        _isDiscoursePasswordValid() &&
        _isConfirmDiscoursePasswordValid() &&
        _usernameError.isEmpty &&
        _isImagePicked &&
        _isCountryPicked;
  }

  Future<void> signUpWithFacebook() async {
    try {
      _isLoading = true;
      notifyListeners();
      await Client.instance.signUpWithFacebook(
        _email,
        _username,
        _discoursePassword,
        _countryName,
        _state,
        _city,
        _imageUrl,
        _imageLocalPath,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return Future.error('When sign up with facebook: $e', StackTrace.current);
    }
  }

  Future<void> initDataFromFacebook() {
    notifyListeners();
    return Client.instance.getFacebookUser().then((user) async {
      try {
        if (user.avatar != null) {
          _imageUrl = user.avatar;
          _imageLocalPath = (await _downloadAvatar(user.avatar)).path;
          _isImagePicked = true;
        }
        if (user.email != null) {
          _email = user.email;
          if (Validator.emailValidated(_email)) {
            _emailError = '';
          } else {
            _emailError = 'Invalid email';
          }
        }
        if (user.name != null) {
          username = user.name;
        }
        if (user.country != null) {
          if (_countryName.isNotEmpty) {
            _countryName = user.country;
          }
        }
        if (user.state != null) {
          _state = user.state;
        }
        if (user.city != null) {
          _city = user.city;
        }
        notifyListeners();
      } catch (e) {
        //_imageUrl = '';
        _email = '';
        _username = '';
        _countryName = '';
        _state = '';
        _city = '';
        return Future.error('When login facebook: $e', StackTrace.current);
      }
    });
  }

  bool _isDiscoursePasswordValid() {
    return _discoursePassword.length >= 10;
  }

  bool _isConfirmDiscoursePasswordValid() {
    return _confirmDiscoursePassword == _discoursePassword;
  }

  Future<File> _downloadAvatar(String url) async {
    final response = await http.get(Uri.parse(url));

    final tempDir = await Directory.systemTemp.createTemp();
    final image = File(join(tempDir.path, basename(url)));
    await image.writeAsBytes(response.bodyBytes);

    return image;
  }
}
