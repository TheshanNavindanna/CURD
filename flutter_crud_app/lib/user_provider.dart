import 'package:flutter/foundation.dart';
import 'user.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  void addUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  void updateUser(int index, User user) {
    _users[index] = user;
    notifyListeners();
  }

  void deleteUser(int index) {
    _users.removeAt(index);
    notifyListeners();
  }
}
