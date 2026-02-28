import 'package:flutter/material.dart';

class LightService {
  // Morse-code or pulse-width-modulation logic for light signaling
  // For demo, we use simple on/off pulses
  
  static const int pulseDurationMs = 200; // Duration of one light pulse
  
  // Convert message to a series of bools (true = flash, false = dark)
  List<bool> encodeMessage(String message) {
    List<bool> pulses = [];
    // Each character is converted to 8 pulses (simple binary)
    for (int i = 0; i < message.length; i++) {
      int code = message.codeUnitAt(i);
      for (int j = 7; j >= 0; j--) {
        pulses.add(((code >> j) & 1) == 1);
      }
    }
    return pulses;
  }
}
