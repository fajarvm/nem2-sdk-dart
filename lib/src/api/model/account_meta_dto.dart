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

class AccountMetaDTO {
  UInt64DTO height;

  String hash;

  String merkleComponentHash;

  int index;

  String id;

  AccountMetaDTO();

  @override
  String toString() {
    return 'AccountMetaDTO[height=$height, hash=$hash, merkleComponentHash=$merkleComponentHash, index=$index, id=$id, ]';
  }

  AccountMetaDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    height = new UInt64DTO.fromJson(json['height']);
    hash = json['hash'];
    merkleComponentHash = json['merkleComponentHash'];
    index = json['index'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'hash': hash,
      'merkleComponentHash': merkleComponentHash,
      'index': index,
      'id': id
    };
  }

  static List<AccountMetaDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <AccountMetaDTO>[]
        : json.map((value) => new AccountMetaDTO.fromJson(value)).toList();
  }

  static Map<String, AccountMetaDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, AccountMetaDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new AccountMetaDTO.fromJson(value));
    }
    return map;
  }
}