import 'package:flutter/cupertino.dart';

class NotificationPd extends ChangeNotifier {

  late List<bool> notificationRead;
  late List<int> notificationIds;
  bool isSelecting = false;

  reload() => notifyListeners();

  NotificationPd(){
    notificationIds = [];
    notificationRead = List<bool>.filled(15, false);
  }
}
