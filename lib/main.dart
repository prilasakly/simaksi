import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar (biar sesuai theme)
  AppTheme.setSystemUI();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SIMAKSI',

      // ✅ pakai theme kamu
      theme: AppTheme.lightTheme,

      // ✅ pakai GoRouter
      routerConfig: appRouter,

      debugShowCheckedModeBanner: false,
    );
  }
}
