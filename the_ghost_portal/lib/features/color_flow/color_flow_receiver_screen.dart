import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_constants.dart';
import '../../services/owc_service.dart';

class ColorFlowReceiverScreen extends StatefulWidget {
  const ColorFlowReceiverScreen({super.key});

  @override
  State<ColorFlowReceiverScreen> createState() => _ColorFlowReceiverScreenState();
}

class _ColorFlowReceiverScreenState extends State<ColorFlowReceiverScreen> {
  CameraController? _controller;
  bool _isScanning = false;
  String? _receivedFile;
  final _owcService = OWCService();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    try {
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  Future<void> _startScan() async {
    setState(() {
      _isScanning = true;
      _receivedFile = null;
    });

    final fileName = await _owcService.decodeFromCamera();

    if (mounted) {
      setState(() {
        _isScanning = false;
        _receivedFile = fileName;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      appBar: AppBar(
        title: Text('OWC SCANNER', style: GoogleFonts.outfit()),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // Camera Preview
          Positioned.fill(
            child: CameraPreview(_controller!),
          ),

          // Scanning Overlay
          if (_isScanning)
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.neonYellow, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    _buildScanningLine(),
                  ],
                ),
              ),
            ),

          // UI Controls
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                if (_receivedFile != null)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.deepBlack.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.moodExcited),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.file_present, color: AppColors.moodExcited),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('FILE RECEIVED', style: GoogleFonts.outfit(fontSize: 10, color: Colors.white54)),
                            Text(_receivedFile!, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _isScanning ? null : _startScan,
                  icon: Icon(_isScanning ? Icons.sync : Icons.qr_code_scanner),
                  label: Text(_isScanning ? 'DECODING STROBE...' : 'INITIALIZE SCAN'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isScanning ? Colors.white24 : AppColors.neonYellow,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningLine() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 250),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Positioned(
          top: value,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonYellow.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
              color: AppColors.neonYellow,
            ),
          ),
        );
      },
      onEnd: () {
        if (_isScanning) setState(() {});
      },
    );
  }
}
