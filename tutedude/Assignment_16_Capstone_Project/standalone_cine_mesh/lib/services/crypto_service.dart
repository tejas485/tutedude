// D:\standalone_cine_mesh\lib\services\crypto_service.dart
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart' as pc;

class MeshCryptoService {
  /// Generates a local 32-Byte Secret key derived from unique account credentials
  static String deriveUserSecretKey(String seedIdentifier) {
    final bytes = utf8.encode(seedIdentifier);
    final digest = sha256.convert(bytes);
    return base64.encode(digest.bytes);
  }

  /// Encrypts raw context strings locally before executing a remote cloud sync dump
  static Map<String, String> encryptLocalBackup(String plainText, String base64Key) {
    final keyBytes = base64.decode(base64Key);
    final random = Random.secure();
    final ivBytes = Uint8List.fromList(List<int>.generate(12, (_) => random.nextInt(256)));

    final keyObj = enc.Key(keyBytes);
    final ivObj = enc.IV(ivBytes);

    final encrypter = enc.Encrypter(enc.AES(keyObj, mode: enc.AESMode.gcm, padding: null));
    final encrypted = encrypter.encrypt(plainText, iv: ivObj);

    return {
      "iv": base64.encode(ivBytes),
      "ciphertext": encrypted.base64
    };
  }

  /// Decrypts ciphertext fields downloaded directly from zero-knowledge Firestore fields
  static String decryptLocalBackup(String base64Ciphertext, String base64Iv, String base64Key) {
    final keyBytes = base64.decode(base64Key);
    final ivBytes = base64.decode(base64Iv);
    final cipherBytes = base64.decode(base64Ciphertext);

    final keyObj = enc.Key(keyBytes);
    final ivObj = enc.IV(ivBytes);

    final encrypter = enc.Encrypter(enc.AES(keyObj, mode: enc.AESMode.gcm, padding: null));
    final decrypted = encrypter.decryptBytes(enc.Encrypted(cipherBytes), iv: ivObj);

    return utf8.decode(decrypted);
  }

  /// Encrypts raw data payloads sent directly downstream to the Kaggle API Gateway
  static Map<String, String> encryptClientPayload(String rawJson, String passphraseText) {
    // ─── DERIVE ALIGNED 32-BYTE KEY SECURELY FROM PLAIN TEXT PASSPHRASE ───
    final keyBytes = Uint8List.fromList(sha256.convert(utf8.encode(passphraseText)).bytes);

    final random = Random.secure();
    final ivBytes = Uint8List.fromList(List<int>.generate(12, (_) => random.nextInt(256)));
    final plainBytes = utf8.encode(rawJson);

    // Use native PointyCastle GCM Engine to automatically stitch [Ciphertext + 16-Byte Tag]
    final gcmEngine = pc.GCMBlockCipher(pc.AESEngine());
    final params = pc.AEADParameters(pc.KeyParameter(keyBytes), 128, ivBytes, Uint8List(0));
    gcmEngine.init(true, params); // true = encrypt

    final outBytes = Uint8List(gcmEngine.getOutputSize(plainBytes.length));
    var len = gcmEngine.processBytes(plainBytes, 0, plainBytes.length, outBytes, 0);
    len += gcmEngine.doFinal(outBytes, len);

    final finalPayload = outBytes.sublist(0, len);

    return {
      "iv": base64.encode(ivBytes),
      "ciphertext": base64.encode(finalPayload),
    };
  }

  /// Decrypts high-density 10-movie response payloads from the Kaggle gateway
  static String decryptServerPayload(String base64Ciphertext, String base64Iv, String passphraseText) {
    // ─── DERIVE ALIGNED 32-BYTE KEY SECURELY FROM PLAIN TEXT PASSPHRASE ───
    final keyBytes = Uint8List.fromList(sha256.convert(utf8.encode(passphraseText)).bytes);

    final ivBytes = base64.decode(base64Iv);
    final combinedBytes = base64.decode(base64Ciphertext);

    // Use native PointyCastle GCM Engine to read incoming [Ciphertext + Tag] payload correctly
    final gcmEngine = pc.GCMBlockCipher(pc.AESEngine());
    final params = pc.AEADParameters(pc.KeyParameter(keyBytes), 128, ivBytes, Uint8List(0));
    gcmEngine.init(false, params); // false = decrypt

    final outBytes = Uint8List(gcmEngine.getOutputSize(combinedBytes.length));
    var len = gcmEngine.processBytes(combinedBytes, 0, combinedBytes.length, outBytes, 0);
    len += gcmEngine.doFinal(outBytes, len);

    final cleanBytes = outBytes.sublist(0, len);
    return utf8.decode(cleanBytes);
  }
}
