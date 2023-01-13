class Validator {
  static bool emailValidated(String email) {
    if (email == null) return false;
    final _pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    return RegExp(_pattern).hasMatch(email);
  }
}
