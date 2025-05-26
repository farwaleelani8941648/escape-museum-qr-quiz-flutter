import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importing Providers
import 'provider/player_provider.dart';
import 'provider/quiz_provider.dart';

// Importing Screens
import 'screen/home_screen.dart';
import 'screen/scan_screen.dart';
import 'screen/welcome_screen.dart';
import 'screen/quiz_screen.dart';
import 'screen/result_screen.dart' as result;

void main() {
  runApp(const FinalQrCodeQuizApp());
}

/// Main App Widget
class FinalQrCodeQuizApp extends StatelessWidget {
  const FinalQrCodeQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Providing Player and Quiz state management across the app
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Removes the debug banner
        title: 'Escape Game Quiz',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.light,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black87),
            titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.indigo,
              textStyle: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        initialRoute: '/', // Sets the initial screen of the app
        routes: {
          // Define app routes for navigation
          '/': (context) => const HomeScreen(),
          '/scan': (context) => const ScanScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/quiz': (context) => const QuizScreen(),
          '/result': (context) => const result.ResultScreen(),
        },
      ),
    );
  }
}

