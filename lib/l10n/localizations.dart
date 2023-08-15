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
    'optionalField': 'Optional field',
    'select': 'Select',
    'selectOption': 'Select an option',
    'selectOptions': 'Select options',
    'country': 'Country',
    'notImplementedFieldType': 'Not implemented field type',
    'picturePreview': 'Picture preview',
    'retakePicture': 'Retake picture',
    'continueNext': 'Continue',
  }
};

class NetsCoreLocalizations {
  final String? localeName;

  NetsCoreLocalizations({this.localeName});
  String translate(String key) {
    String _localeName = localeName ?? Platform.localeName.split('_')[0];

    if (!_localizedValues.containsKey(_localeName) ||
        _localizedValues[_localeName]!.isEmpty ||
        !_localizedValues[_localeName]!.containsKey(key) ||
        _localizedValues[_localeName] == null) {
      return key;
    } else {
      return _localizedValues[localeName]![key]!;
    }
  }
}
