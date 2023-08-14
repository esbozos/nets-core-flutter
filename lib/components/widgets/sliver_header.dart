import 'package:flutter/material.dart';

class SliverImageHeader extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Widget? title;
  final Widget? topButton;
  final Widget image;
  final double? imageSize;
  final DecorationImage? backgroundImage;
  final Gradient? backgroundGradient;

  SliverImageHeader(
      {required this.expandedHeight,
      required this.image,
      this.topButton,
      this.backgroundGradient,
      this.title,
      this.backgroundImage,
      this.imageSize = 120});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        Container(
          alignment: Alignment.topRight,
          decoration: BoxDecoration(
              gradient: backgroundGradient, image: backgroundImage),
          child: topButton ?? const Text(''),
        ),
        if (title != null)
          Center(
            child: Opacity(
              opacity: shrinkOffset / expandedHeight,
              child: title,
            ),
          ),
        Positioned(
          top: expandedHeight / 4 - shrinkOffset,
          width: MediaQuery.of(context).size.width,
          // left: MediaQuery.of(context).size.width / 4,
          child: Center(
              child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (title != null) title!,
                const SizedBox(
                  height: 10.0,
                ),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: SizedBox(
                    height: imageSize,
                    width: imageSize,
                    child: ClipOval(
                      clipBehavior: Clip.antiAlias,
                      child: image,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
