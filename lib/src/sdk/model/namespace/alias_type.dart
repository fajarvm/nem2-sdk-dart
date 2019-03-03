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

library nem2_sdk_dart.sdk.model.namespace.alias_type;

/// The alias type.
///
/// Supported types are:
/// * 0: No alias.
/// * 1: Mosaic id alias.
/// * 2: Address alias.
class AliasType {
  static const int NONE = 0;

  static const int MOSAIC = 1;

  static const int ADDRESS = 2;

  static final AliasType _singleton = new AliasType._();

  AliasType._();

  factory AliasType() {
    return _singleton;
  }

  static int getAliasType(final int aliasType) {
    switch (aliasType) {
      case NONE:
        return AliasType.NONE;
      case MOSAIC:
        return AliasType.MOSAIC;
      case ADDRESS:
        return AliasType.ADDRESS;
      default:
        throw new ArgumentError('invalid alias type');
    }
  }
}
