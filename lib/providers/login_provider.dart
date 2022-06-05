import 'package:flutter/foundation.dart';

class LoginData extends ChangeNotifier {
  bool _validateEmail = false;
  bool _validatePassword = false;

  void changeValidateEmail(bool data) {
    _validateEmail = data;
    notifyListeners();
  }

  void changeValidatePassword(bool data) {
    _validatePassword = data;
    notifyListeners();
  }

  bool get validateEmail => _validateEmail;
  bool get validatePassword => _validatePassword;
}
