library nem2_sdk_dart.test.core.crypto.key_pair_test;

import 'dart:typed_data' show Uint8List;

import "package:test/test.dart";

import "package:nem2_sdk_dart/src/core/crypto.dart" show CryptoException, KeyPair;
import "package:nem2_sdk_dart/src/core/utils.dart" show HexUtils;

main() {
  final List<String> PRIVATE_KEYS = [
    '8D31B712AB28D49591EAF5066E9E967B44507FC19C3D54D742F7B3A255CFF4AB',
    '15923F9D2FFFB11D771818E1F7D7DDCD363913933264D58533CB3A5DD2DAA66A',
    'A9323CEF24497AB770516EA572A0A2645EE2D5A75BC72E78DE534C0A03BC328E',
    'D7D816DA0566878EE739EDE2131CD64201BCCC27F88FA51BA5815BCB0FE33CC8',
    '27FC9998454848B987FAD89296558A34DEED4358D1517B953572F3E0AAA0A22D'
  ];

  group('construction', () {
    test('can extract from private key test vectors', () {
      final List<String> EXPECTED_PUBLIC_KEYS = [
        '53C659B47C176A70EB228DE5C0A0FF391282C96640C2A42CD5BBD0982176AB1B',
        '3FE4A1AA148F5E76891CE924F5DC05627A87047B2B4AD9242C09C0ECED9B2338',
        'F398C0A2BDACDBD7037D2F686727201641BBF87EF458F632AE2A04B4E8F57994',
        '6A283A241A8D8203B3A1E918B1E6F0A3E14E75E16D4CFFA45AE4EF89E38ED6B5',
        '4DC62B38215826438DE2369743C6BBE6D13428405025DFEFF2857B9A9BC9D821'
      ];

      // Sanity check
      expect(PRIVATE_KEYS.length, equals(EXPECTED_PUBLIC_KEYS.length));

      for (int i = 0; i < PRIVATE_KEYS.length; i++) {
        String privateKeyHex = PRIVATE_KEYS[i];
        String expectedPublicKey = EXPECTED_PUBLIC_KEYS[i];

        KeyPair keyPair = KeyPair.createFromPrivateKeyString(privateKeyHex);

        String actualPubKey = HexUtils.getString(keyPair.publicKey).toUpperCase();
        String actualPrivKey = HexUtils.getString(keyPair.privateKey).toUpperCase();
        expect(actualPubKey, equals(expectedPublicKey));
        expect(actualPrivKey, equals(privateKeyHex));
      }
    });

    test('cannot extract from invalid private key', () {
      final List<String> INVALID_KEYS = [
        '', // empty
        '53C659B47C176A70EB228DE5C0A0FF391282C96640C2A42CD5BBD0982176AB', // short
        '53C659B47C176A70EB228DE5C0A0FF391282C96640C2A42CD5BBD0982176AB1BBB' // long
      ];

      for (var invalidPrivKey in INVALID_KEYS) {
        final Uint8List privateKeySeed = HexUtils.getBytes(invalidPrivKey);
        expect(
            () => KeyPair.createFromPrivateKeyString(invalidPrivKey),
            throwsA(predicate((e) =>
                e is CryptoException &&
                e.message == 'Private key has unexpected size: ${privateKeySeed.length}')));
      }
    });
  });
}
