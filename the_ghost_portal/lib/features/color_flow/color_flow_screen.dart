import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'color_flow_receiver_screen.dart';
import '../../core/app_constants.dart';
import '../../services/owc_service.dart';

class ColorFlowScreen extends StatefulWidget {
  const ColorFlowScreen({super.key});

  @override
  State<ColorFlowScreen> createState() => _ColorFlowScreenState();
}

class _ColorFlowScreenState extends State<ColorFlowScreen> {
  final _owcService = OWCService();
  bool _isTransmitting = false;
  Color _currentColor = AppColors.deepBlack;
  late List<Color> _dataStream;
  int _currentIndex = 0;
  Timer? _strobeTimer;

  @override
  void initState() {
    super.initState();
    _dataStream = _owcService.encodeData("TEST_DATA_PROTOCOL_01");
  }

  void _startTransmission() {
    setState(() {
      _isTransmitting = true;
      _currentIndex = 0;
    });

    // Strobe at 50ms intervals (20Hz)
    _strobeTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_currentIndex < _dataStream.length) {
        setState(() {
          _currentColor = _dataStream[_currentIndex];
          _currentIndex++;
        });
      } else {
        _stopTransmission();
      }
    });
  }

  void _stopTransmission() {
    _strobeTimer?.cancel();
    setState(() {
      _isTransmitting = false;
      _currentColor = AppColors.deepBlack;
    });
  }

  @override
  void dispose() {
    _strobeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      appBar: AppBar(
        title: const Text('COLOR-FLOW STREAM'),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Strobe Area
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _currentColor,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: _currentColor.withOpacity(0.5),
                    blurRadius: 40,
                    spreadRadius: 10,
                  )
                ],
                border: Border.all(color: Colors.white12),
              ),
              child: Center(
                child: _isTransmitting 
                  ? const Text('TRANSMITTING...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                  : const Icon(Icons.qr_code_scanner, color: Colors.white24, size: 100),
              ),
            ),
          ),
          
          // Control Area
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Text(
                    'THE SHADOW FILE PROTOCOL',
                    style: GoogleFonts.outfit(
                      color: AppColors.neonYellow,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Point the receiving device\'s camera directly at the color stream above. Ensure brightness is set to maximum.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isTransmitting ? _stopTransmission : _startTransmission,
                      icon: Icon(_isTransmitting ? Icons.stop : Icons.sensors),
                      label: Text(_isTransmitting ? 'STOP STREAM' : 'START TRANSMISSION'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isTransmitting ? Colors.redAccent : AppColors.portalPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _isTransmitting ? null : _handleReceiveData,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('SCAN FOR SIGNALS'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white10,
                      side: const BorderSide(color: AppColors.neonYellow),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleReceiveData() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    if (status.isGranted && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ColorFlowReceiverScreen()),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission required for scanning.')),
        );
      }
    }
  }
}
