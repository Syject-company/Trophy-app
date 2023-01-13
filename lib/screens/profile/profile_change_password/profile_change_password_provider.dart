import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trophyapp/client/client.dart';

class ChangePasswordProvider with ChangeNotifier {
  String _newPassword;
  String _confirmPassword;
  String _currentPassword;
  bool canContinue = false;
  bool _validPassword = false;
  bool _validOldPassword = false;
  bool _isLoading = false;

  _validator() {
    if (_newPassword != null &&
        _confirmPassword != null &&
        _newPassword == _confirmPassword &&
        _validOldPassword) {
      canContinue = true;
      return true;
    } else
      canContinue = false;
  }

  get validOldPassword => _validOldPassword;
  get isLoading => _isLoading;
  get validPassword => _validPassword;

  setPassword(String val) {
    _currentPassword = val;
    if (_currentPassword.length >= 6)
      _validOldPassword = true;
    else
      _validOldPassword = false;

    _validator();

    notifyListeners();
  }

  submitPassword(String email) async {
    _isLoading = true;
    UserCredential response;
    notifyListeners();
    EmailAuthCredential credential =
        EmailAuthProvider.credential(email: email, password: _currentPassword);
    try {
      response = await FirebaseAuth.instance.currentUser
          .reauthenticateWithCredential(credential);
      if (response != null) {
        Client.changePassword(_newPassword);
      }
      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  newPassword(String val) {
    _newPassword = val;
    print(_newPassword);
    if (val.length >= 6)
      _validPassword = true;
    else
      _validPassword = false;
    _validator();
    notifyListeners();
  }

  confirmPassword(String val) {
    _confirmPassword = val;
    _validator();
    notifyListeners();
  }
}
