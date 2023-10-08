import 'package:flutter/material.dart';

import 'package:country_picker/country_picker.dart';
import 'package:nets_core/components/form/text_form_input.dart';
import 'package:nets_core/components/widgets/buttons.dart';
import 'package:nets_core/l10n/localizations.dart';

import 'package:nets_core/utils/extensions.dart';

class FBFieldOption {
  FBFieldOption({required this.label, required this.value});
  final Widget label;
  final dynamic value;
}

enum FBFieldTypes {
  text,
  number,
  decimal,
  boolean,
  select,
  date,
  country,
  email,
  password
}

class FBField {
  final String id;
  final String? label;
  final FBFieldTypes type;
  final dynamic initialValue;
  final String? Function(String?)? validate;
  final Widget? icon;
  final String? placeholder;
  final String? helpText;
  final bool optional;
  final int? lines;
  final TextInputType? keyboardType;
  final dynamic maxValue;
  final dynamic minValue;
  final int? maxLength;
  final int? minLength;
  final List<FBFieldOption>? options;
  final bool Function(Map<String, dynamic>)? conditionalBy;
  FBField(
      {required this.id,
      this.label,
      this.type = FBFieldTypes.text,
      this.initialValue,
      this.validate,
      this.icon,
      this.placeholder,
      this.helpText,
      this.maxValue,
      this.minValue,
      this.options,
      this.lines = 1,
      this.optional = false,
      this.maxLength,
      this.minLength,
      this.keyboardType = TextInputType.text,
      this.conditionalBy});
}

enum FBButtonTypes { submit, cancel, delete }

class FBButton {
  const FBButton(
      {required this.label, required this.color, required this.icon});
  final String? label;
  final IconData? icon;
  final Color? color;
}

class FBuilder extends StatefulWidget {
  const FBuilder({
    super.key,
    required this.fields,
    required this.onSubmit,
    required this.onCancel,
    this.submitButton,
    this.cancelButton,
    this.showCancelButton = true,
    this.deleteButton,
    this.title,
    this.locale,
    this.isDense = false,
  });
  final FBButton? submitButton;
  final FBButton? cancelButton;
  final bool showCancelButton;
  final Locale? locale;
  final bool isDense;
  final FBButton? deleteButton;
  final Function() onCancel;
  final Function(Map<String, dynamic> values) onSubmit;
  final String? title;
  final List<FBField> fields;
  @override
  State<FBuilder> createState() => _FBuilderState();
}

class _FBuilderState extends State<FBuilder> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _values = {};

  void updateFieldValue(String id, dynamic value) {
    _values[id] = value;

    setState(() {
      _values = _values;
    });
  }

  @override
  void initState() {
    Map<String, dynamic> initialValues = {};
    for (var field in widget.fields) {
      if (field.type == FBFieldTypes.date && field.initialValue == null) {
        initialValues[field.id] = DateTime.now();
      }
      initialValues[field.id] = field.initialValue;
    }
    setState(() {
      _values = initialValues;
    });
    super.initState();
  }

  Widget buildFieldType(FBField field) {
    var t = NetsCoreLocalizations(
        localeName: Localizations.localeOf(context).toString().split('_')[0]);

    if (field.type == FBFieldTypes.text) {
      return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: FBTextInput(
              label: field.label,
              lines: field.lines,
              initialValue: field.initialValue,
              placeHolder: field.placeholder,
              helpText: field.helpText,
              maxLength: field.maxLength,
              keyboardType: field.keyboardType,
              icon: field.icon,
              isDense: widget.isDense,
              onChange: (String? v) {
                updateFieldValue(field.id, v);
              },
              validate: field.validate ??
                  (String? value) {
                    if (value == null && !field.optional) {
                      return t.translate('requiredField');
                    }
                    if (value!.isEmpty && !field.optional) {
                      return t.translate('requiredField');
                    }
                    if (field.minLength != null &&
                        value.length < field.minLength!) {
                      return t.translate('minLength',
                          args: [field.minLength.toString()]);
                    }
                    return null;
                  }));
    }
    if (field.type == FBFieldTypes.password) {
      return FBTextInput(
        label: field.label,
        lines: field.lines,
        initialValue: field.initialValue,
        placeHolder: field.placeholder,
        helpText: field.helpText,
        icon: field.icon,
        isDense: widget.isDense,
        maxLength: field.maxLength,
        keyboardType: field.keyboardType ?? TextInputType.visiblePassword,
        onChange: (String? v) {
          updateFieldValue(field.id, v);
        },
        validate: field.validate ??
            (String? value) {
              if (value == null && !field.optional) {
                return t.translate('requiredField');
              }
              if (value!.isEmpty && !field.optional) {
                return t.translate('requiredField');
              }
              return null;
            },
        obscureText: true,
      );
    }
    if (field.type == FBFieldTypes.date) {
      return FBDateInput(
          label: field.label,
          initialValue: field.initialValue,
          placeHolder: field.placeholder,
          maxDate: field.maxValue,
          isDense: widget.isDense,
          onChange: (DateTime? s) {
            updateFieldValue(field.id, s);
          },
          icon: field.icon);
    }
    if (field.type == FBFieldTypes.select) {
      return Column(children: [
        DropdownButtonFormField(
            isExpanded: true,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(),
                labelText: field.label!.capitalize,
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(overflow: TextOverflow.ellipsis),
                isDense: widget.isDense,
                icon: field.icon),
            value: _values[field.id],
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            items: field.options!.map((o) {
              return DropdownMenuItem(
                value: o.value,
                child: o.label,
              );
            }).toList(),
            onChanged: (s) {
              updateFieldValue(field.id, s);
            })
      ]);
    }
    if (field.type == FBFieldTypes.country) {
      return FBCountryInput(
        icon: field.icon,
        isDense: widget.isDense,
        onSelect: (Country c) {
          updateFieldValue(field.id, c.countryCode);
        },
        initialValue: field.initialValue,
        label: t.translate('country'),
      );
    }
    if (field.type == FBFieldTypes.email) {
      return FBEmailInput(
        icon: field.icon,
        label: field.label,
        initialValue: field.initialValue,
        helpText: field.helpText,
        isDense: widget.isDense,
        placeHolder: field.placeholder,
        onChange: (String? s) {
          updateFieldValue(field.id, s);
        },
      );
    }
    if (field.type == FBFieldTypes.boolean) {
      return FBBooleanInput(
        label: field.label,
        initialValue: field.initialValue,
        helpText: field.helpText,
        isDense: widget.isDense,
        onChange: (bool s) {
          updateFieldValue(field.id, s);
        },
      );
    }
    if (field.type == FBFieldTypes.decimal) {
      return FBDecimalInput(
        icon: field.icon,
        isDense: widget.isDense,
        label: field.label,
        initialValue: field.initialValue,
        helpText: field.helpText,
        onChange: (String? s) {
          updateFieldValue(field.id, s);
        },
      );
    }
    if (field.type == FBFieldTypes.number) {
      return FBNumberInput(
        label: field.label,
        icon: field.icon,
        initialValue: field.initialValue,
        helpText: field.helpText,
        optional: field.optional,
        max: field.maxValue,
        min: field.minValue,
        isDense: widget.isDense,
        onChange: (String? s) {
          updateFieldValue(field.id, s);
        },
      );
    }
    return Text(t.translate('notImplementedFieldType'));
  }

  Widget buildFields() {
    // ignore: unused_local_variable
    var t = NetsCoreLocalizations(
        localeName: Localizations.localeOf(context).toString().split('_')[0]);
    return Column(
        children: widget.fields.map<Widget>((field) {
      if (field.conditionalBy != null && !field.conditionalBy!(_values)) {
        return const SizedBox.shrink();
      }

      return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: buildFieldType(field));
    }).toList());
  }

  Widget buildButtons() {
    var t = NetsCoreLocalizations(
        localeName: Localizations.localeOf(context).toString().split('_')[0]);
    if (!widget.showCancelButton) {
      return WideButton(
        label: widget.submitButton?.label ?? t.translate('submit'),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            widget.onSubmit(_values);
          }
        },
        icon: Icon(widget.submitButton?.icon ?? Icons.navigate_next_rounded),
        textColor: Theme.of(context).colorScheme.onPrimary,
        color: Theme.of(context).colorScheme.primary,
      );
    }
    return CancelOrSubmitButtons(
      cancelLabel: widget.cancelButton?.label ?? t.translate('cancel'),
      submitLabel: widget.submitButton?.label ?? t.translate('submit'),
      cancelIcon: widget.cancelButton?.icon,
      submitIcon: widget.submitButton?.icon,
      onCancel: () {
        widget.onCancel();
      },
      onSubmit: () {
        if (_formKey.currentState!.validate()) {
          widget.onSubmit(_values);
        }
      },
    );
    // Widget submitButton = WideButton(
    //     label: widget.cancelButton?.label ?? t.submit,
    //     onPressed: () {
    //       if (_formKey.currentState!.validate()) {
    //         widget.onSubmit(_values);
    //       }
    //     },
    //     icon: widget.submitButton?.icon ?? const Icon(Icons.send),
    //     textColor: Theme.of(context).colorScheme.primary,
    //     color: Theme.of(context).colorScheme.onPrimary
    //     // textColor: Colors.white,
    //     );
    // Widget cancelButton = WideButton(
    //   label: widget.cancelButton?.label ?? t.cancel,
    //   onPressed: () {
    //     widget.onCancel();
    //   },
    //   icon: widget.cancelButton?.icon ?? const Icon(Icons.cancel),
    //   color: Theme.of(context).colorScheme.onError,
    //   textColor: Theme.of(context).colorScheme.error,
    // );

    // if (MediaQuery.of(context).size.width > 600) {
    //   return Padding(
    //     padding: const EdgeInsets.all(10),
    //     child:
    //         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    //       SizedBox(
    //           width: MediaQuery.of(context).size.width / 2.5,
    //           child: cancelButton),
    //       SizedBox(
    //           width: MediaQuery.of(context).size.width / 2.5,
    //           child: submitButton)
    //     ]),
    //   );
    // }
    // return Padding(
    //   padding: const EdgeInsets.all(10),
    //   child: Column(children: [
    //     submitButton,
    //     const SizedBox(
    //       height: 20,
    //     ),
    //     cancelButton
    //   ]),
    // );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable

    return Center(
        child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(children: [
                      widget.title != null
                          ? Text(
                              widget.title!,
                              style: Theme.of(context).textTheme.titleSmall,
                            )
                          : const SizedBox.shrink(),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: buildFields(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      buildButtons(),
                    ]))
              ],
            )));
  }
}
