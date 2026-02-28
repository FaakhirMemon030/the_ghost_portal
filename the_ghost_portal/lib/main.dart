import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/app_theme.dart';
import 'core/mood_provider.dart';
import 'features/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Note: Firebase will be initialized here once google-services.json is added
  // For now, we wrap in a try-catch to allow local development
  try {
    // await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoodProvider()),
      ],
      child: const GhostPortalApp(),
    ),
  );
}

class GhostPortalApp extends StatelessWidget {
  const GhostPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodProvider>(context);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Ghost Portal',
      theme: AppTheme.getDynamicTheme(moodProvider.moodColor),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeDashboard(),
      },
    );
  }
}
