


import 'package:shared_preferences/shared_preferences.dart';

class AuthService{



  //checking the login status
  // getting token from sharedprefernce
  Future<bool> chekLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ?token=await prefs.getString('user_token', );
  //just for demo purpose,if change to false you will get otp screen
    return true;
  }


}