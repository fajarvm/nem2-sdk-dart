library nem2_sdk_dart.sdk.model.account.address;

import 'dart:typed_data' show Uint8List;

import 'package:pointycastle/export.dart' show RIPEMD160Digest;

import 'package:nem2_sdk_dart/src/core/crypto.dart' show Ed25519, SHA3DigestNist;
import 'package:nem2_sdk_dart/src/core/utils.dart' show ArrayUtils, Base32, HexUtils;

import '../blockchain/network_type.dart';

/// The address structure describes an address with its network.
class Address {
  static const int RIPEMD_160_SIZE = 20;
  static const int ADDRESS_DECODED_SIZE = 25;
  static const int ADDRESS_ENCODED_SIZE = 40;
  static const int KEY_SIZE = 32;
  static const int CHECKSUM_SIZE = 4;

  static const String PREFIX_MIJIN_TEST = 'S';
  static const String PREFIX_MIJIN = 'M';
  static const String PREFIX_TEST_NET = 'T';
  static const String PREFIX_MAIN_NET = 'N';
  static const String EMPTY_STRING = '';

  static final RegExp REGEX_DASH = new RegExp(r'-');
  static final RegExp REGEX_PRETTY = new RegExp('.{1,6}');

  final int _networkType;
  final String _address;

  Address._(this._address, this._networkType);

  factory Address({final String address = null, final int networkType = null}) {
    if (address == null || networkType == null) {
      throw new ArgumentError('Address string and/or Network type must not be null');
    }

    if (!NetworkType.isValidNetworkType(networkType)) {
      throw new ArgumentError('Network type unsupported');
    }

    return new Address._(address, networkType);
  }

  /// Get the address in plain format.
  ///
  /// For example: SB3KUBHATFCPV7UZQLWAQ2EUR6SIHBSBEOEDDDF3.
  String plain() {
    return this._address;
  }

  /// Get address in pretty format.
  ///
  /// For example: SB3KUB-HATFCP-V7UZQL-WAQ2EU-R6SIHB-SBEOED-DDF3.
  String pretty() {
    return prettify(this._address);
  }

  int get networkType => _networkType;

  @override
  bool operator ==(other) {
    return other is Address &&
        this.plain() == other.plain() &&
        this.networkType == other.networkType;
  }

  @override
  int get hashCode {
    return this.plain().hashCode + this.networkType.hashCode;
  }

  /// Converts a [decodedAddress] to an encoded address [String].
  static String addressToString(final Uint8List decodedAddress) {
    final String hexStringAddress = HexUtils.getString(decodedAddress);
    if (ADDRESS_DECODED_SIZE != decodedAddress.length) {
      throw ArgumentError(
          "The Address ${hexStringAddress} does not represent a valid decoded address");
    }

    return Base32.encode(decodedAddress);
  }

  /// Converts a [publicKey] to decoded address byte for a specific [networkType].
  static Uint8List publicKeyToAddress(final Uint8List publicKey, final int networkType) {
    // Step 1: create a SHA3-256 hash of the public key
    final SHA3DigestNist sha3Digest = Ed25519.createSha3Hasher(length: Ed25519.KEY_SIZE);
    Uint8List stepOne = new Uint8List(KEY_SIZE);
    sha3Digest.update(publicKey, 0, KEY_SIZE);
    sha3Digest.doFinal(stepOne, 0);

    // Step 2: perform a RIPEMD160 on previous step
    final RIPEMD160Digest rm160Digest = new RIPEMD160Digest();
    Uint8List stepTwo = new Uint8List(RIPEMD_160_SIZE);
    rm160Digest.update(stepOne, 0, KEY_SIZE);
    rm160Digest.doFinal(stepTwo, 0);

    // Step 3: prepend network type
    Uint8List decodedAddress = new Uint8List(ADDRESS_DECODED_SIZE);
    decodedAddress[0] = networkType;
    ArrayUtils.copy(decodedAddress, stepTwo, numElementsToCopy: RIPEMD_160_SIZE, destOffset: 1);

    // Step 4: perform SHA3-256 on previous step
    Uint8List stepFour = new Uint8List(KEY_SIZE);
    int rm160Length = RIPEMD_160_SIZE + 1;
    sha3Digest.update(decodedAddress, 0, rm160Length);
    sha3Digest.doFinal(stepFour, 0);

    // Step 5: retrieve checksum
    Uint8List stepFive = new Uint8List(CHECKSUM_SIZE);
    ArrayUtils.copy(stepFive, stepFour, numElementsToCopy: CHECKSUM_SIZE);

    // Step 6: append stepFive to result of stepThree
    Uint8List stepSix = new Uint8List(ADDRESS_DECODED_SIZE);
    ArrayUtils.copy(stepSix, decodedAddress, numElementsToCopy: rm160Length);
    ArrayUtils.copy(stepSix, stepFive, numElementsToCopy: CHECKSUM_SIZE, destOffset: rm160Length);

    // Step 7: return base 32 encoded address
    // String base32EncodedAddress = Base32.encode(stepSix);

    return stepSix;
  }

  /// Creates an [Address] from a given [publicKey] string for the given [networkType].
  static Address createFromPublicKey(final String publicKey, final int networkType) {
    final Uint8List publicKeyByte = HexUtils.getBytes(publicKey);
    final Uint8List addressByte = publicKeyToAddress(publicKeyByte, networkType);
    final String addressString = addressToString(addressByte);
    return new Address(address: addressString, networkType: networkType);
  }

  /// Creates an [Address] from a given string of [rawAddress].
  static Address createFromRawAddress(final String rawAddress) {
    final String address = rawAddress.trim().toUpperCase().replaceAll(REGEX_DASH, EMPTY_STRING);

    if (address.length != ADDRESS_ENCODED_SIZE) {
      throw new ArgumentError(
          'Address ${address} has to be ${ADDRESS_ENCODED_SIZE} characters long');
    }

    switch (address[0]) {
      case PREFIX_MIJIN_TEST:
        return new Address(address: address, networkType: NetworkType.MIJIN_TEST);
      case PREFIX_MIJIN:
        return new Address(address: address, networkType: NetworkType.MIJIN);
      case PREFIX_TEST_NET:
        return new Address(address: address, networkType: NetworkType.TEST_NET);
      case PREFIX_MAIN_NET:
        return new Address(address: address, networkType: NetworkType.MAIN_NET);
      default:
        throw new UnsupportedError('Address Network unsupported');
    }
  }

  /// Converts an [address] String into a more readable/pretty format.
  ///
  /// Before: B3KUBHATFCPV7UZQLWAQ2EUR6SIHBSBEOEDDDF3
  /// After: SB3KUB-HATFCP-V7UZQL-WAQ2EU-R6SIHB-SBEOED-DDF3
  static String prettify(final String address) {
    if (address.length != ADDRESS_ENCODED_SIZE) {
      throw new ArgumentError(
          'Address ${address} has to be ${ADDRESS_ENCODED_SIZE} characters long');
    }

    final StringBuffer sb = new StringBuffer();
    final Iterable<Match> matches = REGEX_PRETTY.allMatches(address);
    final String last = matches.last.group(0);

    for (var match in matches) {
      final String current = match.group(0);
      sb.write(current);
      if (current != last) {
        sb.write("-");
      }
    }

    return sb.toString();
  }
}
