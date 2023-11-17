
import 'package:dineapple/features/auth/service/auth_service.dart';
import 'package:flutter/material.dart';

import '../auth/view/auth_view.dart';
import '../home/view/home_view.dart';



class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().chekLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.data == true) {
          // User is logged in, navigate to the task list page
          return HomePage();
        } else {
          // User is not logged in, navigate to the login page
          return AuthView();
        }
      },
    );
  }


}
