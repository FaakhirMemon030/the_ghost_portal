import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_constants.dart';
import '../../services/sonic_service.dart';
import 'package:vibration/vibration.dart';
import '../home/home_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _sonicService = SonicService();
  bool _isSonicListening = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleSonicLogin() async {
    setState(() => _isSonicListening = true);
    
    // Trigger Haptic Feedback
    try {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 100);
      }
    } catch (e) {
      debugPrint('Vibration error: $e');
    }
    
    bool success = await _sonicService.listenForSignal();
    
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sonic Signature Verified! Access Granted.'),
            backgroundColor: AppColors.moodExcited,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeDashboard()),
        );
      }
    } else {
      if (mounted) {
        setState(() => _isSonicListening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sonic Verification Failed.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.deepBlack, AppColors.portalPurple],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.neonYellow, Colors.white],
                  ).createShader(bounds),
                  child: Text(
                    'SECURITY ACCESS',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                
                // Glassmorphic Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email Address',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Security Password',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeDashboard()),
                            );
                          },
                          child: const Text('INITIALIZE PROTOCOL'),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                const Text('OR USE OFF-GRID AUTHENTICATION', 
                  style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.5)),
                const SizedBox(height: 20),
                
                // Sonic Auth Button
                GestureDetector(
                  onTap: _isSonicListening ? null : _handleSonicLogin,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _isSonicListening ? AppColors.neonYellow.withOpacity(0.5) : AppColors.portalPurple.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        )
                      ],
                      border: Border.all(
                        color: _isSonicListening ? AppColors.neonYellow : AppColors.portalPurple,
                        width: 2,
                      ),
                      color: AppColors.deepBlack,
                    ),
                    child: Icon(
                      _isSonicListening ? Icons.graphic_eq : Icons.settings_voice,
                      size: 48,
                      color: _isSonicListening ? AppColors.neonYellow : AppColors.portalPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _isSonicListening ? 'LISTENING FOR SONIC KEY...' : 'SONIC AUTH',
                  style: GoogleFonts.outfit(
                    color: _isSonicListening ? AppColors.neonYellow : AppColors.portalPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
