import 'package:dineapple/features/auth/widget/otp_page.dart';
import 'package:flutter/material.dart';


class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size; //fetching the viewport height  and width
    return Scaffold(

      body: Container(
        height: size.height,
        width: size.width,

        child: OTPScreen()
      ),

    );
  }
}
