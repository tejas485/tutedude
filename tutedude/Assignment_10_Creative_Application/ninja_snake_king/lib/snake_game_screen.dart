import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'audio_manager.dart';
import 'game_engine.dart';

class SnakeGameScreen extends StatefulWidget {
  const SnakeGameScreen({super.key});

  @override
  State<SnakeGameScreen> createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  late GameEngine _engine;

  @override
  void initState() {
    super.initState();
    _engine = GameEngine(
      onUpdate: () => setState(() {}),
      onGameOver: () => _showGameOverDialog(),
    );
    _engine.loadLocalData();
  }

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('💥 Game Over'),
        content: Text('You scored ${_engine.score} points on this run!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _engine.startGame();
            },
            child: const Text('Play Again'),
          )
        ],
      ),
    );
  }

  void _openSettingsMenu() {
    // Automatically pauses the simulation state loops
    _engine.forcePause();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final audio = AudioManager();
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🛠️ Game Menu & Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.cyan)),
                  const Divider(color: Colors.white24),
                  SwitchListTile(
                    title: const Text('Sound Effects (SFX)'),
                    value: audio.isSoundOn,
                    activeThumbColor: Colors.cyan,
                    onChanged: (val) async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('soundOn', val);
                      audio.updateSettings(sound: val, music: audio.isMusicOn);
                      setModalState(() {});
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Ambient Music'),
                    value: audio.isMusicOn,
                    activeThumbColor: Colors.cyan,
                    onChanged: (val) async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('musicOn', val);
                      audio.updateSettings(sound: audio.isSoundOn, music: val);
                      setModalState(() {});
                    },
                  ),
                  const Divider(color: Colors.white24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('🏆 High Score:'),
                      Text('${_engine.highScore} pts', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('⏱️ Longest Play:'),
                      Text('${_engine.longestPlaySeconds}s', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12)
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        if (_engine.isPlaying) {
                          _engine.forceUnpause();
                        } else {
                          _engine.startGame();
                        }
                      },
                      child: Text(
                          _engine.isPlaying ? '▶️ Resume Game' : '🎮 Start Fresh Run',
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Score: ${_engine.score}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(_engine.isPaused || !_engine.isPlaying ? Icons.play_arrow : Icons.pause),
                    onPressed: () {
                      if (!_engine.isPlaying) {
                        _engine.startGame();
                      } else {
                        _engine.toggleManualPause();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: _openSettingsMenu,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey, border: Border.all(color: Colors.cyan, width: 2)),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final cellSize = min(constraints.maxWidth / _engine.xCells, constraints.maxHeight / _engine.yCells);
                      return Center(
                        child: Container(
                          width: cellSize * _engine.xCells,
                          height: cellSize * _engine.yCells,
                          color: Colors.black,
                          child: Stack(
                            children: [
                              Positioned(
                                left: _engine.egg.x * cellSize,
                                top: _engine.egg.y * cellSize,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: cellSize,
                                  height: cellSize,
                                  decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                                ),
                              ),
                              ..._engine.snake.map((pos) {
                                final isHead = pos == _engine.snake.first;
                                return Positioned(
                                  key: ValueKey(pos),
                                  left: pos.x * cellSize,
                                  top: pos.y * cellSize,
                                  child: Container(
                                    width: cellSize,
                                    height: cellSize,
                                    decoration: BoxDecoration(
                                      color: isHead ? Colors.greenAccent : Colors.green,
                                      borderRadius: BorderRadius.circular(isHead ? 4 : 2),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                color: Colors.black26,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _engine.isStrikeReady ? Colors.redAccent : Colors.grey,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(24),
                          ),
                          onPressed: _engine.isStrikeReady ? _engine.triggerStrike : null,
                          child: _engine.isStrikeReady
                              ? const Icon(Icons.bolt, size: 36, color: Colors.white)
                              : Text('${_engine.strikeCooldownRemaining}s', style: const TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                        const SizedBox(height: 4),
                        const Text("STRIKE", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.redAccent))
                      ],
                    ),
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_circle_up, size: 44, color: Colors.cyan),
                              onPressed: () { if (_engine.direction != SnakeDirection.down) _engine.direction = SnakeDirection.up; },
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_circle_down, size: 44, color: Colors.cyan),
                              onPressed: () { if (_engine.direction != SnakeDirection.up) _engine.direction = SnakeDirection.down; },
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_circle_left, size: 44, color: Colors.cyan),
                              onPressed: () { if (_engine.direction != SnakeDirection.right) _engine.direction = SnakeDirection.left; },
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_circle_right, size: 44, color: Colors.cyan),
                              onPressed: () { if (_engine.direction != SnakeDirection.left) _engine.direction = SnakeDirection.right; },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
