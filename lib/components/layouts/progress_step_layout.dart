import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProgressStepLayout extends StatefulHookConsumerWidget {
  final double progress;
  final double? progressBarHeight;
  final double? maxWidth;
  final Color? backgroundColor;
  final void Function()? onBack;
  final List<Widget> children;
  final double? topPadding;
  const ProgressStepLayout(
      {super.key,
      required this.children,
      required this.progress,
      this.maxWidth = 600,
      this.progressBarHeight = 10,
      this.topPadding = 60,
      this.onBack,
      this.backgroundColor});

  @override
  ConsumerState<ProgressStepLayout> createState() => _ProgressStepLayoutState();
}

class _ProgressStepLayoutState extends ConsumerState<ProgressStepLayout> {
  int step = 0;
  double maxWidth = 600;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    if (isMobile) {
      maxWidth = MediaQuery.of(context).size.width - 20;
    }
    if (widget.maxWidth != null) {
      maxWidth = widget.maxWidth!;
    }

    return PopScope(
        onPopInvoked: (c) {
          if (widget.onBack != null) {
            widget.onBack!();
          }
        },
        child: SafeArea(
            child: Scaffold(
                backgroundColor: widget.backgroundColor,
                body: ListView(
                  children: [
                    // show progress
                    LinearProgressIndicator(
                      value: widget.progress,
                      minHeight: widget.progressBarHeight ?? 10,
                    ),
                    // show back button
                    if (widget.onBack != null)
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            IconButton(
                                onPressed: () {
                                  widget.onBack!();
                                },
                                icon: const Icon(Icons.arrow_back))
                          ]),
                    SizedBox(
                      height: widget.topPadding ?? 60,
                    ),
                    Column(children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Column(children: widget.children),
                      ),
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ))));
  }
}
