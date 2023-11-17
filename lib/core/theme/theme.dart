import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(


  primarySwatch: Colors.blue, // Define your light theme colors
  brightness: Brightness.light,
  fontFamily: 'Roboto',
  textTheme: TextTheme(
    titleLarge: TextStyle(color: Colors.black,fontSize: 42)
  )
  // Add other light theme configurations here
);

final ThemeData darkTheme = ThemeData(
  textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.white)
  ),
  primarySwatch: Colors.pink, // Define your dark theme colors
  brightness: Brightness.dark,
  primaryColor: Colors.white70,
  fontFamily: 'Roboto',
  // Add other dark theme configurations here
);
