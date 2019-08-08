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

class AccountInfoDTO {
  AccountMetaDTO meta;

  AccountDTO account;

  AccountInfoDTO();

  @override
  String toString() {
    return 'AccountInfoDTO[meta=$meta, account=$account, ]';
  }

  AccountInfoDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    meta = new AccountMetaDTO.fromJson(json['meta']);
    account = new AccountDTO.fromJson(json['account']);
  }

  Map<String, dynamic> toJson() {
    return {'meta': meta, 'account': account};
  }

  static List<AccountInfoDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <AccountInfoDTO>[]
        : json.map((value) => new AccountInfoDTO.fromJson(value)).toList();
  }

  static Map<String, AccountInfoDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, AccountInfoDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new AccountInfoDTO.fromJson(value));
    }
    return map;
  }
}