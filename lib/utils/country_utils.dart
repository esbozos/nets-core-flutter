import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

String EmojiFlag(String countryCode) {
  assert(countryCode.length == 2);
  final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
  final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
  return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
}

String CountryName(BuildContext context, String countryCode) {
  var cL = CountryLocalizations.of(context);
  var country = cL!.countryName(countryCode: countryCode);
  return country!;
}
