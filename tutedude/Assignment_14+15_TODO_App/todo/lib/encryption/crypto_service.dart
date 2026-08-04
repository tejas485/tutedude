import 'dart:convert';
import 'package:crypto/crypto.dart' as dart_crypto;
import 'package:encrypt/encrypt.dart' as enc;

class CryptoService {
  // FIXED: Adjusted to exactly 32 characters (256 bits) to eliminate the cipher length crash
  static final _key = enc.Key.fromUtf8('supersecuresecretkey32charssync!');
  static final _iv = enc.IV.fromUtf8('16bytesinitialiv');
  static final _encrypter = enc.Encrypter(enc.AES(_key));

  static String encrypt(String plainText) {
    if (plainText.trim().isEmpty) return plainText;
    return _encrypter.encrypt(plainText, iv: _iv).base64;
  }

  static String decrypt(String cipherText) {
    if (cipherText.trim().isEmpty) return cipherText;
    try {
      return _encrypter.decrypt64(cipherText, iv: _iv);
    } catch (_) {
      return '[Decryption Failure: Cipher Altered]';
    }
  }

  static String secureHash(String input) {
    if (input.trim().isEmpty) return input;
    final bytes = utf8.encode(input.trim().toLowerCase());
    final String rawHash = dart_crypto.sha256.convert(bytes).toString();
    return encrypt(rawHash);
  }
}
