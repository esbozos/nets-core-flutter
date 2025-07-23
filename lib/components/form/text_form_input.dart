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
import 'package:nets_core/l10n/localizations.dart';
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
      this.icon,
      this.isDense = false,
      this.disabled = false,
      this.decoration,
      this.validate});
  final String? label;
  final String? initialValue;
  final String? placeHolder;
  final int? lines;
  final bool isDense;
  final Widget? icon;
  final bool obscureText;
  final void Function()? onTap;
  final void Function(String?)? onChange;
  final String? Function(String?)? validate;
  final String? helpText;
  final int? maxLength;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;
  final bool disabled;

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
      enabled: !widget.disabled,
      focusNode: focusNode,
      minLines: widget.lines,
      maxLines: widget.lines,
      controller: _value,
      decoration: widget.decoration != null
          ? widget.decoration!.copyWith(
              labelText: widget.label!.capitalize,
              hintText: widget.placeHolder,
              helperText: focused ? widget.helpText : null,
              helperMaxLines: 2,
              icon: widget.icon,
              isDense: widget.isDense,
              // border: const UnderlineInputBorder()
            )
          : InputDecoration(
              enabledBorder: const UnderlineInputBorder(),
              labelText: widget.label!.capitalize,
              hintText: widget.placeHolder,
              helperText: focused ? widget.helpText : null,
              helperMaxLines: 2,
              icon: widget.icon,
              isDense: widget.isDense,
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
      this.icon,
      this.isDense = false,
      this.decoration,
      this.disabled = false,
      this.onTap});
  final String? label;
  final String? placeHolder;
  final void Function()? onTap;
  final DateTime? maxDate;
  final DateTime? minDate;
  final bool isDense;
  final int? minAge;
  final Widget? icon;
  final int? maxAge;
  final DateTime? initialValue;
  final void Function(DateTime?)? onChange;
  final InputDecoration? decoration;
  final bool disabled;

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

  void handleChange(DateTime newDate) {
    setState(() {
      _dateValue = newDate;
      _value.text = formatDate(newDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.disabled
            ? null
            : () async {
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
                handleChange(selectedDate!);
              },
        child: TextFormField(
          controller: _value,
          decoration: widget.decoration != null
              ? widget.decoration!.copyWith(
                  labelText: widget.label!.capitalize,
                  hintText: widget.placeHolder,
                  isDense: widget.isDense,
                  icon: widget.icon)
              : InputDecoration(
                  enabledBorder: const UnderlineInputBorder(),
                  labelText: widget.label,
                  hintText: widget.placeHolder,
                  isDense: widget.isDense,
                  icon: widget.icon),
          enabled: false,
          onTap: () {},
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

class FBTimeInput extends StatefulWidget {
  const FBTimeInput(
      {super.key,
      this.label,
      this.initialValue,
      this.placeHolder,
      this.onChange,
      this.icon,
      this.isDense = false,
      this.decoration,
      this.disabled = false,
      this.onTap});
  final String? label;
  final String? placeHolder;
  final void Function()? onTap;
  final bool isDense;
  final Widget? icon;
  final TimeOfDay? initialValue;
  final void Function(TimeOfDay?)? onChange;
  final InputDecoration? decoration;
  final bool disabled;

  @override
  State<FBTimeInput> createState() => _FBTimeInputState();
}

class _FBTimeInputState extends State<FBTimeInput> {
  final TextEditingController _value = TextEditingController();
  DateTime? _timeValue = DateTime.now();

  String formatTime(DateTime d) {
    return DateFormat.jm().format(d);
  }

  void handleValueChange() {
    if (widget.onChange != null) {
      widget.onChange!(TimeOfDay.fromDateTime(_timeValue!));
    }
  }

  @override
  void initState() {
    if (widget.initialValue != null) {
      _value.text = formatTime(DateTime(
          _timeValue!.year,
          _timeValue!.month,
          _timeValue!.day,
          widget.initialValue!.hour,
          widget.initialValue!.minute));
      _timeValue = DateTime(
          _timeValue!.year,
          _timeValue!.month,
          _timeValue!.day,
          widget.initialValue!.hour,
          widget.initialValue!.minute);
    }
    _value.addListener(handleValueChange);
    super.initState();
  }

  void handleChange(DateTime newTime) {
    setState(() {
      _timeValue = newTime;
      _value.text = formatTime(newTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    // using showTimePicker
    return GestureDetector(
        onTap: widget.disabled
            ? null
            : () async {
                TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_timeValue!),
                );
                if (selectedTime != null) {
                  handleChange(DateTime(_timeValue!.year, _timeValue!.month,
                      _timeValue!.day, selectedTime.hour, selectedTime.minute));
                }
              },
        child: TextFormField(
          controller: _value,
          decoration: widget.decoration != null
              ? widget.decoration!.copyWith(
                  labelText: widget.label!.capitalize,
                  hintText: widget.placeHolder,
                  isDense: widget.isDense,
                  icon: widget.icon)
              : InputDecoration(
                  enabledBorder: const UnderlineInputBorder(),
                  labelText: widget.label,
                  hintText: widget.placeHolder,
                  isDense: widget.isDense,
                  icon: widget.icon),
          enabled: false,
          onTap: () {},
        ));
  }

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
      this.icon,
      this.isDense = false,
      this.decoration,
      this.disabled = false,
      this.initialValue});
  final List<String>? exclude;
  final void Function(Country) onSelect;
  final String? initialValue;
  final String? label;
  final Widget? icon;
  final bool isDense;
  final String? placeHolder;
  final InputDecoration? decoration;
  final bool disabled;

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
      _country = Country.from(json: countryJson!);
      updateValue();
          // _country = Country.from(json: countryJson);
      // updateValue();
    }
    _value.addListener(handleValueChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _value,
      enabled: !widget.disabled,
      decoration: widget.decoration != null
          ? widget.decoration!.copyWith(
              labelText: widget.label!.capitalize,
              hintText: widget.placeHolder,
              isDense: widget.isDense,
              icon: widget.icon)
          : InputDecoration(
              enabledBorder: const UnderlineInputBorder(),
              labelText: widget.label!.capitalize,
              hintText: widget.placeHolder,
              isDense: widget.isDense,
              icon: widget.icon),
      validator: (value) {
        debugPrint("//// country value $value");
        if (value == null || value.isEmpty) return 'Please select a country';
        if (_country == null) return 'Please select a country';

        return null;
      },
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
  const FBEmailInput(
      {super.key,
      required this.onChange,
      this.label,
      this.placeHolder,
      this.initialValue,
      this.helpText,
      this.optional = false,
      this.isDense = false,
      this.decoration,
      this.disabled = false,
      this.icon});
  final String? label;
  final String? placeHolder;
  final String? initialValue;
  final Widget? icon;
  final String? helpText;
  final bool optional;
  final bool isDense;
  final void Function(String?)? onChange;
  final InputDecoration? decoration;
  final bool disabled;

  @override
  State<FBEmailInput> createState() => _FBEmailInputState();
}

class _FBEmailInputState extends State<FBEmailInput> {
  final TextEditingController _value = TextEditingController();

  void handleValueChange() {
    if (widget.onChange != null) widget.onChange!(_value.text.toLowerCase());
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
    NetsCoreLocalizations t = NetsCoreLocalizations(
        localeName: Localizations.localeOf(context).toString().split('_')[0]);
    return TextFormField(
      controller: _value,
      enabled: !widget.disabled,
      decoration: widget.decoration != null
          ? widget.decoration!.copyWith(
              labelText: widget.label!.capitalize,
              hintText: widget.placeHolder,
              isDense: widget.isDense,
              icon: widget.icon)
          : InputDecoration(
              enabledBorder: const UnderlineInputBorder(),
              labelText: widget.label!.capitalize,
              hintText: widget.placeHolder,
              isDense: widget.isDense,
              helperText: widget.helpText,
              icon: widget.icon),
      validator: (String? value) {
        if (value == null && !widget.optional) return 'Please enter some text';
        // check if value match email pattern including _ + . characters
        var emailRegex = RegExp(r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
        if (value != null) {
          if (!emailRegex.hasMatch(value)) {
            return t.translate('invalidEmail');
          }
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
    this.isDense = false,
    this.decoration,
    this.disabled = false,
  });
  final String? label;
  final String? placeHolder;
  final bool? initialValue;
  final bool isDense;
  final String? helpText;
  final void Function(bool) onChange;
  final InputDecoration? decoration;
  final bool disabled;

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
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: _value,
          onChanged: widget.disabled
              ? null
              : (bool? v) {
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
  const FBDecimalInput(
      {super.key,
      required this.onChange,
      this.label,
      this.placeHolder,
      this.initialValue,
      this.helpText,
      this.min,
      this.isDense = false,
      this.max,
      this.decoration,
      this.disabled = false,
      this.icon,
      this.validate});
  final String? label;
  final String? placeHolder;
  final String? initialValue;
  final String? helpText;
  final Widget? icon;
  final void Function(String?)? onChange;
  final double? min;
  final bool isDense;
  final double? max;
  final InputDecoration? decoration;
  final bool disabled;
  final String? Function(String?)? validate;

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
      enabled: !widget.disabled,
      controller: _value,
      decoration: widget.decoration != null
          ? widget.decoration!.copyWith(
              labelText: widget.label!.capitalize,
              hintText: widget.placeHolder,
              isDense: widget.isDense,
              icon: widget.icon)
          : InputDecoration(
              enabledBorder: const UnderlineInputBorder(),
              labelText: widget.label!.capitalize,
              hintText: widget.placeHolder,
              isDense: widget.isDense,
              icon: widget.icon),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: widget.validate ??
          (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            // check if value match email pattern
            if (!RegExp(r"^[0-9]+(\.[0-9]+)?").hasMatch(value)) {
              return 'Please enter a valid number';
            }
            if (widget.max != null && double.parse(value) > widget.max!) {
              return 'Please enter a number less than ${widget.max}';
            }
            if (widget.min != null && double.parse(value) < widget.min!) {
              return 'Please enter a number greater than ${widget.min}';
            }

            return null;
          },
    );
  }
}

class FBNumberInput extends StatefulWidget {
  const FBNumberInput(
      {super.key,
      required this.onChange,
      this.label,
      this.placeHolder,
      this.initialValue = 0,
      this.helpText,
      this.min,
      this.max,
      this.isDense = false,
      this.optional = false,
      this.decoration,
      this.disabled = false,
      this.icon,
      this.validate});
  final String? label;
  final String? placeHolder;
  final int? initialValue;
  final String? helpText;
  final Widget? icon;
  final bool isDense;
  final bool optional;
  final void Function(String?)? onChange;
  final int? min;
  final int? max;
  final InputDecoration? decoration;
  final bool disabled;
  final String? Function(String?)? validate;

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
    var t = NetsCoreLocalizations(
        localeName: Localizations.localeOf(context).toString().split('_')[0]);
    return TextFormField(
      enabled: !widget.disabled,
      controller: _value,
      decoration: widget.decoration != null
          ? widget.decoration!.copyWith(
              labelText: widget.label!.capitalize,
              hintText: widget.placeHolder,
              isDense: widget.isDense,
              icon: widget.icon)
          : InputDecoration(
              enabledBorder: const UnderlineInputBorder(),
              labelText: widget.label!.capitalize,
              hintText: widget.placeHolder,
              isDense: widget.isDense,
              icon: widget.icon),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: widget.validate ??
          (String? value) {
            if ((value == null || value.isEmpty) && !widget.optional) {
              return t.translate('numberIsRequired');
            }
            try {
              int.parse(value!);
            } catch (e) {
              return t.translate('numberShouldBeInteger');
            }
            if (widget.max != null && int.parse(value) > widget.max!) {
              return t.translate('numberShouldBeLessThan',
                  args: [widget.max.toString()]);
            }
            if (widget.min != null && int.parse(value) < widget.min!) {
              return t.translate('numberShouldBeGreaterThan',
                  args: [widget.min.toString()]);
            }

            return null;
          },
    );
  }
}
