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

library nem2_sdk_dart.test.sdk.model.account.address_test;

import 'dart:typed_data' show Uint8List;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show Address, NetworkType;
import 'package:nem2_sdk_dart/core.dart' show ArrayUtils, HexUtils, KeyPair;

void main() {
  group('fromPublicKey', () {
    test('can create from public key for the designated network type', () {
      const publicKey = 'c2f93346e27ce6ad1a9f8f5e3066f8326593a406bdf357acb041e2f9ab402efe';
      final address1 = Address.fromPublicKey(publicKey, NetworkType.MIJIN);
      expect(address1.plain, equals('MCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPR72DYSX'));
      expect(address1.networkType, equals(NetworkType.MIJIN));

      final address2 = Address.fromPublicKey(publicKey, NetworkType.MIJIN_TEST);
      expect(address2.plain, equals('SCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPRLIKCF2'));
      expect(address2.networkType, equals(NetworkType.MIJIN_TEST));

      final address3 = Address.fromPublicKey(publicKey, NetworkType.MAIN_NET);
      expect(address3.plain, equals('NCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPQUJ2ZML'));
      expect(address3.networkType, equals(NetworkType.MAIN_NET));

      final address4 = Address.fromPublicKey(publicKey, NetworkType.TEST_NET);
      expect(address4.plain, equals('TCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPSDRSFRF'));
      expect(address4.networkType, equals(NetworkType.TEST_NET));
    });
  });

  group('fromRawAddress', () {
    test('can create from raw address and also determines its network type', () {
      final address1 = Address.fromRawAddress('MCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPR72DYSX');
      expect(address1.plain, equals('MCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPR72DYSX'));
      expect(address1.networkType, equals(NetworkType.MIJIN));

      final address2 = Address.fromRawAddress('SCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPRLIKCF2');
      expect(address2.plain, equals('SCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPRLIKCF2'));
      expect(address2.networkType, equals(NetworkType.MIJIN_TEST));

      final address3 = Address.fromRawAddress('NCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPQUJ2ZML');
      expect(address3.plain, equals('NCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPQUJ2ZML'));
      expect(address3.networkType, equals(NetworkType.MAIN_NET));

      final address4 = Address.fromRawAddress('TCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPSDRSFRF');
      expect(address4.plain, equals('TCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPSDRSFRF'));
      expect(address4.networkType, equals(NetworkType.TEST_NET));
    });
  });

  group('fromEncoded', () {
    test('can create from encoded address string', () {
      const encodedString = '9050B9837EFAB4BBE8A4B9BB32D812F9885C00D8FC1650E142';
      final address = Address.fromEncoded(encodedString);

      expect(address.plain, equals('SBILTA367K2LX2FEXG5TFWAS7GEFYAGY7QLFBYKC'));
    });
  });

  group('stringToAddress', () {
    test('can create address from valid encoded address', () {
      const encoded = 'NAR3W7B4BCOZSZMFIZRYB3N5YGOUSWIYJCJ6HDFG';
      const expectedHex = '6823BB7C3C089D996585466380EDBDC19D4959184893E38CA6';

      final decoded = Address.stringToAddress(encoded);

      expect(Address.isValidAddress(decoded), isTrue);
      expect(HexUtils.getString(decoded).toUpperCase(), equals(expectedHex));
    });

    test('cannot create address from an encoded string with the invalid length', () {
      assertCannotCreateAddress('NC5J5DI2URIC4H3T3IMXQS25PWQWZIPEV6EV7LASABCDEFGH',
          'The encoded address NC5J5DI2URIC4H3T3IMXQS25PWQWZIPEV6EV7LASABCDEFGH does not represent a valid encoded address');
    });

    test('cannot create address from invalid encoded string', () {
      assertCannotCreateAddress(
          'NC5(5DI2URIC4H3T3IMXQS25PWQWZIPEV6EV7LAS', 'illegal base32 character (');
      assertCannotCreateAddress(
          'NC5J1DI2URIC4H3T3IMXQS25PWQWZIPEV6EV7LAS', 'illegal base32 character 1');
      assertCannotCreateAddress(
          'NC5J5?I2URIC4H3T3IMXQS25PWQWZIPEV6EV7LAS', 'illegal base32 character ?');
    });
  });

  group('addressToString', () {
    test('can create encoded address from address', () {
      const decodedHex = '6823BB7C3C089D996585466380EDBDC19D4959184893E38CA6';
      const expected = 'NAR3W7B4BCOZSZMFIZRYB3N5YGOUSWIYJCJ6HDFG';

      final encoded = Address.addressToString(HexUtils.getBytes(decodedHex));

      expect(encoded, equals(expected));
    });
  });

  group('publicKeyToAddress', () {
    test('can create decoded address from a public key for a known network', () {
      const expected = '6023BB7C3C089D996585466380EDBDC19D49591848B3727714';
      final publicKey =
          HexUtils.getBytes('3485D98EFD7EB07ADAFCFD1A157D89DE2796A95E780813C0258AF3F5F84ED8CB');

      final decoded = Address.publicKeyToAddress(publicKey, NetworkType.MIJIN);

      expect(decoded[0], equals(NetworkType.MIJIN));
      expect(Address.isValidAddress(decoded), isTrue);
      expect(HexUtils.getString(decoded).toUpperCase(), equals(expected));
    });

    test('can create decoded address from a public key for a custom network', () {
      const expected = '9823BB7C3C089D996585466380EDBDC19D495918484BF7E997';
      final publicKey =
          HexUtils.getBytes('3485D98EFD7EB07ADAFCFD1A157D89DE2796A95E780813C0258AF3F5F84ED8CB');

      final decoded = Address.publicKeyToAddress(publicKey, NetworkType.TEST_NET);

      expect(decoded[0], equals(NetworkType.TEST_NET));
      expect(Address.isValidAddress(decoded), isTrue);
      expect(HexUtils.getString(decoded).toUpperCase(), equals(expected));
    });

    test('decoded address calculation is deterministic', () {
      final publicKey =
          HexUtils.getBytes('3485D98EFD7EB07ADAFCFD1A157D89DE2796A95E780813C0258AF3F5F84ED8CB');

      final decoded1 = Address.publicKeyToAddress(publicKey, NetworkType.MIJIN);
      final decoded2 = Address.publicKeyToAddress(publicKey, NetworkType.MIJIN);

      expect(Address.isValidAddress(decoded1), isTrue);
      expect(ArrayUtils.deepEqual(decoded1, decoded2), isTrue);
    });

    test('different public keys result in different decoded addresses', () {
      final publicKey1 = KeyPair.randomPublicKey();
      final publicKey2 = KeyPair.randomPublicKey();

      final decoded1 = Address.publicKeyToAddress(publicKey1, NetworkType.MIJIN);
      final decoded2 = Address.publicKeyToAddress(publicKey2, NetworkType.MIJIN);

      expect(Address.isValidAddress(decoded1), isTrue);
      expect(Address.isValidAddress(decoded2), isTrue);
      expect(ArrayUtils.deepEqual(decoded1, decoded2), isFalse);
    });

    test('different newtork types result in different decoded addresses', () {
      final publicKey = KeyPair.randomPublicKey();

      final decoded1 = Address.publicKeyToAddress(publicKey, NetworkType.MIJIN);
      final decoded2 = Address.publicKeyToAddress(publicKey, NetworkType.MIJIN_TEST);
      final decoded3 = Address.publicKeyToAddress(publicKey, NetworkType.MAIN_NET);
      final decoded4 = Address.publicKeyToAddress(publicKey, NetworkType.TEST_NET);

      expect(Address.isValidAddress(decoded1), isTrue);
      expect(Address.isValidAddress(decoded2), isTrue);
      expect(Address.isValidAddress(decoded3), isTrue);
      expect(Address.isValidAddress(decoded4), isTrue);
      expect(ArrayUtils.deepEqual(decoded1, decoded2), isFalse);
      expect(ArrayUtils.deepEqual(decoded1, decoded3), isFalse);
      expect(ArrayUtils.deepEqual(decoded1, decoded4), isFalse);
      expect(ArrayUtils.deepEqual(decoded2, decoded3), isFalse);
      expect(ArrayUtils.deepEqual(decoded2, decoded4), isFalse);
      expect(ArrayUtils.deepEqual(decoded3, decoded4), isFalse);
    });
  });

  group('prettify', () {
    test('can convert an address into a pretty format address', () {
      const validHex = '6823BB7C3C089D996585466380EDBDC19D4959184893E38CA6';
      const expected = 'NAR3W7B4BCOZSZMFIZRYB3N5YGOUSWIYJCJ6HDFG';
      final decoded = HexUtils.getBytes(validHex);

      expect(Address.isValidAddress(decoded), isTrue);
      expect(Address.addressToString(decoded), equals(expected));
      expect(Address.prettify(expected), equals('NAR3W7-B4BCOZ-SZMFIZ-RYB3N5-YGOUSW-IYJCJ6-HDFG'));
    });
  });

  group('isValidAddress', () {
    test('returns true for a valid address', () {
      const validHex = '6823BB7C3C089D996585466380EDBDC19D4959184893E38CA6';
      final decoded = HexUtils.getBytes(validHex);

      expect(Address.isValidAddress(decoded), isTrue);
    });

    test('returns false for an address with invalid checksum', () {
      const validHex = '6823BB7C3C089D996585466380EDBDC19D4959184893E38CA6';
      final decoded = HexUtils.getBytes(validHex);

      // manipulate the checksum to make it invalid
      decoded[Address.ADDRESS_DECODED_SIZE - 1] ^= 0xFF;

      expect(Address.isValidAddress(decoded), isFalse);
    });

    test('returns false for an address with invalid hash', () {
      const validHex = '6823BB7C3C089D996585466380EDBDC19D4959184893E38CA6';
      final decoded = HexUtils.getBytes(validHex);

      // manipulate the ripemd160 hash to make it invalid
      decoded[5] ^= 0xFF;

      expect(Address.isValidAddress(decoded), isFalse);
    });
  });

  group('isValidEncodedAddress', () {
    test('returns true for valid encoded address', () {
      const encoded = 'NAR3W7B4BCOZSZMFIZRYB3N5YGOUSWIYJCJ6HDFG';

      expect(Address.isValidEncodedAddress(encoded), isTrue);
    });

    test('returns false for valid encoded address', () {
      // Change the last character to make this encoded address invalid
      const encoded = 'NAR3W7B4BCOZSZMFIZRYB3N5YGOUSWIYJCJ6HDFH';

      expect(Address.isValidEncodedAddress(encoded), isFalse);
    });

    test('returns false for an encoded address with invalid length', () {
      const encoded = 'NAR3W7B4BCOZSZMFIZRYB3N5YGOUSWIYJCJ6HDFGABC';

      expect(Address.isValidEncodedAddress(encoded), isFalse);
    });

    test('white spaces invalidates the encoded address', () {
      const encoded = 'NAR3W7B4BCOZSZMFIZRYB3N5YGOUSWIYJCJ6HDFGABC';

      expect(Address.isValidEncodedAddress('  \t   $encoded'), isFalse);
      expect(Address.isValidEncodedAddress('$encoded   \t   '), isFalse);
      expect(Address.isValidEncodedAddress('   \t   $encoded   \t   '), isFalse);
    });
  });
}

void assertCannotCreateAddress(final String encodedAddress, final String message) {
  expect(() => Address.stringToAddress(encodedAddress),
      throwsA(predicate((e) => e is ArgumentError && e.message == message)));
}
