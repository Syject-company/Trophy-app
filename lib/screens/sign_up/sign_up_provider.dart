import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:trophyapp/client/client.dart';
import 'package:trophyapp/helpers/validator.dart';
import 'package:trophyapp/model/countries.dart';

class SignUpProvider with ChangeNotifier {
  File _image;
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _username = '';
  String _countryName = '';
  String _state = '';
  String _city = '';

  String _emailError = '';
  String _passwordError = '';
  String _confirmPasswordError = '';
  String _usernameError = '';

  bool _passwordsEqual = false;
  bool _isLoading = false;
  bool _canContinue = false;
  bool _isCountryPicked = false;
  bool _emailValid = false;

  File get image => _image;

  bool get passwordsEqual => _passwordsEqual;
  bool get isLoading => _isLoading;
  bool get canContinue => _canContinue;

  String get emailError => _emailError;
  String get passwordError => _passwordError;
  String get confirmPasswordError => _confirmPasswordError;
  String get usernameError => _usernameError;

  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  String get username => _username;
  String get countryName => _countryName;
  String get state => _state;
  String get city => _city;

  set state(String val) {
    _state = val;
    notifyListeners();
  }

  set city(String val) {
    _city = val;
    notifyListeners();
  }

  setImage(File image) {
    _image = image;
    notifyListeners();
  }

  setEmail(String email) {
    _email = email;
    _emailValid = Validator.emailValidated(_email);
    if (_emailValid)
      _emailError = '';
    else
      _emailError = 'Invalid email';
    notifyListeners();
    _canContinue = _calculateCanContinue();
    notifyListeners();
  }

  setPassword(String password) {
    _password = password;
    if (password.length < 10)
      _passwordError = 'Password must be at least 10 characters';
    else
      _passwordError = '';

    _checkPasswords();
    _canContinue = _calculateCanContinue();
    notifyListeners();
  }

  setConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    _checkPasswords();
    _canContinue = _calculateCanContinue();
    notifyListeners();
  }

  _checkPasswords() {
    if (_password == _confirmPassword) {
      _passwordsEqual = true;
      _confirmPasswordError = '';
    } else {
      _passwordsEqual = false;
      _confirmPasswordError = 'Passwords must match';
    }
    notifyListeners();
  }

  setUsername(String username) {
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
    _canContinue = _calculateCanContinue();
    notifyListeners();
  }

  setCountryName(String countryName) {
    _countryName = countryName;
    _isCountryPicked = true;
    _canContinue = _calculateCanContinue();
    notifyListeners();
  }

  setStateName(String val) {
    _state = val;
    notifyListeners();
  }

  setCityName(String val) {
    _city = val;
    notifyListeners();
  }

  Future signUp() async {
    _isLoading = true;
    notifyListeners();
    var result;
    try {
      result = await Client.instance.signUpWithCredentials(
        _email,
        _password,
        _username,
        _countryName,
        _state,
        _city,
        _image.path,
      );
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return Future.error(e, StackTrace.current);
    }
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

  _calculateCanContinue() {
    return (_emailValid &&
        _password.length >= 10 &&
        _confirmPassword.length >= 10 &&
        _passwordsEqual &&
        _usernameError.isEmpty &&
        _isCountryPicked);
  }
}
