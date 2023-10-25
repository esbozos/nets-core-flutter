import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({super.key, required this.avatar, this.size = 100});
  final double size;
  final String? avatar;

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  @override
  Widget build(BuildContext context) {
    if (widget.avatar == null) {
      return CircleAvatar(
        radius: widget.size / 2,
        backgroundImage:
            const AssetImage('assets/images/default_avatar_small.png'),
      );
    }

    return CircleAvatar(
      radius: widget.size / 2,
      backgroundImage: CachedNetworkImageProvider(widget.avatar!),
      onBackgroundImageError: (exception, stackTrace) =>
          const AssetImage('assets/images/default_avatar_small.png'),
    );
  }
}
