import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  // Generate a secure key (In production, store this securely)
  final _key = encrypt.Key.fromLength(32);
  late final encrypt.IV _iv;
  late final encrypt.Encrypter _encrypter;

  void initialize() {
    _iv = encrypt.IV.fromLength(16);
    _encrypter = encrypt.Encrypter(encrypt.AES(_key));
  }

  /// Encrypt sensitive data
  String encryptData(String plainText) {
    try {
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      throw Exception('Encryption failed: $e');
    }
  }

  /// Decrypt sensitive data
  String decryptData(String encryptedText) {
    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
      return _encrypter.decrypt(encrypted, iv: _iv);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }

  /// Hash sensitive data (one-way)
  String hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generate anonymous ID for grievances
  String generateAnonymousId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = encrypt.IV.fromLength(16).base64;
    return hashData('$timestamp$random').substring(0, 16);
  }
}
