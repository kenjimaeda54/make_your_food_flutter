import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:make_your_travel/old_chat/utils/constants_environment.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:make_your_travel/screens/splash_screen/splash_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env[environmentApiKey];
  Gemini.init(apiKey: apiKey!);
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;
  MainApp({super.key});

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
              secondary: const Color(0xFF1D120E),
              tertiary: const Color(0xFFFFD40A),
              onBackground: const Color(0xFF150B0A))),
      onGenerateRoute: (_) => SplashScreen.route(),
    );
  }
}
