import 'package:dineapple/features/auth/view/auth_view.dart';
import 'package:dineapple/features/filter/services/api_service.dart';
import 'package:dineapple/features/filter/services/search_service_provider.dart';
import 'package:dineapple/features/filter/view/search_list_view.dart';
import 'package:dineapple/features/filter/view/test_page.dart';
import 'package:dineapple/features/home/view/home_view.dart';
import 'package:dineapple/features/splash/splash_view.dart';
import 'package:dineapple/state/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/location/location_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemeMode();
  runApp(MyApp(themeProvider));
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  MyApp(this.themeProvider);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => themeProvider), // Use the same themeProvider instance
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context) => APIService()),
        ChangeNotifierProvider(create: (context) => FilterProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            themeMode: themeProvider.themeMode, // Use the themeProvider's themeMode
            initialRoute: '/',

            routes: {

              '/':(context)=>SplashPage(),
              '/home':(context)=>HomePage(),
              '/auth':(context)=>AuthView(),
              '/filter':(context)=>SearchPage(),
              '/test':(context)=>TestPage()
            },
          );
        },
      ),
    );
  }
}


