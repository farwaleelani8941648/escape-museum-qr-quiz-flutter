import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:blur/blur.dart';
import 'package:vibration/vibration.dart';
import '../provider/quiz_provider.dart';

/// QuizScreen: Displays quiz questions, handles timer, options, and background music.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _startMusic(); // Start background music when screen appears
  }

  /// Play background music in a loop
  Future<void> _startMusic() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('audio/quiz_bg.mp3'));
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Clean up audio player when leaving screen
    super.dispose();
  }

  /// Returns timer color based on time left
  Color getTimerColor(int seconds) {
    if (seconds > 10) return Colors.green;
    if (seconds > 5) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, _) {
        final question = quizProvider.currentQuestion;
        final isDark = quizProvider.isTooDark;
        final isBright = quizProvider.isTooBright;
        final showOptions = quizProvider.showOptions;
        final timeLeft = quizProvider.timeLeft;

        return Scaffold(
          appBar: AppBar(
            title: Text('Question ${quizProvider.currentIndex + 1}'),
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Question text
                Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Current light sensor value display
                Text(
                  'Current Light: ${quizProvider.lux.toStringAsFixed(1)} lux',
                  style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 24),

                // Show warning if lighting is too dark/bright
                if (isDark || isBright)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isDark
                        ? 'Too dark. Move to brighter light (e.g. under laptop screen).'
                        : 'Too bright! Move to normal indoor light.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),

                const SizedBox(height: 12),

                // Display options (image or text)
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: List.generate(question.options.length, (index) {
                    final option = question.options[index];
                    return GestureDetector(
                      onTap: showOptions
                          ? () async {
                              quizProvider.answerQuestion(index);
                              // Vibrate on answer
                              if (await Vibration.hasVibrator() ?? false) {
                                Vibration.vibrate(duration: 80);
                              }
                              // Navigate to result if quiz completed
                              if (quizProvider.isQuizCompleted) {
                                Navigator.pushReplacementNamed(context, '/result');
                              }
                            }
                          : null,
                      child: Container(
                        width: question.isImageOptions ? 100 : double.infinity,
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: question.isImageOptions
                            // If option is image, show image
                            ? Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.deepPurpleAccent,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(option, fit: BoxFit.cover),
                                ),
                              )
                            // Else, show option text
                            : Text(
                                option,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                        ),
                      ).blurred(
                        blur: showOptions ? 0 : 8,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }),
                ),

                const Spacer(),

                // Timer bar and text
                if (showOptions)
                  Column(
                    children: [
                      Text(
                        '⏳ Time left: $timeLeft s',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: 18,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: getTimerColor(timeLeft),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

