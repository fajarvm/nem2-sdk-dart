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

library symbol_sdk_dart.sdk.model.restriction.mosaic_global_restriction_item;

import '../mosaic/mosaic_id.dart';
import 'mosaic_restriction_type.dart';

/// Mosaic global restriction structure describes mosaicId restriction information for a mosaic.
class MosaicGlobalRestrictionItem {
  /// Reference mosaic identifier.
  final MosaicId referenceMosaicId;

  /// The mosaic restriction value.
  final String restrictionValue;

  /// Mosaic restriction type.
  final MosaicRestrictionType restrictionType;

  MosaicGlobalRestrictionItem(this.referenceMosaicId, this.restrictionValue, this.restrictionType);
}
