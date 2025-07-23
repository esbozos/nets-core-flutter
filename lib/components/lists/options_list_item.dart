import 'package:flutter/material.dart';

enum OptionListType { normal, switcher, radio, checkbox }

class OptionListItem {
  final void Function()? onTap;
  final String title;
  final String? subtitle;
  final String helperText;
  final String? errorText;
  final Widget? leading;
  final Widget? trailing;
  final bool? value;
  final String? initialValue;
  final OptionListType type;

  OptionListItem(
      {required this.title,
      this.subtitle,
      this.type = OptionListType.normal,
      this.helperText = '',
      this.errorText,
      this.initialValue,
      this.value,
      this.onTap,
      this.leading,
      this.trailing});

  Widget build(BuildContext context) {
    switch (type) {
      case OptionListType.normal:
        return ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          title: Text(title),
          onTap: onTap,
          leading: leading,
          trailing: SizedBox(
              width: 150,
              height: 30,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (initialValue != null)
                      Text(initialValue!,
                          style: Theme.of(context).textTheme.bodySmall),
                    if (trailing != null) trailing as Widget else Container(),
                  ])),
        );
      case OptionListType.switcher:
        return SwitchListTile(
          dense: true,
          title: Text(title, style: Theme.of(context).textTheme.titleSmall),
          value: value ?? false,
          onChanged: (value) {
            onTap?.call();
          },
          secondary: leading,
        );
      case OptionListType.radio:
        return RadioListTile(
          dense: true,
          title: Text(title),
          value: value ?? false,
          onChanged: (value) {
            onTap?.call();
          },
          secondary: leading,
          groupValue: null,
        );
      case OptionListType.checkbox:
        return CheckboxListTile(
          dense: true,
          title: Text(title),
          subtitle: Text(subtitle ?? ''),
          value: value ?? false,
          onChanged: (value) {
            onTap?.call();
          },
          secondary: leading,
        );
      }
  }
}
