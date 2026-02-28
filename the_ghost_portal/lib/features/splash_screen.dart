import 'package:flutter/material.dart';
import 'dart:async';
import '../core/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(_controller);

    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: Stack(
        children: [
          // Animated Background Portal
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotateAnimation.value,
                  child: Container(
                    width: 300 * _scaleAnimation.value,
                    height: 300 * _scaleAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.portalPurple.withOpacity(0.8),
                          AppColors.portalPurple.withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Logo & Text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.neonYellow, AppColors.ghostWhite],
                  ).createShader(bounds),
                  child: Text(
                    'PORTAL',
                    style: GoogleFonts.outfit(
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AppConstants.slogan.toUpperCase(),
                  style: GoogleFonts.outfit(
                    color: AppColors.ghostWhite.withOpacity(0.6),
                    letterSpacing: 4,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Bottom Indicator
          const Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonYellow),
                strokeWidth: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
