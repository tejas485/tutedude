import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'audio_manager.dart';

enum SnakeDirection { up, down, left, right }

class GameEngine {
  int xCells = 20;
  int yCells = 20;
  List<Point<int>> snake = [const Point(10, 10), const Point(10, 11), const Point(10, 12)];
  Point<int> egg = const Point(5, 5);
  SnakeDirection direction = SnakeDirection.up;

  bool isPlaying = false;
  bool isPaused = false;
  int score = 0;
  int speedMs = 300;
  Timer? gameTimer;

  bool isStrikeReady = true;
  int strikeCooldownRemaining = 0;
  Timer? cooldownTimer;

  int highScore = 0;
  int longestPlaySeconds = 0;
  DateTime? sessionStartTime;
  int currentSessionSecondsAccumulated = 0;

  final Function onUpdate;
  final Function onGameOver;

  GameEngine({required this.onUpdate, required this.onGameOver});

  Future<void> loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;
    longestPlaySeconds = prefs.getInt('longestPlay') ?? 0;
    bool sOn = prefs.getBool('soundOn') ?? true;
    bool mOn = prefs.getBool('musicOn') ?? true;
    AudioManager().updateSettings(sound: sOn, music: mOn);
  }

  void startGame() {
    snake = [const Point(10, 10), const Point(10, 11), const Point(10, 12)];
    direction = SnakeDirection.up;
    score = 0;
    speedMs = 300;
    xCells = 20;
    yCells = 20;
    isPlaying = true;
    isPaused = false;
    currentSessionSecondsAccumulated = 0;
    sessionStartTime = DateTime.now();
    generateNewEgg();
    resetGameTimer();
    AudioManager().startBackgroundMusic();
    onUpdate();
  }

  void resetGameTimer() {
    gameTimer?.cancel();
    gameTimer = Timer.periodic(Duration(milliseconds: speedMs), (timer) {
      if (!isPaused && isPlaying) {
        _moveSnake();
      }
    });
  }

  void generateNewEgg() {
    final random = Random();
    while (true) {
      Point<int> newEgg = Point(random.nextInt(xCells), random.nextInt(yCells));
      if (!snake.contains(newEgg)) {
        egg = newEgg;
        break;
      }
    }
  }

  void _moveSnake() {
    Point<int> newHead;
    switch (direction) {
      case SnakeDirection.up: newHead = Point(snake.first.x, snake.first.y - 1); break;
      case SnakeDirection.down: newHead = Point(snake.first.x, snake.first.y + 1); break;
      case SnakeDirection.left: newHead = Point(snake.first.x - 1, snake.first.y); break;
      case SnakeDirection.right: newHead = Point(snake.first.x + 1, snake.first.y); break;
    }

    if (newHead.x < 0 || newHead.x >= xCells || newHead.y < 0 || newHead.y >= yCells || snake.contains(newHead)) {
      endGame();
      return;
    }

    snake.insert(0, newHead);

    if (newHead == egg) {
      score++;
      AudioManager().playSFX('sounds/eat.mp3');
      generateNewEgg();
      speedMs = (speedMs * 0.95).toInt().clamp(80, 300);
      resetGameTimer();

      if (snake.length >= (xCells * yCells) * 0.9) {
        xCells = (xCells * 1.5).toInt();
        yCells = (yCells * 1.5).toInt();
        AudioManager().playSFX('sounds/expand.mp3');
      }
    } else {
      snake.removeLast();
    }
    onUpdate();
  }

  void triggerStrike() {
    if (!isStrikeReady || !isPlaying || isPaused) return;

    isStrikeReady = false;
    strikeCooldownRemaining = 3;
    AudioManager().playSFX('sounds/strike.mp3');

    for (int i = 0; i < 5; i++) {
      Point<int> currentHead = snake.first;
      Point<int> nextHead;
      switch (direction) {
        case SnakeDirection.up: nextHead = Point(currentHead.x, currentHead.y - 1); break;
        case SnakeDirection.down: nextHead = Point(currentHead.x, currentHead.y + 1); break;
        case SnakeDirection.left: nextHead = Point(currentHead.x - 1, currentHead.y); break;
        case SnakeDirection.right: nextHead = Point(currentHead.x + 1, currentHead.y); break;
      }

      if (nextHead.x < 0 || nextHead.x >= xCells || nextHead.y < 0 || nextHead.y >= yCells || snake.contains(nextHead)) {
        endGame();
        return;
      }

      snake.insert(0, nextHead);
      if (nextHead == egg) {
        score++;
        generateNewEgg();
        speedMs = (speedMs * 0.95).toInt().clamp(80, 300);
      } else {
        snake.removeLast();
      }
    }
    resetGameTimer();

    cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (strikeCooldownRemaining > 1) {
        strikeCooldownRemaining--;
      } else {
        isStrikeReady = true;
        strikeCooldownRemaining = 0;
        cooldownTimer?.cancel();
      }
      onUpdate();
    });
    onUpdate();
  }

  void forcePause() {
    if (!isPlaying || isPaused) return;
    isPaused = true;
    if (sessionStartTime != null) {
      currentSessionSecondsAccumulated += DateTime.now().difference(sessionStartTime!).inSeconds;
    }
    onUpdate();
  }

  void forceUnpause() {
    if (!isPlaying || !isPaused) return;
    isPaused = false;
    sessionStartTime = DateTime.now();
    onUpdate();
  }

  void toggleManualPause() {
    if (!isPlaying) return;
    isPaused = !isPaused;
    if (isPaused) {
      if (sessionStartTime != null) {
        currentSessionSecondsAccumulated += DateTime.now().difference(sessionStartTime!).inSeconds;
      }
    } else {
      sessionStartTime = DateTime.now();
    }
    onUpdate();
  }

  Future<void> saveMetrics() async {
    final prefs = await SharedPreferences.getInstance();
    if (score > highScore) {
      highScore = score;
      await prefs.setInt('highScore', highScore);
    }
    int totalSessionTime = currentSessionSecondsAccumulated;
    if (sessionStartTime != null && isPlaying && !isPaused) {
      totalSessionTime += DateTime.now().difference(sessionStartTime!).inSeconds;
    }
    if (totalSessionTime > longestPlaySeconds) {
      longestPlaySeconds = totalSessionTime;
      await prefs.setInt('longestPlay', longestPlaySeconds);
    }
  }

  void endGame() {
    gameTimer?.cancel();
    cooldownTimer?.cancel();
    AudioManager().playSFX('sounds/gameover.mp3');
    saveMetrics();
    isPlaying = false;
    onGameOver();
  }

  void dispose() {
    gameTimer?.cancel();
    cooldownTimer?.cancel();
  }
}
