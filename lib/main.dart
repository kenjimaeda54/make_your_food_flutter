import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:make_your_travel/utils/constants_environment.dart';
import 'package:make_your_travel/screens/home/home.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env[environmentApiKey];
  Gemini.init(apiKey: apiKey!);
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: "Ubuntu",
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(0, 19, 19, 19),
            primary: const Color(0xFFEEEEEE),
            secondary: const Color(0xff0C0C0C),
          )),
      home: HomeScreen(),
    );
  }
}
