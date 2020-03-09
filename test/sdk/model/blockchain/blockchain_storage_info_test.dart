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

library symbol_sdk_dart.test.sdk.model.blockchain.blockchain_storage_info_test;

import 'package:symbol_sdk_dart/sdk.dart' show BlockchainStorageInfo;
import 'package:test/test.dart';

void main() {
  group('BlockchainStorageInfo', () {
    test('Can create a BlockchainStorageInfo object', () {
      final blockchainStorageInfo = BlockchainStorageInfo(1, 2, 3);

      expect(blockchainStorageInfo.numBlocks, 1);
      expect(blockchainStorageInfo.numTransactions, 2);
      expect(blockchainStorageInfo.numAccounts, 3);

      expect(
          blockchainStorageInfo.toString(),
          equals('BlockchainStorageInfo{'
              'numBlocks: ${blockchainStorageInfo.numBlocks}, '
              'numTransactions: ${blockchainStorageInfo.numTransactions}, '
              'numAccounts: ${blockchainStorageInfo.numAccounts}'
              '}'));
    });
  });
}
