import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/player_provider.dart';
import '../provider/quiz_provider.dart';

/// WelcomeScreen: Greets player, shows instructions, and starts the quiz.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access providers for player and quiz state
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    final quizProvider = Provider.of<QuizProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Personalized welcome
              Text(
                'Hello, ${playerProvider.capitalizedName}!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Game instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Instructions:\n\n'
                  '• This game uses your phone\'s light sensor.\n'
                  '• Answer options are hidden unless your phone is under a bright light.\n'
                  '• You will have 15 seconds to answer each question.\n'
                  '• Score 70% or more to win.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 30),

              // Start game button
              FilledButton.icon(
                onPressed: () {
                  quizProvider.startQuiz(playerProvider.playerName);
                  Navigator.pushReplacementNamed(context, '/quiz');
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

