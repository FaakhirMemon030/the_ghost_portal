import 'package:flutter/material.dart';
import '../../core/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  double _globalFrequency = 19000;
  bool _rotationInProgress = false;

  void _rotateEncryption() async {
    setState(() => _rotationInProgress = true);
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => _rotationInProgress = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Global Encryption Keys Rotated Successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('CENTRAL COMMAND (ADMIN)'),
        backgroundColor: Colors.transparent,
      ),
      body: Row(
        children: [
          // Sidebar (Web/Desktop style)
          if (MediaQuery.of(context).size.width > 800)
            Container(
              width: 250,
              color: Colors.white.withOpacity(0.02),
              child: Column(
                children: [
                  _buildSidebarItem(Icons.dashboard, 'Analytics', true),
                  _buildSidebarItem(Icons.people, 'User Management', false),
                  _buildSidebarItem(Icons.security, 'Security Protocols', false),
                  _buildSidebarItem(Icons.settings, 'System Settings', false),
                ],
              ),
            ),
          
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildStatCards(),
                   const SizedBox(height: 40),
                   
                   Text('SYSTEM PARAMETERS', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
                   const SizedBox(height: 20),
                   
                   // Frequency Control Card
                   _buildAdminCard(
                     'Sonic Auth Frequency Control',
                     'Tuning the global ultrasonic frequency to prevent environmental interference.',
                     Column(
                       children: [
                         Slider(
                           value: _globalFrequency,
                           min: 18000,
                           max: 22000,
                           activeColor: AppColors.neonYellow,
                           onChanged: (val) => setState(() => _globalFrequency = val),
                         ),
                         Text('${_globalFrequency.toInt()} Hz', style:  GoogleFonts.outfit(fontSize: 24, color: AppColors.neonYellow)),
                       ],
                     ),
                   ),
                   
                   const SizedBox(height: 20),
                   
                   // Encryption Rotation Card
                   _buildAdminCard(
                     'Global encryption Protocol',
                     'Cycle all active encryption keys across the portal network.',
                     Center(
                       child: ElevatedButton.icon(
                         onPressed: _rotationInProgress ? null : _rotateEncryption,
                         icon: Icon(_rotationInProgress ? Icons.sync : Icons.security_update_good, color: Colors.black),
                         label: Text(_rotationInProgress ? 'ROTATING...' : 'ROTATE GLOBAL KEYS'),
                         style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonYellow),
                       ),
                     ),
                   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String label, bool selected) {
    return ListTile(
      leading: Icon(icon, color: selected ? AppColors.neonYellow : Colors.white54),
      title: Text(label, style: TextStyle(color: selected ? AppColors.neonYellow : Colors.white54)),
      onTap: () {},
    );
  }

  Widget _buildStatCards() {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        _buildMiniStat('Active Users', '1,284', Icons.people, Colors.blue),
        _buildMiniStat('Total Transfers', '45.2 GB', Icons.swap_horiz, Colors.orange),
        _buildMiniStat('Security Events', '0 Warnings', Icons.gpp_good, Colors.green),
        _buildMiniStat('System Mood', 'Stable', Icons.psychology, AppColors.portalPurple),
      ],
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon, Color color) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white54)),
          Text(value, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAdminCard(String title, String description, Widget content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(fontSize: 12, color: Colors.white54)),
          const SizedBox(height: 20),
          content,
        ],
      ),
    );
  }
}
