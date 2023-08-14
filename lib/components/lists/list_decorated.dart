import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListDecoratedItem {
  final dynamic title;
  final Widget? leading;
  final Widget? trailing;
  final bool selected;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final dynamic subtitle;

  ListDecoratedItem(
      {required this.title,
      this.leading,
      this.trailing,
      this.onTap,
      this.onLongPress,
      this.selected = false,
      this.subtitle});
}

class ListDecorated extends StatefulHookConsumerWidget {
  final List<ListDecoratedItem> items;
  final bool showDivider;
  final bool dense;
  final double width;
  const ListDecorated(
      {Key? key,
      required this.items,
      this.dense = false,
      this.showDivider = false,
      this.width = 450})
      : super(key: key);

  @override
  ConsumerState<ListDecorated> createState() => _ListDecoratedState();
}

class _ListDecoratedState extends ConsumerState<ListDecorated> {
  @override
  Widget build(BuildContext context) {
    // return a list of ListTile with a constrained width max of 600
    return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.width),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.items.length,
          itemBuilder: (BuildContext context, int index) {
            final item = widget.items[index];
            // ListTile is not honoring the width constraint
            // create alternative with Container
            return Column(children: [
              Container(
                  constraints: BoxConstraints(maxWidth: widget.width),
                  child: ListTile(
                      selected: item.selected,
                      selectedTileColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      isThreeLine: item.subtitle != null,
                      visualDensity: VisualDensity.compact,
                      dense: widget.dense,
                      leading: item.leading,
                      title: item.title is Widget
                          ? item.title
                          : Text(item.title as String,
                              style: Theme.of(context).textTheme.titleMedium),
                      subtitle: item.subtitle == null
                          ? null
                          : item.subtitle is Widget
                              ? item.subtitle
                              : Text(item.subtitle as String,
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                      trailing: item.trailing,
                      onTap: item.onTap,
                      onLongPress: item.onLongPress))
            ]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return widget.showDivider ? const Divider() : const SizedBox();
          },
        ));
  }
}
