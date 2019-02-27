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

library nem2_sdk_dart.sdk.model.blockchain.block_info;

import '../account/public_account.dart';
import '../transaction/uint64.dart';

/// The block info structure describes basic information of a block.
class BlockInfo {
  /// The hash of this block.
  final String hash;

  /// The generation hash.
  final String generationHash;

  /// The sum of all transaction fees included in this block.
  final Uint64 totalFee;

  /// The number of transactions included in this block.
  final int numTransactions;

  /// The block signature.
  ///
  /// The signature was generated by the signer and can be used to validate
  /// that the blockchain data was not modified by a node.
  final String signature;

  /// The public account of the harvester of this block.
  final PublicAccount signer;

  /// The network type.
  final int networkType;

  /// The transaction version.
  final int version;

  /// The type of this block.
  final int type;

  /// The height of which this block was confirmed.
  ///
  /// Each block has a unique height. Subsequent blocks differ in height by one.
  final Uint64 height;

  /// The number of seconds elapsed since the creation of the nemesis blockchain.
  final Uint64 timestamp;

  /// The Proof-of-Importance difficulty to harvest a block.
  final Uint64 difficulty;

  /// The hash of the previous block.
  final String previousBlockHash;

  /// The block transaction hash.
  final String blockTransactionHash;

  const BlockInfo(
      this.hash,
      this.generationHash,
      this.totalFee,
      this.numTransactions,
      this.signature,
      this.signer,
      this.networkType,
      this.version,
      this.type,
      this.height,
      this.timestamp,
      this.difficulty,
      this.previousBlockHash,
      this.blockTransactionHash);

  @override
  String toString() {
    return 'BlockInfo{'
        'hash= $hash, '
        'generationHash= $generationHash, '
        'totalFee= $totalFee, '
        'numTransactions= $numTransactions, '
        'signature= $signature, '
        'signer= $signer, '
        'networkType= $networkType, '
        'version= $version, '
        'type= $type, '
        'height= $height, '
        'timestamp= $timestamp, '
        'difficulty= $difficulty, '
        'previousBlockHash= $previousBlockHash, '
        'blockTransactionHash= $blockTransactionHash'
        '}';
  }
}
