import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/security/encryption_service.dart';
import 'features/auth/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize encryption service
  EncryptionService().initialize();
  
  // TODO: Initialize Firebase
  // await Firebase.initializeApp();
  
  // TODO: Initialize Hive for local storage
  // await Hive.initFlutter();
  
  runApp(
    const ProviderScope(
      child: RiseVoiceApp(),
    ),
  );
}

class RiseVoiceApp extends StatelessWidget {
  const RiseVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RiseVoice',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
