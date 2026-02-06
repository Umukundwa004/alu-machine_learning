import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './data_provider.dart';
import './screens/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => DataProvider())],
      child: MaterialApp(
        title: 'Student Academic Platform',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A2C5A)),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A2C5A),
            elevation: 0,
          ),
        ),
        home: const SignUpScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
