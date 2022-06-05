import 'package:flutter/foundation.dart';

class TaskData extends ChangeNotifier {
  bool _validateTaskName = false;
  bool _validateTaskDes = false;

  void changeValidateName(bool data) {
    _validateTaskName = data;
    notifyListeners();
  }

  void changeValidateDes(bool data) {
    _validateTaskDes = data;
    notifyListeners();
  }

  bool get validateTaskName => _validateTaskName;
  bool get validateTaskDes => _validateTaskDes;
}
