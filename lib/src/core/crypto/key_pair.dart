library nem2_sdk_dart.core.crypto.key_pair;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/src/core/utils.dart' show HexUtils;
import 'package:nem2_sdk_dart/src/core/crypto/crypto_exception.dart';

import 'ed25519.dart';

/// Represents a key pair
class KeyPair {
  final Uint8List _privateKey;
  final Uint8List _publicKey;

  KeyPair._(this._privateKey, this._publicKey);

  /// Factory method to create a key pair
  factory KeyPair({Uint8List privateKey = null, Uint8List publicKey = null}) {
    if (privateKey == null) {
      throw new ArgumentError("privateKey byte cannot be null");
    }

    if (privateKey.lengthInBytes != 32 && privateKey.lengthInBytes != 33) {
      throw new ArgumentError("Invalid length for privateKey. Length: ${privateKey.lengthInBytes}");
    }

    return new KeyPair._(privateKey, publicKey);
  }

  /// Gets the public key
  Uint8List get publicKey => _publicKey;

  /// Gets the private key
  Uint8List get privateKey => _privateKey;

  /// Creates a key pair from a [hexEncodedPrivateKey] string. The public key is extracted from
  /// the private key. This method throws a [CryptoException] when an invalid length of the
  /// private key string is found.
  static KeyPair createFromPrivateKeyString(final String hexEncodedPrivateKey) {
    final Uint8List privateKeySeed = HexUtils.getBytes(hexEncodedPrivateKey);
    if (Ed25519.KEY_SIZE != privateKeySeed.length) {
      throw new CryptoException(
          "Private key has an unexpected size. Expected: ${Ed25519.KEY_SIZE}, Got: ${privateKeySeed.length}");
    }

    final Uint8List publicKey = Ed25519.extractPublicKey(privateKeySeed);

    return new KeyPair(privateKey: privateKeySeed, publicKey: publicKey);
  }

  /// Signs a data buffer with a key pair.
  static Uint8List sign(final KeyPair keyPair, final Uint8List data) {
    return Ed25519.sign(data, keyPair.publicKey, keyPair.privateKey);
  }

  /// Verifies a signature.
  static bool verify(final Uint8List publicKey, final Uint8List data, final Uint8List signature) {
    return Ed25519.verify(publicKey, data, signature);
  }

  static Uint8List deriveSharedKey(
      final KeyPair keyPair, final Uint8List publicKey, final Uint8List salt) {
    // TODO: implement
    return null;
  }
}
