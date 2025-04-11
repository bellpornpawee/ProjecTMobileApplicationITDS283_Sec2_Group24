import 'package:flutter/material.dart';
import 'package:project_mobile/homepage.dart';
import 'upload.dart';
import 'detail_page.dart';
import 'homepage.dart';
import 'login_page.dart';
import 'showdata.dart';
import 'splash_screen.dart';
import 'signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Routing Demo',
      initialRoute: '/',
      routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const RegisterPage(),
          '/showdata': (context) => const ShowDataPage(),
          '/homepage': (context) => const Homepage(),
          
        // '/upload': (context) => const UploadPage(),
        // '/': (context) =>  Homepage()
        // '/detail': (context) => const DetailPage(),
        // '/': (context) =>  UploadPage(),
        // We'll handle DetailPage navigation differently
      },
    );
  }
}