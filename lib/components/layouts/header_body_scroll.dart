import 'package:flutter/material.dart';

import 'package:nets_core/components/widgets/sliver_header_generic.dart';

class HeaderBodyScrollLayout extends StatelessWidget {
  const HeaderBodyScrollLayout({
    Key? key,
    required this.header,
    required this.body,
    this.shrinkHeader,
    this.scrollController,
    this.expandedHeight = 200,
    this.minHeight,
  }) : super(key: key);
  final double expandedHeight;
  final double? minHeight;

  final Widget header;
  final Widget? shrinkHeader;
  final Widget body;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverPersistentHeader(
            pinned: true,
            // floating: true,
            delegate: SliverHeaderGeneric(
                minHeight: minHeight,
                child: header,
                shrinkChild: shrinkHeader,
                expandedHeight: expandedHeight)),
      ],
      body: body,
    ));
  }
}
