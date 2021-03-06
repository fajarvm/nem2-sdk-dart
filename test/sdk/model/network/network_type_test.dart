//
// Copyright (c) 2020 Fajar van Megen
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

library symbol_sdk_dart.test.sdk.model.network.network_type_test;

import 'package:symbol_sdk_dart/sdk.dart' show NetworkType;
import 'package:test/test.dart';

void main() {
  group('NetworkType', () {
    test('Valid network types', () {
      // Main net
      expect(NetworkType.MAIN_NET.value, 0x68);
      expect(NetworkType.MAIN_NET.value, 104);
      // Test net
      expect(NetworkType.TEST_NET.value, 0x98);
      expect(NetworkType.TEST_NET.value, 152);
      // Mijin main net
      expect(NetworkType.MIJIN.value, 0x60);
      expect(NetworkType.MIJIN.value, 96);
      // Mijin test net
      expect(NetworkType.MIJIN_TEST.value, 0x90);
      expect(NetworkType.MIJIN_TEST.value, 144);

      expect(NetworkType.MAIN_NET.toString(),
          equals('NetworkType{value: ${NetworkType.MAIN_NET.value}}'));
    });

    test('Can retrieve a valid network type', () {
      expect(NetworkType.fromInt(0x68), NetworkType.MAIN_NET);
      expect(NetworkType.fromInt(104), NetworkType.MAIN_NET);
      expect(NetworkType.fromInt(0x98), NetworkType.TEST_NET);
      expect(NetworkType.fromInt(152), NetworkType.TEST_NET);
      expect(NetworkType.fromInt(0x60), NetworkType.MIJIN);
      expect(NetworkType.fromInt(96), NetworkType.MIJIN);
      expect(NetworkType.fromInt(0x90), NetworkType.MIJIN_TEST);
      expect(NetworkType.fromInt(144), NetworkType.MIJIN_TEST);
    });

    test('Invalid or unknown network type should throw an error', () {
      String errorMessage = NetworkType.UNKNOWN_NETWORK_TYPE;
      expect(() => NetworkType.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => NetworkType.fromInt(0),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => NetworkType.fromInt(103),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });

    test('Can identify that a network tye is valid/supported', () {
      expect(NetworkType.isValid(NetworkType.MAIN_NET), isTrue);
      expect(NetworkType.isValidValue(0x68), isTrue);
      expect(NetworkType.isValidValue(104), isTrue);
      expect(NetworkType.isValid(NetworkType.TEST_NET), isTrue);
      expect(NetworkType.isValidValue(0x98), isTrue);
      expect(NetworkType.isValidValue(152), isTrue);
      expect(NetworkType.isValid(NetworkType.MIJIN), isTrue);
      expect(NetworkType.isValidValue(0x60), isTrue);
      expect(NetworkType.isValidValue(96), isTrue);
      expect(NetworkType.isValid(NetworkType.MIJIN_TEST), isTrue);
      expect(NetworkType.isValidValue(0x90), isTrue);
      expect(NetworkType.isValidValue(144), isTrue);
    });

    test('Can identify that a network tye is invalid or is unknown', () {
      expect(NetworkType.isValidValue(0), isFalse);
      expect(NetworkType.isValidValue(0x00), isFalse);
      expect(NetworkType.isValidValue(0xFF), isFalse);
      expect(NetworkType.isValidValue(103), isFalse);
    });
  });
}
