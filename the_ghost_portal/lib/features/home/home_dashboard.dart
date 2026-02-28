import '../../core/app_constants.dart';
import '../../core/mood_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../color_flow/color_flow_screen.dart';
import '../ghost_chat/ghost_chat_screen.dart';
import '../mood_ui/mood_detection_screen.dart';
import '../admin/admin_dashboard.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('GHOST PORTAL', style: GoogleFonts.outfit(letterSpacing: 4)),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mood Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: moodProvider.moodColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                border: Border.all(color: moodProvider.moodColor.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Icon(Icons.psychology, color: moodProvider.moodColor, size: 32),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SYSTEM MOOD', style: TextStyle(color: moodProvider.moodColor, fontSize: 10, fontWeight: FontWeight.bold)),
                      Text(moodProvider.moodStatus.toUpperCase(), style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            Text('CORE PROTOCOLS', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white54)),
            const SizedBox(height: 15),
            
            // Grid of Features
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _buildFeatureCard(
                  context,
                  'COLOR-FLOW',
                  'Visual Data Stream',
                  Icons.stream,
                  AppColors.neonYellow,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ColorFlowScreen()),
                    );
                  },
                ),
                _buildFeatureCard(
                  context,
                  'GHOST CHAT',
                  'Off-Grid Messenger',
                  Icons.auto_fix_high,
                  AppColors.portalPurple,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GhostChatScreen()),
                    );
                  },
                ),
                _buildFeatureCard(
                  context,
                  'SONIC AUTH',
                  'Sound-Key Control',
                  Icons.settings_voice,
                  Colors.cyan,
                  () {},
                ),
                _buildFeatureCard(
                  context,
                  'BIOMETRICS',
                  'Mood & Heart Rate',
                  Icons.fingerprint,
                  Colors.white70,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MoodDetectionScreen()),
                    );
                  },
                ),
                _buildFeatureCard(
                  context,
                  'ADMIN',
                  'System Command',
                  Icons.admin_panel_settings_outlined,
                  Colors.redAccent,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminDashboard()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}
