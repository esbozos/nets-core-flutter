import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nets_core/utils/extentions.dart';

class WideButton extends StatefulWidget {
  final Function()? onPressed;
  final String label;
  final Color? color;
  final Color? textColor;
  final Widget? icon;
  const WideButton(
      {super.key,
      required this.label,
      this.icon,
      this.color,
      this.textColor,
      this.onPressed});

  @override
  State<WideButton> createState() => _WideButtonState();
}

class _WideButtonState extends State<WideButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    widget.color ?? Theme.of(context).colorScheme.primary,
                foregroundColor: widget.textColor ??
                    Theme.of(context).colorScheme.onPrimary),
            onPressed: widget.onPressed,
            icon: widget.icon ??
                const Icon(
                  Icons.face,
                  color: Colors.transparent,
                ),
            label: Text(widget.label.capitalize)));
  }
}

class CancelButton extends StatefulWidget {
  final Function()? onPressed;
  final String label;
  final IconData? icon;
  const CancelButton(
      {super.key, required this.label, this.icon, this.onPressed});

  @override
  State<CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<CancelButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError),
        onPressed: widget.onPressed,
        icon: Icon(
          widget.icon ?? Icons.cancel,
          color: Theme.of(context).colorScheme.onError,
        ),
        label: Text(widget.label.capitalize));
  }
}

class SubmitButton extends StatefulWidget {
  final Function()? onPressed;
  final String label;
  final IconData? icon;
  const SubmitButton(
      {super.key, required this.label, this.icon, this.onPressed});

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary),
        onPressed: widget.onPressed,
        icon: Icon(
          widget.icon ?? Icons.check,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        label: Text(widget.label.capitalize));
  }
}

class CancelOrSubmitButtons extends StatefulWidget {
  final Function()? onCancel;
  final Function()? onSubmit;
  final String cancelLabel;
  final String submitLabel;
  final IconData? cancelIcon;
  final IconData? submitIcon;
  const CancelOrSubmitButtons(
      {super.key,
      required this.cancelLabel,
      required this.submitLabel,
      this.cancelIcon,
      this.submitIcon,
      this.onCancel,
      this.onSubmit});

  @override
  State<CancelOrSubmitButtons> createState() => _CancelOrSubmitButtonsState();
}

class _CancelOrSubmitButtonsState extends State<CancelOrSubmitButtons> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CancelButton(
              label: widget.cancelLabel,
              icon: widget.cancelIcon,
              onPressed: widget.onCancel),
          SubmitButton(
              label: widget.submitLabel,
              icon: widget.submitIcon,
              onPressed: widget.onSubmit)
        ]);
  }
}

class PriceButton extends StatefulWidget {
  final Function()? onPressed;
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final bool showDecimal;
  final bool showSymbol;
  final String? symbol;
  final double price;
  const PriceButton({
    super.key,
    required this.label,
    required this.price,
    this.backgroundColor,
    this.showDecimal = true,
    this.showSymbol = true,
    this.symbol,
    this.textColor,
    this.icon,
    this.onPressed,
  });

  @override
  State<PriceButton> createState() => _PriceButtonState();
}

class _PriceButtonState extends State<PriceButton> {
  NumberFormat currencyFormat = NumberFormat.simpleCurrency(
      locale: 'en_US', decimalDigits: 2, name: 'USD');
  @override
  void initState() {
    super.initState();
    if (widget.showSymbol) {
      currencyFormat = NumberFormat.simpleCurrency(
          locale: 'en_US',
          decimalDigits: widget.showDecimal ? 2 : 0,
          name: widget.symbol);
    } else {
      currencyFormat = NumberFormat.decimalPatternDigits(
          locale: 'en_US', decimalDigits: widget.showDecimal ? 2 : 0);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor =
        widget.backgroundColor ?? Theme.of(context).colorScheme.primary;
    Color textColor =
        widget.textColor ?? Theme.of(context).colorScheme.onPrimary;
    if (widget.backgroundColor != null && widget.textColor == null) {
      // if the background color is set but the text color is not, we need to
      // compute the text color based on the background color
      textColor =
          bgColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    }
    return InkWell(
        onTap: () {
          widget.onPressed!();
        },
        child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
                color: bgColor, borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              children: [
                Row(children: [
                  if (widget.icon != null)
                    Icon(
                      widget.icon ?? Icons.check,
                      color: textColor,
                      size: Theme.of(context).textTheme.titleSmall!.fontSize,
                    ),
                  Text(widget.label.capitalize,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: textColor))
                ]),
                Text(currencyFormat.format(widget.price),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: textColor))
              ],
            )));
  }
}
