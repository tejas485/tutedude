import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();

  bool isSoundOn = true;
  bool isMusicOn = true;

  void updateSettings({required bool sound, required bool music}) {
    isSoundOn = sound;
    isMusicOn = music;
    if (!isMusicOn) {
      _musicPlayer.stop();
    } else {
      startBackgroundMusic();
    }
  }

  void playSFX(String path) async {
    if (!isSoundOn) return;
    try {
      // Stops only the localized SFX track so the background music loop keeps running
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource(path));
    } catch (_) {}
  }

  void startBackgroundMusic() async {
    if (!isMusicOn) return;
    try {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.play(AssetSource('music/bg_loop.mp3'));
    } catch (_) {}
  }

  void stopAll() {
    _sfxPlayer.stop();
    _musicPlayer.stop();
  }

  void dispose() {
    _sfxPlayer.dispose();
    _musicPlayer.dispose();
  }
}
