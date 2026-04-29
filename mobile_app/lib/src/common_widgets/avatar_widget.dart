// lib/src/common_widgets/avatar_widget.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_colors.dart';

class AvatarWidget extends StatelessWidget {
  final String? url;
  final double radius;

  const AvatarWidget({
    super.key,
    this.url,
    this.radius = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.neutral700,
      backgroundImage: url != null && url!.isNotEmpty
          ? CachedNetworkImageProvider(url!)
          : null,
      child: url == null || url!.isEmpty
          ? Icon(Icons.person, color: AppColors.neutral400, size: radius)
          : null,
    );
  }
}
