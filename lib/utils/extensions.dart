/// Extensions on [String] providing capitalisation helpers.
extension StringExtension on String {
  /// Returns this string with the first character uppercased.
  String toCapitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  /// Shorthand for [toCapitalize].
  String get capitalize => toCapitalize();

  /// Capitalises the first letter of each space-separated word.
  String capitalizeFirstofEach() {
    return split(' ').map((str) => str.capitalize).join(' ');
  }

  String capitalizeFirstofEachWord() {
    return split(' ').map((str) => str.capitalize).join(' ');
  }

  String capitalizeFirstofEachSentence() {
    return split('.').map((str) => str.capitalize).join('.');
  }

  String capitalizeFirstofEachLine() {
    return split('\n').map((str) => str.capitalize).join('\n');
  }

  String capitalizeFirstofEachParagraph() {
    return split('\n\n').map((str) => str.capitalize).join('\n\n');
  }

  String capitalizeFirstofEachBlock() {
    return split('\n\n').map((str) => str.capitalize).join('\n\n');
  }

  String lowerCaseFirstofEach() {
    return split(' ').map((str) => str.toLowerCase).join(' ');
  }
}
