import 'package:country_picker/country_picker.dart';

import 'package:flutter/material.dart';
// ignore: unused_import

import 'package:flutter/cupertino.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
// import 'package:nets_core/providers/auth_provider.dart';

// ignore: implementation_imports
import 'package:country_picker/src/res/country_codes.dart';
import 'package:collection/collection.dart';
import 'package:nets_core/utils/extensions.dart';

class FBTextInput extends StatefulWidget {
  const FBTextInput(
      {super.key,
      this.label,
      this.initialValue,
      this.placeHolder,
      this.onChange,
      this.onTap,
      this.lines = 1,
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.helpText,
      this.maxLength,
      this.validate});
  final String? label;
  final String? initialValue;
  final String? placeHolder;
  final int? lines;
  final bool obscureText;
  final void Function()? onTap;
  final void Function(String?)? onChange;
  final String? Function(String?)? validate;
  final String? helpText;
  final int? maxLength;
  final TextInputType? keyboardType;

  @override
  State<FBTextInput> createState() => _FBTextInputState();
}

class _FBTextInputState extends State<FBTextInput> {
  final TextEditingController _value = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool focused = false;
  void handleValueChange() {
    if (widget.onChange != null) widget.onChange!(_value.text);
  }

  @override
  void initState() {
    if (widget.initialValue != null) {
      _value.text = widget.initialValue!;
    }
    _value.addListener(handleValueChange);

    super.initState();
    focusNode.addListener(() {
      focused = focusNode.hasFocus;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      minLines: widget.lines,
      maxLines: widget.lines,
      controller: _value,
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(),
        labelText: widget.label!.capitalize,
        hintText: widget.placeHolder,
        helperText: focused ? widget.helpText : null,
        helperMaxLines: 2,
        // border: const UnderlineInputBorder()
      ),
      validator: widget.validate,
      onTap: widget.onTap,
      obscureText: widget.obscureText,
      maxLength: widget.maxLength,
    );
  }
}

class FBDateInput extends StatefulHookConsumerWidget {
  const FBDateInput(
      {super.key,
      this.maxDate,
      this.minDate,
      this.minAge,
      this.maxAge,
      this.label,
      this.initialValue,
      this.placeHolder,
      this.onChange,
      this.onTap});
  final String? label;
  final String? placeHolder;
  final void Function()? onTap;
  final DateTime? maxDate;
  final DateTime? minDate;
  final int? minAge;
  final int? maxAge;
  final DateTime? initialValue;
  final void Function(DateTime?)? onChange;

  @override
  ConsumerState<FBDateInput> createState() => _FBDateInputState();
}

class _FBDateInputState extends ConsumerState<FBDateInput> {
  final TextEditingController _value = TextEditingController();
  DateTime? _dateValue = DateTime.now();
  DateTime _minDate = DateTime(1900);
  DateTime _maxDate = DateTime.now();

  String formatDate(DateTime d) {
    // var user = ref.read(authProvider);
    // Auth user = Provider.of<Auth>(context, listen: false);

    return DateFormat.yMd().format(d);
  }

  void handleValueChange() {
    if (widget.onChange != null) widget.onChange!(_dateValue);
  }

  @override
  void initState() {
    //
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialValue != null) {
        _value.text = formatDate(widget.initialValue!);
        _dateValue = widget.initialValue!;
      }
      if (widget.minDate != null) {
        _minDate = widget.minDate!;
      }
      if (widget.maxDate != null) {
        _maxDate = widget.maxDate!;
      }
      if (widget.maxAge != null) {
        _minDate = Jiffy.now().subtract(years: widget.maxAge!).dateTime;
      }
      if (widget.minAge != null) {
        _maxDate = Jiffy.now().subtract(years: widget.minAge!).dateTime;
      }
      _value.addListener(handleValueChange);
    });
    // if (widget.initialValue != null) {
    //   _value.text = formatDate(widget.initialValue!);
    //   _dateValue = widget.initialValue!;
    // }
    // if (widget.minDate != null) {
    //   _minDate = widget.minDate!;
    // }
    // if (widget.maxDate != null) {
    //   _maxDate = widget.maxDate!;
    // }
    // if (widget.maxAge != null) {
    //   _minDate = Jiffy.now().subtract(years: widget.maxAge!).dateTime;
    // }
    // if (widget.minAge != null) {
    //   _maxDate = Jiffy.now().subtract(years: widget.minAge!).dateTime;
    // }
    // _value.addListener(handleValueChange);
    super.initState();
  }

  void handleChange(newDate) {
    setState(() {
      _dateValue = newDate;
      _value.text = formatDate(newDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: _dateValue != null &&
                    _dateValue!.isBefore(_maxDate) &&
                    _dateValue!.isAfter(_minDate)
                ? _dateValue!
                : _maxDate,
            firstDate: _minDate,
            lastDate: _maxDate,
          );
          if (selectedDate != null) {
            handleChange(selectedDate);
          }
        },
        child: TextFormField(
          controller: _value,
          decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(),
              labelText: widget.label,
              hintText: widget.placeHolder),
          enabled: false,
          onTap: () {
            // _showDialog(Column(children: [
            //   SizedBox(
            //       height: 200,
            //       child: CupertinoDatePicker(
            //         initialDateTime: _dateValue ?? DateTime.now(),
            //         mode: CupertinoDatePickerMode.date,
            //         use24hFormat: true,
            //         // This is called when the user changes the date.
            //         onDateTimeChanged: (DateTime newDate) {
            //           handleChange(newDate);
            //         },
            //         maximumDate: _maxDate,
            //         minimumDate: _minDate,
            //       )),
            //   CupertinoButton(
            //       alignment: Alignment.bottomRight,
            //       child: Text(t.done),
            //       onPressed: () {
            //         context.pop();
            //       })
            // ]));
          },
        ));
  }

  // ignore: unused_element
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 280,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(top: false, child: child),
      ),
    );
  }
}

class FBCountryInput extends StatefulWidget {
  const FBCountryInput(
      {super.key,
      required this.onSelect,
      this.label,
      this.exclude,
      this.placeHolder,
      this.initialValue});
  final List<String>? exclude;
  final void Function(Country) onSelect;
  final String? initialValue;
  final String? label;
  final String? placeHolder;

  @override
  State<FBCountryInput> createState() => _FBCountryInput();
}

class _FBCountryInput extends State<FBCountryInput> {
  final TextEditingController _value = TextEditingController();
  Country? _country;

  void handleValueChange() {}

  void updateValue() async {
    if (_country == null) return;
    try {
      _value.text = _country!.nameLocalized ?? _country!.name;
    } catch (e) {
      _value.text = _country!.name;
    }
  }

  @override
  void initState() {
    if (widget.initialValue != null) {
      Map<String, dynamic>? countryJson = countryCodes.firstWhereOrNull(
          (element) => element["iso2_cc"] == widget.initialValue);

      if (countryJson != null) {
        _country = Country.from(json: countryJson);
        updateValue();
      }
    }
    _value.addListener(handleValueChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _value,
      decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(),
          labelText: widget.label!.capitalize,
          hintText: widget.placeHolder),
      onTap: () {
        showCountryPicker(
            context: context,
            useSafeArea: true,
            onSelect: (Country c) {
              setState(
                () {
                  _value.text = c.nameLocalized ?? c.name;
                  _country = c;
                },
              );
              widget.onSelect(c);
            });
      },
    );
  }
}

class FBEmailInput extends StatefulWidget {
  const FBEmailInput({
    super.key,
    required this.onChange,
    this.label,
    this.placeHolder,
    this.initialValue,
  });
  final String? label;
  final String? placeHolder;
  final String? initialValue;
  final void Function(String?)? onChange;

  @override
  State<FBEmailInput> createState() => _FBEmailInputState();
}

class _FBEmailInputState extends State<FBEmailInput> {
  final TextEditingController _value = TextEditingController();

  void handleValueChange() {
    if (widget.onChange != null) widget.onChange!(_value.text);
  }

  @override
  void initState() {
    if (widget.initialValue != null) {
      _value.text = widget.initialValue!;
    }
    _value.addListener(handleValueChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _value,
      decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(),
          labelText: widget.label!.capitalize,
          hintText: widget.placeHolder),
      validator: (String? value) {
        if (value == null) return 'Please enter some text';
        // check if value match email pattern
        if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return 'Please enter a valid email';
        }

        return null;
      },
    );
  }
}

class FBBooleanInput extends StatefulWidget {
  const FBBooleanInput({
    super.key,
    required this.onChange,
    this.label,
    this.placeHolder,
    this.helpText,
    this.initialValue,
  });
  final String? label;
  final String? placeHolder;
  final bool? initialValue;
  final String? helpText;
  final void Function(bool) onChange;

  @override
  State<FBBooleanInput> createState() => _FBBooleanInputState();
}

class _FBBooleanInputState extends State<FBBooleanInput> {
  bool _value = false;

  @override
  void initState() {
    if (widget.initialValue != null) {
      _value = widget.initialValue!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return switch

    return Row(children: [
      Switch(
          value: _value,
          onChanged: (bool? v) {
            setState(() {
              _value = v ?? false;
            });
            widget.onChange(v ?? false);
          }),
      const SizedBox(width: 10),
      Text(widget.label!.capitalize),
      if (widget.helpText != null)
        Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                message: widget.helpText!,
                child: Icon(Icons.help_outline,
                    size: Theme.of(context).textTheme.bodySmall!.fontSize)))
    ]);
  }
}

class FBDecimalInput extends StatefulWidget {
  const FBDecimalInput({
    super.key,
    required this.onChange,
    this.label,
    this.placeHolder,
    this.initialValue,
    this.helpText,
    this.min,
    this.max,
  });
  final String? label;
  final String? placeHolder;
  final String? initialValue;
  final String? helpText;
  final void Function(String?)? onChange;
  final double? min;
  final double? max;

  @override
  State<FBDecimalInput> createState() => _FBDecimalInputState();
}

class _FBDecimalInputState extends State<FBDecimalInput> {
  final TextEditingController _value = TextEditingController();

  void handleValueChange() {
    if (widget.onChange != null) widget.onChange!(_value.text);
  }

  @override
  void initState() {
    if (widget.initialValue != null) {
      _value.text = widget.initialValue!;
    }
    _value.addListener(handleValueChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _value,
      decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(),
          labelText: widget.label!.capitalize,
          hintText: widget.placeHolder),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (String? value) {
        if (value == null) return 'Please enter some text';
        // check if value match email pattern
        if (!RegExp(r"^[0-9]+(\.[0-9]+)?").hasMatch(value)) {
          return 'Please enter a valid number';
        }

        return null;
      },
    );
  }
}

class FBNumberInput extends StatefulWidget {
  const FBNumberInput({
    super.key,
    required this.onChange,
    this.label,
    this.placeHolder,
    this.initialValue = 0,
    this.helpText,
    this.min,
    this.max,
  });
  final String? label;
  final String? placeHolder;
  final int? initialValue;
  final String? helpText;
  final void Function(String?)? onChange;
  final double? min;
  final double? max;

  @override
  State<FBNumberInput> createState() => _FBNumberInputState();
}

class _FBNumberInputState extends State<FBNumberInput> {
  final TextEditingController _value = TextEditingController();

  void handleValueChange() {
    if (widget.onChange != null) widget.onChange!(_value.text);
  }

  @override
  void initState() {
    if (widget.initialValue != null) {
      _value.text = widget.initialValue.toString();
    }
    _value.addListener(handleValueChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _value,
      decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(),
          labelText: widget.label!.capitalize,
          hintText: widget.placeHolder),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (String? value) {
        if (value == null) return 'Please enter a number';
        // check if value match email pattern
        if (!RegExp(r"^[0-9]+(\.[0-9]+)?").hasMatch(value)) {
          return 'Please enter a valid number';
        }

        return null;
      },
    );
  }
}
