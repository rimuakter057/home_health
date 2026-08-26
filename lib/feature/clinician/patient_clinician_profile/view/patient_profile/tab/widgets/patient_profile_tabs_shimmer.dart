import 'package:ezygut/share/widgets/shimmer/skeliton_shimmer.dart';
import 'package:flutter/material.dart';

class OverviewTabShimmer extends StatelessWidget {
  const OverviewTabShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white),
            ),
            child: const Column(
              children: [
                SkeletonShimmer(height: 180, width: double.infinity, radius: 12),
                SizedBox(height: 20),
                SkeletonShimmer(height: 14, width: 220),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: SkeletonShimmer(height: 18, width: 180),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            4,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: SkeletonShimmer(height: 66, width: double.infinity, radius: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class LogsTabShimmer extends StatelessWidget {
  const LogsTabShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: SkeletonShimmer(height: 92, width: double.infinity, radius: 14),
      ),
    );
  }
}

class TriggerTabShimmer extends StatelessWidget {
  const TriggerTabShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SkeletonShimmer(height: 20, width: 160),
          SizedBox(height: 14),
          SkeletonShimmer(height: 28, width: 280, radius: 18),
          SizedBox(height: 16),
          SkeletonShimmer(height: 240, width: double.infinity, radius: 12),
          SizedBox(height: 14),
          SkeletonShimmer(height: 16, width: 210),
        ],
      ),
    );
  }
}
