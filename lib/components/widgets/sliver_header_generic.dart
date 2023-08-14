import 'package:flutter/material.dart';

class SliverHeaderGeneric extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Widget? child;
  final Widget? shrinkChild;
  final double? minHeight;
  final DecorationImage? backgroundImage;
  final Gradient? backgroundGradient;

  SliverHeaderGeneric({
    required this.expandedHeight,
    required this.child,
    this.shrinkChild,
    this.backgroundGradient,
    this.backgroundImage,
    this.minHeight,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        if (shrinkChild != null)
          Center(
            child: Opacity(
              opacity: shrinkOffset / expandedHeight,
              child: shrinkChild,
            ),
          ),
        if (shrinkOffset < expandedHeight)
          Positioned(
            // top: expandedHeight / 4 - shrinkOffset,
            width: MediaQuery.of(context).size.width,
            // left: MediaQuery.of(context).size.width / 4,
            child: Center(
                child: Opacity(
              opacity: (1 - shrinkOffset / expandedHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (child != null) child!,
                  // const SizedBox(
                  //   height: 10.0,
                  // ),
                  if (shrinkOffset > 0 &&
                      shrinkChild != null &&
                      shrinkOffset > expandedHeight / 3)
                    if (shrinkChild != null) shrinkChild!,
                ],
              ),
              // child: child,
            )),
          ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => minHeight ?? kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
