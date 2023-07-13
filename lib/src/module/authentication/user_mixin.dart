class UserDetail {
  static String? _loggedInUser;

  static String? get loggedInUser => _loggedInUser;

  static void setLoggedInUser(String? user) {
    _loggedInUser = user;
  }
}