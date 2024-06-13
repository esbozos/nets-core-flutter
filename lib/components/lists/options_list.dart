import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nets_core/components/lists/options_list_item.dart';

class OptionsList extends StatefulHookConsumerWidget {
  final String? title;
  final Widget? leading;
  final List<OptionListItem> items;
  const OptionsList({super.key, this.title, this.items = const [], this.leading});

  @override
  ConsumerState<OptionsList> createState() => _OptionsListState();
}

class _OptionsListState extends ConsumerState<OptionsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border:
                Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest),
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            if (widget.title != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  if (widget.leading != null) widget.leading!,
                  if (widget.leading != null) const SizedBox(width: 8),
                  Text(widget.title!,
                      style: Theme.of(context).textTheme.bodyLarge!)
                ]),
              ),
            ...widget.items
                .map((e) => Column(children: [
                      e.build(context),
                      const Divider(
                        height: 1,
                      )
                    ]))
                ,
          ],
        ));
  }
}
