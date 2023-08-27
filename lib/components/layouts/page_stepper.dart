import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nets_core/components/layouts/progress_step_layout.dart';
import 'package:nets_core/components/screens/loading_screen.dart';
import 'package:nets_core/l10n/localizations.dart';

class StepPage {
  final String? title;

  final Function(BuildContext context, bool isActive, void Function() next)
      builder;

  StepPage({required this.title, required this.builder});
}

class PageStepper extends StatefulHookConsumerWidget {
  final String? title;
  final List<StepPage> steps;
  final bool loading;
  final Widget? loadingWidget;
  final double? maxWidth;
  final double? progressBarHeight;
  final double? topPadding;
  final String? localeName;

  const PageStepper(
      {Key? key,
      this.title,
      required this.steps,
      this.loading = false,
      this.loadingWidget,
      this.maxWidth,
      this.progressBarHeight,
      this.localeName,
      this.topPadding})
      : super(key: key);

  @override
  ConsumerState<PageStepper> createState() => _PageStepperState();
}

class _PageStepperState extends ConsumerState<PageStepper> {
  @override
  Widget build(BuildContext context) {
    var currentStep = useState(0);

    var trans = NetsCoreLocalizations(localeName: widget.localeName).translate;

    if (widget.loading) {
      if (widget.loadingWidget != null) {
        return widget.loadingWidget!;
      } else {
        return LoadingScreen(message: trans('loading'));
      }
    }
    return ProgressStepLayout(
        progressBarHeight: widget.progressBarHeight,
        maxWidth: widget.maxWidth,
        topPadding: widget.topPadding,
        progress: currentStep.value + 1 / widget.steps.length,
        onBack: currentStep.value > 0
            ? () {
                if (currentStep.value > 0) {
                  currentStep.value--;
                }
              }
            : null,
        children: [
          if (widget.title != null)
            Text(
              widget.title!,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          if (widget.steps[currentStep.value].title != null)
            Text(widget.steps[currentStep.value].title!,
                style: Theme.of(context).textTheme.titleSmall),
          widget.steps[currentStep.value].builder(
              context,
              currentStep.value ==
                  widget.steps.indexOf(widget.steps[currentStep.value]), () {
            if (currentStep.value < widget.steps.length - 1) {
              currentStep.value++;
            }
          })
        ]);
  }
}
