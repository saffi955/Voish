import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
// import 'screens/splash_screen.dart'; // Will implement next
// import 'screens/onboarding_screen.dart'; // Will implement next
// import 'screens/auth_screen.dart'; // Will implement next
// import 'screens/home_screen.dart'; // Will implement next

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase init failed: $e");
  }
  runApp(const ProviderScope(child: VoishApp()));
}

class VoishApp extends StatelessWidget {
  const VoishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voish',
      theme: AppTheme.darkTheme,
      supportedLocales: const [
        Locale('ur'), // Urdu (Default)
        Locale('en'), // English
        Locale('ar'), // Arabic
        Locale('hi'), // Hindi
        Locale('ko'), // Korean
        Locale('ru'), // Russian
        Locale('ja'), // Japanese
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Simple logic to default to English if locale not supported,
        // or handle RTL languages specifically if needed.
        // For now, let's stick to system default or fallback to English.
        if (locale != null) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }
        return supportedLocales.first;
      },
      home: const SplashScreen(),
    );
  }
}
