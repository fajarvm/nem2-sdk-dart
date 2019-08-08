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

part of nem2_sdk_dart.sdk.api.model;

class BlockDTO {
  /* Signature of the block generated by the signer. It can be used to validate tha the entity data was not modified by a node.  */
  String signature;

/* Public key of the signer account. */
  String signer;

  NetworkTypeEnum version;

/* Type of the block: * 0x8043 (32835 decimal) - Nemesis block. * 0x8143 (33091 decimal) - Regular block.  */
  int type;

  UInt64DTO height;

  UInt64DTO timestamp;

  UInt64DTO difficulty;

/* Fee multiplier applied to transactions contained in block. */
  int feeMultiplier;

/* Hash of the previous block. */
  String previousBlockHash;

/* Transactions included in a block are hashed forming a merkle tree. The root of the tree summarizes them.  */
  String blockTransactionsHash;

/* Collection of receipts  are hashed into a merkle tree and linked to a block. The block header stores the root hash.  */
  String blockReceiptsHash;

/* For each block, the state of the blockchain is stored in RocksDB, forming a patricia tree. The root of the tree summarizes the state of the blockchain for the given block.  */
  String stateHash;

/* Public key of the optional beneficiary designated by harvester. */
  String beneficiary;

  BlockDTO();

  @override
  String toString() {
    return 'BlockDTO[signature=$signature, signer=$signer, version=$version, type=$type, height=$height, timestamp=$timestamp, difficulty=$difficulty, feeMultiplier=$feeMultiplier, previousBlockHash=$previousBlockHash, blockTransactionsHash=$blockTransactionsHash, blockReceiptsHash=$blockReceiptsHash, stateHash=$stateHash, beneficiary=$beneficiary, ]';
  }

  BlockDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    signature = json['signature'];
    signer = json['signer'];
    version = new NetworkTypeEnum.fromJson(json['version']);
    type = json['type'];
    height = new UInt64DTO.fromJson(json['height']);
    timestamp = new UInt64DTO.fromJson(json['timestamp']);
    difficulty = new UInt64DTO.fromJson(json['difficulty']);
    feeMultiplier = json['feeMultiplier'];
    previousBlockHash = json['previousBlockHash'];
    blockTransactionsHash = json['blockTransactionsHash'];
    blockReceiptsHash = json['blockReceiptsHash'];
    stateHash = json['stateHash'];
    beneficiary = json['beneficiary'];
  }

  Map<String, dynamic> toJson() {
    return {
      'signature': signature,
      'signer': signer,
      'version': version,
      'type': type,
      'height': height,
      'timestamp': timestamp,
      'difficulty': difficulty,
      'feeMultiplier': feeMultiplier,
      'previousBlockHash': previousBlockHash,
      'blockTransactionsHash': blockTransactionsHash,
      'blockReceiptsHash': blockReceiptsHash,
      'stateHash': stateHash,
      'beneficiary': beneficiary
    };
  }

  static List<BlockDTO> listFromJson(List<dynamic> json) {
    return json == null ? <BlockDTO>[] : json.map((value) => new BlockDTO.fromJson(value)).toList();
  }

  static Map<String, BlockDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, BlockDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new BlockDTO.fromJson(value));
    }
    return map;
  }
}