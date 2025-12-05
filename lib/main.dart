// In lib/main.dart
import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boy Flow',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,  // Changed from LoginVerificationScreen to login
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}