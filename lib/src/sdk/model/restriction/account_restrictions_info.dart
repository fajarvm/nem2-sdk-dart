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

library symbol_sdk_dart.sdk.model.restriction.account_restrictions_info;

import 'account_restrictions.dart';

/// Describes restriction information for an account.
class AccountRestrictionsInfo {
  /// The meta.
  final String meta;

  /// The account properties.
  final AccountRestrictions accountRestrictions;

  AccountRestrictionsInfo(this.meta, this.accountRestrictions);
}
