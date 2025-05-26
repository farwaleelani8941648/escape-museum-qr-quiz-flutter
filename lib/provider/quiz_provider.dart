import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'package:vibration/vibration.dart';

/// Question model representing a quiz question
class Question {
  final String question;
  final List<String> options;
  final int correctIndex;
  final bool isImageOptions;

  Question({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.isImageOptions = false,
  });
}

/// QuizProvider: Handles all quiz logic, state, and light sensor interaction
class QuizProvider with ChangeNotifier {
  // --- Question Data ---

  final List<Question> _allQuestions = [
    Question(
      question: "Which Belgian city is world-famous for its pralines?",
      options: ["Antwerp", "Brussels", "Bruges", "Charleroi", "Liège"],
      correctIndex: 1,
    ),
    Question(
      question: "Which image shows a traditional Belgian waffle?",
      options: [
        "assets/images/Q2/option1.png",
        "assets/images/Q2/option2.png",
        "assets/images/Q2/option3.png", // correct
        "assets/images/Q2/option4.png",
        "assets/images/Q2/option5.png",
      ],
      correctIndex: 2,
      isImageOptions: true,
    ),
    Question(
      question: "What is the main ingredient in traditional Belgian speculoos?",
      options: ["Chocolate", "Almonds", "Cinnamon", "Honey", "Caramel"],
      correctIndex: 2,
    ),
    Question(
      question: "Which image represents Belgian lace, a famous local craft?",
      options: [
        "assets/images/Q4/option1.png",
        "assets/images/Q4/option2.png",
        "assets/images/Q4/option3.png",
        "assets/images/Q4/option4.png",
        "assets/images/Q4/option5.png", // correct
      ],
      correctIndex: 4,
      isImageOptions: true,
    ),
    Question(
      question: "Which of these is a classic Belgian seafood dish?",
      options: ["Moules-frites", "Bouillabaisse", "Sushi", "Fish and chips", "Grilled salmon"],
      correctIndex: 0,
    ),
  ];

  // --- Quiz State ---

  List<Question> _shuffledQuestions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  double _lux = 0;
  bool _showOptions = false;
  bool _timerRunning = false;
  int _timeLeft = 15;
  Timer? _questionTimer;
  final Light _light = Light();
  StreamSubscription<int>? _lightSub;

  // --- Getters for UI ---
  List<Question> get questions => _shuffledQuestions;
  Question get currentQuestion => _shuffledQuestions[_currentIndex];
  int get currentIndex => _currentIndex;
  int get score => _score;
  double get scorePercentage => (_score / _shuffledQuestions.length) * 100;
  bool get isQuizCompleted => _quizCompleted;
  bool get showOptions => _showOptions;
  int get timeLeft => _timeLeft;
  double get lux => _lux;

  // --- Light environment feedback ---
  bool get isTooDark => _lux < 50;
  bool get isTooBright => _lux > 1000;
  bool get isIdeal => _lux >= 200 && _lux <= 1000;

  /// Constructor: Starts the light sensor stream
  QuizProvider() {
    _startLightSensor();
  }

  /// Start a new quiz using a seed based on player's name
  void startQuiz(String playerName) {
    _score = 0;
    _currentIndex = 0;
    _quizCompleted = false;
    _shuffledQuestions = _getShuffledQuestionsFromSeed(playerName);
    _showOptions = false;
    _timeLeft = 15;
    _timerRunning = false;
    notifyListeners();
  }

  /// Shuffle questions using a seeded random based on player name
  List<Question> _getShuffledQuestionsFromSeed(String seedText) {
    final seed = seedText.hashCode;
    final random = Random(seed);
    final copy = List<Question>.from(_allQuestions)..shuffle(random);
    return copy.take(5).toList();
  }

  /// Listen to the phone's light sensor and update state accordingly
  void _startLightSensor() {
    _lightSub = _light.lightSensorStream.listen((luxValue) {
      _lux = luxValue.toDouble();

      if (_quizCompleted) return;

      // If ideal lighting and not showing options, reveal options and start timer
      if (isIdeal && !_showOptions && !_timerRunning) {
        _showOptions = true;
        _startTimer();
      }
      // If not ideal and options showing, hide options and stop timer
      else if (!isIdeal && _showOptions) {
        _showOptions = false;
        _stopTimer();
      }

      notifyListeners();
    });
  }

  /// Start countdown timer for current question
  void _startTimer() {
    _timerRunning = true;
    _timeLeft = 15;

    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft <= 1) {
        _handleAnswer(-1); // -1 means timeout/no answer
      } else {
        _timeLeft--;
        notifyListeners();
      }
    });
  }

  /// Stop and reset the timer
  void _stopTimer() {
    _questionTimer?.cancel();
    _timerRunning = false;
    _timeLeft = 15;
  }

  /// Answer the current question with selected option index
  void answerQuestion(int index) async {
    if (_quizCompleted) return;
    _handleAnswer(index);

    // Optional: vibrate for feedback
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 80);
    }
  }

  /// Internal handler for answer or timeout
  void _handleAnswer(int index) {
    _stopTimer();

    if (_currentIndex >= _shuffledQuestions.length) return;

    // Check correctness and increment score
    if (index >= 0 && index == currentQuestion.correctIndex) {
      _score++;
    }

    // Move to next question or complete quiz
    if (_currentIndex < _shuffledQuestions.length - 1) {
      _currentIndex++;
      _showOptions = false;
      _timeLeft = 15;
      _timerRunning = false;
    } else {
      _quizCompleted = true;
    }

    notifyListeners();
  }

  /// Resets all quiz state for a fresh game
  void resetQuiz() {
    _stopTimer();
    _currentIndex = 0;
    _score = 0;
    _quizCompleted = false;
    _showOptions = false;
    _timeLeft = 15;
    _timerRunning = false;
    notifyListeners();
  }

  /// Dispose timers and sensor subscriptions
  @override
  void dispose() {
    _questionTimer?.cancel();
    _lightSub?.cancel();
    super.dispose();
  }
}

