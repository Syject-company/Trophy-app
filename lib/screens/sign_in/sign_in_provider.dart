import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trophyapp/helpers/validator.dart';

class SignInProvider with ChangeNotifier {
  String _email = '';
  String _password = '';
  String _passwordError = '';
  String _emailError = '';

  bool _canContinue = false;
  bool _isLoading = false;

  String get email => _email;
  String get password => _password;
  String get passwordError => _passwordError;
  String get emailError => _emailError;

  bool get canContinue => _canContinue;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _email = await getEmailIfStored();
    if (Validator.emailValidated(_email))
      _emailError = '';
    else
      _emailError = 'Invalid email';

    _password = await getPasswordIfStored();
    if (_password.length < 6) {
      _passwordError = 'Password must be at least 6 characters';
      notifyListeners();
    } else {
      _passwordError = '';
    }
    _canContinue = Validator.emailValidated(_email) && _validatePassword();
    notifyListeners();
  }

  setEmail(String newVal) {
    _email = newVal;
    if (Validator.emailValidated(_email))
      _emailError = '';
    else
      _emailError = 'Invalid email';
    _canContinue = Validator.emailValidated(_email) && _validatePassword();
    notifyListeners();
  }

  setPassword(String newVal) {
    _password = newVal;
    if (_password.length < 6) {
      _passwordError = 'Password must be at least 6 characters';
      notifyListeners();
    } else {
      _passwordError = '';
    }
    _canContinue = Validator.emailValidated(_email) && _validatePassword();
    notifyListeners();
  }

  bool _validatePassword() {
    if (_password.length >= 6) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> signInTapped() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 1), () {
      _isLoading = false;
      notifyListeners();
    });
  }

  getEmailIfStored() async {
    final storage = new FlutterSecureStorage();
    try {
      if (await storage.containsKey(key: 'login')) {
        return await storage.read(key: 'login');
      }
    } catch (error) {
      print('DEBUG: $error : ${StackTrace.current}');
    }
    return '';
  }

  getPasswordIfStored() async {
    final storage = new FlutterSecureStorage();
    try {
      if (await storage.containsKey(key: 'password')) {
        return await storage.read(key: 'password');
      }
    } catch (error) {
      print('DEBUG: $error : ${StackTrace.current}');
    }
    return '';
  }
}
