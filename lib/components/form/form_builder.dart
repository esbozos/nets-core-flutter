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
  time,
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
  final Widget? expandedHelp;
  final bool optional;
  final int? lines;
  final TextInputType? keyboardType;
  final dynamic maxValue;
  final dynamic minValue;
  final int? maxLength;
  final int? minLength;
  final List<FBFieldOption>? options;
  final bool Function(Map<String, dynamic>)? conditionalBy;
  final bool disabled;
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
      this.expandedHelp,
      this.keyboardType = TextInputType.text,
      this.disabled = false,
      this.conditionalBy});
}

enum FBButtonTypes { submit, cancel, delete }

class FBButton {
  const FBButton(
      {required this.label,
      required this.color,
      required this.icon,
      this.textColor});
  final String? label;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
}

class FBuilder extends StatefulWidget {
  const FBuilder({
    super.key,
    required this.fields,
    required this.onSubmit,
    this.onChanged,
    required this.onCancel,
    this.submitButton,
    this.cancelButton,
    this.showCancelButton = true,
    this.showSubmitButton = true,
    this.showDeleteButton = false,
    this.deleteButton,
    this.title,
    this.locale,
    this.isDense = false,
    this.inputDecoration,
    this.disabled = false,
  });
  final FBButton? submitButton;
  final FBButton? cancelButton;
  final bool showCancelButton;
  final Locale? locale;
  final bool isDense;
  final FBButton? deleteButton;
  final bool showSubmitButton;
  final bool showDeleteButton;

  final Function() onCancel;
  final Function(Map<String, dynamic> values) onSubmit;
  final Function(Map<String, dynamic> values)? onChanged;
  final String? title;
  final List<FBField> fields;
  final InputDecoration? inputDecoration;
  final bool disabled;
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
    if (widget.onChanged != null) {
      widget.onChanged!(_values);
    }
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
    InputDecoration inputDecoration = widget.inputDecoration ??
        InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red)),
            errorStyle: const TextStyle(color: Colors.red),
            contentPadding: const EdgeInsets.all(10));
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
              decoration: inputDecoration,
              disabled: field.disabled,
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
        decoration: inputDecoration,
        disabled: field.disabled,
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
        decoration: inputDecoration,
        disabled: field.disabled,
        minDate: field.minValue,
        onChange: (DateTime? s) {
          updateFieldValue(field.id, s);
        },
        icon: field.icon,
      );
    }
    if (field.type == FBFieldTypes.time) {
      return FBTimeInput(
          label: field.label,
          initialValue: field.initialValue,
          placeHolder: field.placeholder,
          isDense: widget.isDense,
          decoration: inputDecoration,
          disabled: field.disabled,
          onChange: (TimeOfDay? s) {
            updateFieldValue(field.id, s);
          },
          icon: field.icon);
    }
    if (field.type == FBFieldTypes.select) {
      return Column(children: [
        DropdownButtonFormField(
          validator: (value) {
            if (field.optional) {
              return null;
            }
            if (field.validate != null) {
              return field.validate!(value?.toString());
            }
            if (value == null && !field.optional) {
              return t.translate('requiredField');
            }
            return null;
          },
          isExpanded: true,
          decoration: inputDecoration.copyWith(
                enabledBorder: const UnderlineInputBorder(),
                labelText: field.label!.capitalize,
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(overflow: TextOverflow.ellipsis),
                isDense: widget.isDense,
                icon: field.icon),
            initialValue: _values[field.id],
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            items: field.options!.map((o) {
              return DropdownMenuItem(
                value: o.value,
                child: o.label,
              );
            }).toList(),
            onChanged: field.disabled
                ? null
                : (dynamic s) {
                    updateFieldValue(field.id, s);
                  }),
      ]);
    }
    if (field.type == FBFieldTypes.country) {
      return FBCountryInput(
        icon: field.icon,
        isDense: widget.isDense,
        disabled: field.disabled,
        onSelect: (Country c) {
          updateFieldValue(field.id, c.countryCode);
        },
        decoration: inputDecoration,
        initialValue: field.initialValue,
        label: t.translate('country'),
      );
    }
    if (field.type == FBFieldTypes.email) {
      return FBEmailInput(
        icon: field.icon,
        label: field.label,
        initialValue: field.initialValue,
        disabled: field.disabled,
        helpText: field.helpText,
        isDense: widget.isDense,
        placeHolder: field.placeholder,
        decoration: inputDecoration,
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
        disabled: field.disabled,
        decoration: inputDecoration,
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
          max: field.maxValue,
          min: field.minValue,
          disabled: field.disabled,
          decoration: inputDecoration,
          onChange: (String? s) {
            updateFieldValue(field.id, s);
          },
          validate: field.validate);
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
        disabled: field.disabled,
        decoration: inputDecoration,
        onChange: (String? s) {
          updateFieldValue(field.id, s);
        },
        validate: field.validate,
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

      if (field.expandedHelp != null) {
        // show trailing icon two show expandedHelp in modalBottomSheet
        // in a row with the field
        return Row(
          children: [
            Expanded(child: buildFieldType(field)),
            IconButton(
              icon: const Icon(Icons.info_outline_rounded),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              field.expandedHelp!,
                              const SizedBox(
                                height: 20,
                              ),
                              WideButton(
                                label: t.translate('close'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.close_rounded),
                                textColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            ],
                          ));
                    });
              },
            )
          ],
        );
      }
      return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: buildFieldType(field));
    }).toList());
  }

  Widget buildButtons() {
    if (!widget.showSubmitButton && !widget.showCancelButton) {
      return const SizedBox.shrink();
    }
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
      cancelColor: widget.cancelButton?.color,
      submitColor: widget.submitButton?.color,
      cancelIcon: widget.cancelButton?.icon,
      submitIcon: widget.submitButton?.icon,
      cancelTextColor: widget.cancelButton?.textColor,
      submitTextColor: widget.submitButton?.textColor,
      onCancel: () {
        widget.onCancel();
      },
      onSubmit: () {
        if (_formKey.currentState!.validate()) {
          widget.onSubmit(_values);
        }
      },
    );
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
