import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({super.key});

  @override
  State<AddDevicePage> createState() => _AddDevicePage();
}

class _AddDevicePage extends State<AddDevicePage>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  bool _isDisposed = false;
  List<String> devices = [];
  late AnimationController _animationController;

  Map<String, String> _getText(bool isEnglish) {
    return {
      'searching': isEnglish ? 'Searching for devices...' : '正在搜索設備...',
      'tapToSearch': isEnglish ? 'Tap to start searching' : '點擊開始搜索',
      'stopSearch': isEnglish ? 'Stop Search' : '停止搜索',
      'startSearch': isEnglish ? 'Start Search' : '開始搜索',
      'connect': isEnglish ? 'Connect' : '連接',
      'device': isEnglish ? 'Device' : '設備',
    };
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _isSearching = false;
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEnglish = context.watch<LocaleProvider>().isEnglish;
    final texts = _getText(isEnglish);

    return Container(
      color: const Color(0xFF22272E),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Container(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_isSearching) ...[
                  ...List.generate(3, (index) {
                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Container(
                          width: 200,
                          height: 200,
                          child: CustomPaint(
                            painter: CircleWavePainter(
                              animation: _animationController,
                              index: index,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.bluetooth,
                    size: 48,
                    color: Colors.blue[400],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            _isSearching ? texts['searching']! : texts['tapToSearch']!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (_isSearching) {
                  _simulateDeviceFound(isEnglish);
                } else {
                  devices.clear();
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[400],
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              _isSearching ? texts['stopSearch']! : texts['startSearch']!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: devices
                    .map((device) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(
                              Icons.bluetooth,
                              color: Colors.white,
                            ),
                            title: Text(
                              device,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            trailing: TextButton(
                              onPressed: () {
                                // 處理連接邏輯
                              },
                              child: Text(
                                texts['connect']!,
                                style: const TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _simulateDeviceFound(bool isEnglish) {
    if (_isSearching && !_isDisposed) {
      Future.delayed(const Duration(seconds: 1), () {
        if (_isSearching && !_isDisposed && mounted) {
          setState(() {
            devices
                .add('${_getText(isEnglish)['device']} ${devices.length + 1}');
          });
          _simulateDeviceFound(isEnglish);
        }
      });
    }
  }
}

class CircleWavePainter extends CustomPainter {
  final Animation<double> animation;
  final int index;

  CircleWavePainter({required this.animation, required this.index});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.blue.withOpacity(0.5 - (animation.value * 0.5)),
          Colors.blue.withOpacity(0.0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ))
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;
    final progress = (animation.value + index / 5) % 1.0;
    final radius = maxRadius * progress;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CircleWavePainter oldDelegate) => true;
}
