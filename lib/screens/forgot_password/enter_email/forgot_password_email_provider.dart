import 'package:flutter/material.dart';
import 'package:trophyapp/client/client.dart';
import 'package:trophyapp/helpers/validator.dart';

class ForgotPasswordEmailProvider with ChangeNotifier {
  String _email = '';
  String _emailError = '';

  bool _isLoading = false;
  bool _canContinue = false;

  bool get isLoading => _isLoading;
  bool get canContinue => _canContinue;

  String get email => _email;
  String get emailError => _emailError;

  setEmail(String newVal) {
    _email = newVal;
    if (Validator.emailValidated(_email))
      _emailError = '';
    else
      _emailError = 'Invalid email';
    _canContinue = Validator.emailValidated(_email);
    notifyListeners();
  }

  restorePassword() {
    _isLoading = true;
    notifyListeners();
    var val = Client.instance.resetPassword(_email);
    _isLoading = false;
    notifyListeners();
    return val;
  }
}
