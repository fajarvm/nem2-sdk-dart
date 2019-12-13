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

import 'package:test/test.dart';

import 'crypto/catapultnacl_test.dart' as catapultnacl_test;
import 'crypto/crypto_exception_test.dart' as crypto_exception_test;
import 'crypto/key_pair_test.dart' as keypair_test;
import 'crypto/raw_address_test.dart' as raw_address_test;
import 'crypto/sha3_hasher_test.dart' as sha3_hasher_test;
import 'crypto/sign_schema_test.dart' as sign_schema_test;

void main() {
  group('Crypto:', () {
    catapultnacl_test.main();
    crypto_exception_test.main();
    keypair_test.main();
    raw_address_test.main();
    sha3_hasher_test.main();
    sign_schema_test.main();
  });
}
