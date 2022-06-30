import 'package:flutter/foundation.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  model.User? _user;
  final AuthMethods authMethods = AuthMethods();

  model.User get getUser => _user!;

  Future<void> refreshUser() async {
    model.User user = await authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
  
}
