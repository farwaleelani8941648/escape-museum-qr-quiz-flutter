import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../provider/quiz_provider.dart';

/// ResultScreen: Shows quiz results, animated feedback, and action buttons.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access quiz results without listening for further changes
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);

    // Calculate score percentage and pass/fail state
    final double percentage = quizProvider.scorePercentage;
    final bool passed = percentage >= 70;
    final int score = quizProvider.score;
    final int total = quizProvider.questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Result'),
        automaticallyImplyLeading: false, // Removes back button
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🎉 Lottie animation: shows win/lose animation based on result
              Lottie.asset(
                passed
                    ? 'assets/animations/win.json'
                    : 'assets/animations/lose.json',
                height: 200,
                repeat: false,
              ),
              const SizedBox(height: 20),

              // ✅ Result message
              Text(
                passed ? 'You are free to go!' : 'You are not free yet!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: passed ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // ✅ Score display
              Text(
                'Your Score: $score / $total',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 40),

              // 🔁 Play Again button (resets quiz and goes to quiz screen)
              FilledButton.icon(
                onPressed: () {
                  quizProvider.resetQuiz();
                  Navigator.pushReplacementNamed(context, '/quiz');
                },
                icon: const Icon(Icons.replay),
                label: const Text('Play Again'),
              ),
              const SizedBox(height: 16),

              // 🚪 Exit button (resets quiz and goes to home screen)
              FilledButton.icon(
                onPressed: () {
                  quizProvider.resetQuiz();
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                },
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Exit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

