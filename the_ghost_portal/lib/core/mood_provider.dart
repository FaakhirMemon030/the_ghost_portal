import 'package:flutter/material.dart';
import '../core/app_constants.dart';

enum UserMood { angry, sad, excited, neutral }

class MoodProvider extends ChangeNotifier {
  UserMood _currentMood = UserMood.neutral;

  UserMood get currentMood => _currentMood;

  void updateMood(UserMood mood) {
    if (_currentMood != mood) {
      _currentMood = mood;
      notifyListeners();
    }
  }

  Color get moodColor {
    switch (_currentMood) {
      case UserMood.angry:
        return AppColors.moodAngry;
      case UserMood.sad:
        return AppColors.moodSad;
      case UserMood.excited:
        return AppColors.moodExcited;
      case UserMood.neutral:
        return AppColors.moodNeutral;
    }
  }

  String get moodStatus {
    switch (_currentMood) {
      case UserMood.angry:
        return 'Calming Mode Active';
      case UserMood.sad:
        return 'Mood Lifting Active';
      case UserMood.excited:
        return 'Focus Mode Active';
      case UserMood.neutral:
        return 'System Stable';
    }
  }
}
