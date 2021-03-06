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

library symbol_sdk_dart.sdk.model.transaction.signed_transaction;

import 'package:symbol_sdk_dart/sdk.dart';

/// Used to transfer the transaction data and the signature to a Symbol server in order to
/// initiate and broadcast a transaction.
class SignedTransaction {
  /// The serialized transaction data.
  final String payload;

  /// The transaction hash.
  final String hash;

  /// The transaction signer.
  final String signer;

  /// The transaction type.
  final TransactionType type;

  /// The signer network type.
  final NetworkType networkType;

  SignedTransaction._(this.payload, this.hash, this.signer, this.type, this.networkType);

  factory SignedTransaction(final String payload, final String hash, final String signer,
      final TransactionType type, final NetworkType networkType) {
    if (hash == null || hash.length != 64) {
      throw new ArgumentError('Invalid hash size. The hash must be 64 characters long.');
    }

    return new SignedTransaction._(payload, hash, signer, type, networkType);
  }
}
