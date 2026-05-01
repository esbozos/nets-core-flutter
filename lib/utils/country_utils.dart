import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

/// Returns the emoji flag for the given two-letter ISO 3166-1 [countryCode].
///
/// Example: `emojiFlag('US')` → 🇺🇸
String emojiFlag(String countryCode) {
  assert(countryCode.length == 2);
  final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
  final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
  return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
}

/// Returns the localised country name for the given two-letter [countryCode]
/// using the [CountryLocalizations] from the current [context].
String countryName(BuildContext context, String countryCode) {
  var cL = CountryLocalizations.of(context);
  var country = cL!.countryName(countryCode: countryCode);
  return country!;
}
