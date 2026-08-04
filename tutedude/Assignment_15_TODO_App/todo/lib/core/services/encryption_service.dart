import 'package:encrypt/encrypt.dart' as enc;

class EncryptionService {
  // Production Note: In a live app, securely retrieve this dynamic key via flutter_secure_storage
  static final _key = enc.Key.fromLength(32);
  static final _iv = enc.IV.fromLength(16);
  static final _encrypter = enc.Encrypter(enc.AES(_key));

  static String encrypt(String text) {
    if (text.trim().isEmpty) return text;
    return _encrypter.encrypt(text, iv: _iv).base64;
  }

  static String decrypt(String encryptedText) {
    if (encryptedText.trim().isEmpty) return encryptedText;
    try {
      return _encrypter.decrypt(enc.Encrypted.fromBase64(encryptedText), iv: _iv);
    } catch (_) {
      return "Unable to decode text securely";
    }
  }
}
