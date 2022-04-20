import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iftarnezaman/providers/main_provider.dart';
import 'package:iftarnezaman/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iftar Ne Zaman',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primaryColor: const Color(0xAA758ECD),
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: const Color(0xAA758ECD),
              secondary: const Color(0xAA506fbf),
            ),
        brightness: Brightness.light,
        fontFamily: 'Poppins',
      ),
      darkTheme: ThemeData(
        primaryColor: const Color(0xAA758ECD),
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: const Color(0xAA758ECD),
              secondary: const Color(0xAA506fbf),
              brightness: Brightness.dark,
            ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 9, 52, 87),
        fontFamily: 'Poppins',
      ),
      home: ScreenUtilInit(designSize: const Size(428, 926), builder: () => const HomeScreen()),
    );
  }
}
