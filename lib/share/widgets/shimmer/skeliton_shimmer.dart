import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonShimmer extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const SkeletonShimmer({
    super.key,
    required this.height,
    required this.width,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}