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

library symbol_sdk_dart.sdk.model.mosaic.network_harvest_local;

import 'dart:math' show pow;

import '../common/id.dart';
import '../common/uint64.dart';
import '../namespace/namespace_id.dart';
import 'mosaic.dart';

/// The NetworkHarvestLocal mosaic.
///
/// This mosaic represents the pre-network harvesting mosaic. The mosaicId of this mosaic is
/// aliased with the namespace name `cat.harvest`.
class NetworkHarvestLocal extends Mosaic {
  /// The namespaceId of this mosaic.
  static final Id NAMESPACE_ID = new NamespaceId(fullName: 'cat.harvest');

  /// The divisibility of this mosaic.
  static const int DIVISIBILITY = 3;

  /// The initial supply of this mosaic.
  static const int INITIAL_SUPPLY = 15000000;

  /// This mosaic is transferable.
  static const bool TRANSFERABLE = true;

  /// The supply of mosaic can be changed (mutable supply).
  static const SUPPLY_MUTABLE = true;

  // private constructor
  NetworkHarvestLocal._(Uint64 amount) : super(NAMESPACE_ID, amount);

  @override
  Id get id => NetworkHarvestLocal.NAMESPACE_ID;

  /// Creates NetworkHarvestLocal with using NetworkHarvestLocal as unit.
  static NetworkHarvestLocal createRelative(final Uint64 amount) {
    return new NetworkHarvestLocal._(
        Uint64.fromBigInt(amount.value * BigInt.from(pow(10, NetworkHarvestLocal.DIVISIBILITY))));
  }

  /// Creates NetworkHarvestLocal with using micro NetworkHarvestLocal as unit.
  ///
  /// 1 NetworkHarvestLocal = 1000000 micro NetworkHarvestLocal.
  static NetworkHarvestLocal createAbsolute(final Uint64 microXemAmount) {
    return new NetworkHarvestLocal._(microXemAmount);
  }
}
