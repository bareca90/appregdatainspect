import 'package:appregdatainspect/core/constants/app_routes.dart';
import 'package:appregdatainspect/core/providers/auth_provider.dart';
import 'package:appregdatainspect/core/providers/connectivity_provider.dart';
import 'package:appregdatainspect/core/providers/theme_provider.dart';
import 'package:appregdatainspect/core/services/api_service.dart';
import 'package:appregdatainspect/core/services/shared_prefs_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService.init();
  // Inicializa servicios
  final apiService = ApiService();
  final localDbService = LocalDbService();
  /* await localDbService.database; */

  // Inicializa providers
  final authProvider = AuthProvider();
  await authProvider.loadToken();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class LocalDbService {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Kilos Remitidos App',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
