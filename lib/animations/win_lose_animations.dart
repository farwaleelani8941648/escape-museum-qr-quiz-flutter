import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Widget to display the winning animation using Lottie
class WinAnimation extends StatelessWidget {
  const WinAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/win.json',
        repeat: false, // Play once
        width: 250,
      ),
    );
  }
}

/// Widget to display the losing animation using Lottie
class LoseAnimation extends StatelessWidget {
  const LoseAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/lose.json',
        repeat: false, // Play once
        width: 250,
      ),
    );
  }
}

