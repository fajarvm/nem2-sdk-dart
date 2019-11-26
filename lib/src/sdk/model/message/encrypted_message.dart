//
// Copyright (c) 2019 Fajar van Megen
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

library nem2_sdk_dart.sdk.model.message.encrypted_message;

import 'dart:typed_data' show Uint8List;

import 'package:encrypt/encrypt.dart';

import 'package:nem2_sdk_dart/core.dart'
    show CryptoException, CryptoUtils, HexUtils, SignSchema, StringUtils;

import '../blockchain/network_type.dart';

import 'message.dart';
import 'message_type.dart';

/// An encrypted message model defines a secure message that has been encrypted using
/// the NEM's SDK libraries.
///
/// Please note:
/// The strategy to encrypt and decrypt should be consistent between the different SDKs.
/// A client may send a transaction using a different encryption strategy than the recipient.
/// Even though the same encryption algorithm is used, the outcome may still be different
/// depending on the encoding process.
///
/// The encryption strategy this SDK uses is UTF-8 and hex encodings:
/// "plain text" string -> utf8 byte array -> encrypted byte array -> hex string
class EncryptedMessage extends Message {
  static const int KEY_SIZE = 32;
  static const int BLOCK_SIZE = 16;

  // private constructor
  EncryptedMessage._(String encryptedPayload)
      : super(MessageType.ENCRYPTED_MESSAGE, encryptedPayload);

  // Developer note:
  // If one to allow to create a EncryptedMessage object using this constructor, make sure to
  // put in place a check to see if the payload (in bytes) is actually encrypted or not.
  //  factory EncryptedMessage(final Uint8List encryptedPayload) {
  //    if (encryptedPayload == null) {
  //      throw new ArgumentError('The message payload must not be null');
  //    }
  //
  //    return new EncryptedMessage._(encryptedPayload);
  //  }

  /// Creates an encrypted message.
  ///
  /// The [plainTextMessage] for the [networkType] is encrypted using a shared key generated by the
  /// [senderPrivateKey] and the [recipientPublicKey]. The receiver can decrypt the message
  /// using this shared key.
  static EncryptedMessage create(final String plainTextMessage, final String senderPrivateKey,
      final String recipientPublicKey, final NetworkType networkType) {
    ArgumentError.checkNotNull(plainTextMessage);
    ArgumentError.checkNotNull(networkType);

    if (StringUtils.isEmpty(senderPrivateKey) || StringUtils.isEmpty(recipientPublicKey)) {
      throw new ArgumentError('Sender private key and recipient public key are required');
    }

    // Plain text (UTF-8) message payload
    Uint8List payload = HexUtils.getBytes(HexUtils.utf8ToHex(plainTextMessage));

    // Encrypts the message
    final Uint8List salt = CryptoUtils.getRandomBytes(KEY_SIZE);
    final iv = IV(CryptoUtils.getRandomBytes(BLOCK_SIZE));
    final SignSchema signSchema = NetworkType.resolveSignSchema(networkType);
    final Uint8List senderByte = HexUtils.getBytes(senderPrivateKey);
    final Uint8List recipientByte = HexUtils.getBytes(recipientPublicKey);
    final Uint8List sharedKey =
        CryptoUtils.deriveSharedKey(salt, senderByte, recipientByte, signSchema);
    final Encrypter encrypter = Encrypter(AES(Key(sharedKey), mode: AESMode.cbc));
    final encryptedMessage = encrypter.algo.encrypt(payload, iv: iv);

    // Creates a concatenated byte array as the encrypted payload
    final Uint8List encryptedPayload = Uint8List.fromList(salt + iv.bytes + encryptedMessage.bytes);
    return EncryptedMessage._(HexUtils.bytesToHex(encryptedPayload));
  }

  /// Creates an encrypted message from [payload]. The [payload] is a hex encoded string.
  static EncryptedMessage fromPayload(final String payload) {
    if (!HexUtils.isHex(payload)) {
      throw new ArgumentError('message payload is not a valid hex string');
    }

    return new EncryptedMessage._(payload);
  }

  /// Decodes the encrypted message payload sent for the [networkType].
  String decrypt(final String recipientPrivateKey, final String senderPublicKey,
      final NetworkType networkType) {
    if (payload == null) {
      throw new ArgumentError('there is no paylaod to decode');
    }

    const int totalLength = KEY_SIZE + BLOCK_SIZE;
    if (payload.length < (totalLength)) {
      throw new ArgumentError('the encrypted payload has an incorrect size');
    }

    final Uint8List payloadBytes = HexUtils.getBytes(payload);
    final Uint8List recipientByte = HexUtils.getBytes(recipientPrivateKey);
    final Uint8List senderByte = HexUtils.getBytes(senderPublicKey);
    final Uint8List salt = _extractSalt(payloadBytes);
    final Uint8List iv = _extractIV(payloadBytes);
    final Uint8List encrypted = _extractEncryptedMessage(payloadBytes);
    final SignSchema signSchema = NetworkType.resolveSignSchema(networkType);

    try {
      final Uint8List sharedKey =
          CryptoUtils.deriveSharedKey(salt, recipientByte, senderByte, signSchema);
      final Encrypter encrypter = Encrypter(AES(Key(sharedKey), mode: AESMode.cbc));
      final String decrypted = encrypter.decrypt(Encrypted(encrypted), iv: IV(iv));
      return decrypted;
    } catch (e) {
      throw new CryptoException('Failed to decrypt message');
    }
  }

  // ------------------------------ private / protected functions ------------------------------ //

  Uint8List _extractSalt(final Uint8List payloadBytes) {
    return Uint8List.fromList(payloadBytes.take(KEY_SIZE).toList());
  }

  Uint8List _extractIV(final Uint8List payloadBytes) {
    return Uint8List.fromList(payloadBytes.skip(KEY_SIZE).take(BLOCK_SIZE).toList());
  }

  Uint8List _extractEncryptedMessage(final Uint8List payloadBytes) {
    return Uint8List.fromList(payloadBytes
        .skip(KEY_SIZE + BLOCK_SIZE)
        .take(payload.length - (KEY_SIZE + BLOCK_SIZE))
        .toList());
  }
}
