/* import 'package:appkilosremitidos/screens/material_pesca/material_pesca_detail_screen.dart'; */
import 'package:appregdatainspect/screens/auth/login_screen.dart';
import 'package:appregdatainspect/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';

  static final routes = {
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        return null;
    }
  }
}
