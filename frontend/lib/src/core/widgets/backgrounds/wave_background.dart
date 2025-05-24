import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

class WaveBackground extends StatelessWidget {
  const WaveBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        colors: [
          // Gradient for the first wave
          Colors.blue,
          Colors.red,
        ],
        durations: [18000, 21000], // Animation duration for each wave
        heightPercentages: [0.25, 0.30], // Wave height relative to widget
      ),
      waveAmplitude: 10.0, // Wave height variation
      size: const Size(double.infinity, double.infinity), // Full-screen
      backgroundColor: Colors.transparent, // Background behind waves
    );
  }
}
