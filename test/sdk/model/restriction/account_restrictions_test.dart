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

library symbol_sdk_dart.test.sdk.model.restriction.account_restrictions_test;

import 'package:symbol_sdk_dart/core.dart' show ArrayUtils;
import 'package:symbol_sdk_dart/sdk.dart'
    show
        AccountRestriction,
        AccountRestrictions,
        Address,
        AccountRestrictionFlags,
        AccountRestrictionModificationAction;
import 'package:test/test.dart';

void main() {
  group('AccountRestrictions', () {
    test('Can create an AccountRestrictions object', () {
      final address = Address.fromEncoded('9050B9837EFAB4BBE8A4B9BB32D812F9885C00D8FC1650E142');
      final restriction = new AccountRestriction(AccountRestrictionFlags.ALLOW_INCOMING_ADDRESS, [
        {
          'modificationType': AccountRestrictionModificationAction.ADD,
          'value': 'SDUP5PLHDXKBX3UU5Q52LAY4WYEKGEWC6IB3VBFM',
        }
      ]);

      // create
      final accountRestrictions = new AccountRestrictions(address, [restriction]);

      // Assert
      expect(accountRestrictions.address, equals(address));
      expect(accountRestrictions.restrictions.length, 1);
      expect(ArrayUtils.deepEqual(accountRestrictions.restrictions, [restriction]), isTrue);
    });
  });
}
