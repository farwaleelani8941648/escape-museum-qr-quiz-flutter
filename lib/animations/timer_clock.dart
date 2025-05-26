import 'package:flutter/material.dart';

/// TimerClock: Shows a circular, animated countdown timer.
/// Changes color as time decreases for visual urgency.
class TimerClock extends StatelessWidget {
  final int remainingTime;

  const TimerClock({super.key, required this.remainingTime});

  /// Returns the color of the timer based on remaining seconds.
  Color _getTimerColor(int time) {
    if (time > 10) return Colors.green;
    if (time > 5) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: _getTimerColor(remainingTime),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$remainingTime',
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

