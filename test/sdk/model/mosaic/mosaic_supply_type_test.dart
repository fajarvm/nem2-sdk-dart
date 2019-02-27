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

library nem2_sdk_dart.test.sdk.model.mosaic.mosaic_supply_type_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show MosaicSupplyType;

void main() {
  group('MosaicSupplyType', () {
    test('valid mosaic supply types', () {
      expect(MosaicSupplyType.DECREASE, 0);
      expect(MosaicSupplyType.INCREASE, 1);
    });

    test('Can retrieve a valid mosaic supply types', () {
      expect(MosaicSupplyType.getMosaicSupplyType(0), MosaicSupplyType.DECREASE);
      expect(MosaicSupplyType.getMosaicSupplyType(1), MosaicSupplyType.INCREASE);
    });

    test('Trying to retrieve an invalid supply type will throw an error', () {
      expect(
          () => MosaicSupplyType.getMosaicSupplyType(null),
          throwsA(
              predicate((e) => e is ArgumentError && e.message == 'invalid mosaic supply type')));
      expect(
          () => MosaicSupplyType.getMosaicSupplyType(-1),
          throwsA(
              predicate((e) => e is ArgumentError && e.message == 'invalid mosaic supply type')));
      expect(
          () => MosaicSupplyType.getMosaicSupplyType(2),
          throwsA(
              predicate((e) => e is ArgumentError && e.message == 'invalid mosaic supply type')));
    });
  });
}