import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color portalPurple = Color(0xFF6A0DAD);
  static const Color neonYellow = Color(0xFFCCFF00);
  static const Color ghostWhite = Color(0xFFF8F8FF);
  static const Color deepBlack = Color(0xFF0F0F0F);
  
  // Mood Colors
  static const Color moodAngry = Color(0xFF003366); // Deep Blue
  static const Color moodSad = Color(0xFFFFD700);   // Bright Yellow
  static const Color moodExcited = Color(0xFF32CD32); // Soft Green
  static const Color moodNeutral = portalPurple;

  // Glassmorphism
  static Color glassBackground = Colors.white.withOpacity(0.1);
  static Color glassBorder = Colors.white.withOpacity(0.2);
}

class AppConstants {
  static const String appTitle = 'The Ghost Portal';
  static const String slogan = 'Communication Beyond the Grid';
  
  // OWC & Sonic Settings
  static const double minSonicFrequency = 18000.0;
  static const double maxSonicFrequency = 22000.0;
  static const int defaultSonicFreq = 19000;
  
  // Padding
  static const double defaultPadding = 20.0;
  static const double borderRadius = 16.0;
}
