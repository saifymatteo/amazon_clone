import 'package:amazon_clone/models/user.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  // Initialize empty [User]
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
    address: '',
    type: '',
    token: '',
  );

  // Getter method to get the [User]
  User get user => _user;

  // Set new [user] with Json as String
  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }
}
