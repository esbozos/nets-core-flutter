import 'dart:io';

Map<String, Map<String, String>> _localizedValues = {
  'en': {
    'submit': 'Submit',
    'cancel': 'Cancel',
    'ok': 'OK',
    'yes': 'Yes',
    'no': 'No',
    'delete': 'Delete',
    'edit': 'Edit',
    'save': 'Save',
    'close': 'Close',
    'add': 'Add',
    'remove': 'Remove',
    'update': 'Update',
    'create': 'Create',
    'search': 'Search',
    'filter': 'Filter',
    'refresh': 'Refresh',
    'next': 'Next',
    'previous': 'Previous',
    'view': 'View',
    'requiredField': 'Required field',
    'requiredFields': 'Required fields',
    'invalidField': 'Invalid field',
    'invalidEmail': 'Invalid email',
    'invalidPhone': 'Invalid phone',
    'invalidNumber': 'Invalid number',
    'invalidDate': 'Invalid date',
    'optionalField': 'Optional field',
    'select': 'Select',
    'selectOption': 'Select an option',
    'selectOptions': 'Select options',
    'country': 'Country',
    'notImplementedFieldType': 'Not implemented field type',
    'picturePreview': 'Picture preview',
    'retakePicture': 'Retake picture',
    'continueNext': 'Continue',
    'loading': 'Loading...',
    'minLength': 'Min length is {0}',
    'numberIsRequired': 'Number is required',
    'numberShouldBeInteger': 'Number should be integer',
    'numberShouldBePositive': 'Number should be positive',
    'numberShouldBeLessThan': 'Number should be less than {0}',
    'numberShouldBeGreaterThan': 'Number should be greater than {0}',
  }
};

class NetsCoreLocalizations {
  final String? localeName;

  NetsCoreLocalizations({this.localeName});
  String translate(String key, {List<String>? args}) {
    String localeName = this.localeName ?? Platform.localeName.split('_')[0];

    if (!_localizedValues.containsKey(localeName) ||
        _localizedValues[localeName]!.isEmpty ||
        !_localizedValues[localeName]!.containsKey(key) ||
        _localizedValues[localeName] == null) {
      return key;
    } else {
      String translation = _localizedValues[localeName]![key]!;
      if (args != null) {
        for (int i = 0; i < args.length; i++) {
          translation = translation.replaceAll('{$i}', args[i]);
        }
      } else {
        // Remove all placeholders
        translation = translation.replaceAll(RegExp(r'\{\d+\}'), '');
      }
      return translation;
    }
  }
}
