import 'package:mallshop/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'connected_models.dart';

class AuthModel extends ConnectedModels {
  bool hasError = true;
  bool isDone = false;
  Future<dynamic> Login(String email, String password) async {
    String errorMessage;
    try {
      isLoading = true;
      FirebaseUser user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;
      var token = await user.getIdToken();

      var id = user.uid;
      if (token != null) {
        hasError = false;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token.token);
      prefs.setString('email', email);
      prefs.setString('user_id', id);
      prefs.setString('password', password);
      password=password;
      isLoading = false;
      notifyListeners();
    } catch (error) {
      hasError = true;
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Invalid Email or Password.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "Invalid Email or Password.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }
    return {'success': !hasError, 'message': errorMessage};
  }

  Future autoAuthenticate() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String token = pref.getString('token');
    final String user_id = pref.getString('user_id');
    if (token != null) {
      authenticatedUser = User(token: token, Id: user_id);
      notifyListeners();
      return authenticatedUser;
    }
  }

  void logout() async {
    isLoading = false;
    authenticatedUser = null;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('token');
    pref.remove('email');
    pref.remove('user_id');
  }
}
