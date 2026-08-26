import 'package:flutter/material.dart';
import '../../../../../helper/responsive_helper/responsive_helper.dart';

class DigestiveScoreShimmer extends StatefulWidget {
  const DigestiveScoreShimmer({super.key});

  @override
  State<DigestiveScoreShimmer> createState() => _DigestiveScoreShimmerState();
}

class _DigestiveScoreShimmerState extends State<DigestiveScoreShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _anim = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _box({
    required double w,
    required double h,
    double radius = 8,
  }) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value + 1, 0),
            colors: [
              Colors.grey.shade300,
              Colors.grey.shade100,
              Colors.grey.shade300,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: ResponsiveHelper.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Score Card shimmer
          Container(
            width: double.infinity,
            padding: ResponsiveHelper.all(16),
            margin: EdgeInsets.only(top: ResponsiveHelper.height(16)),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: ResponsiveHelper.height(20)),
                _box(
                  w: sw * 0.42,
                  h: sw * 0.42,
                  radius: sw * 0.18,
                ),
                SizedBox(height: ResponsiveHelper.height(20)),
                _box(w: sw * 0.55, h: ResponsiveHelper.height(20)),
                SizedBox(height: ResponsiveHelper.height(10)),
                _box(w: sw * 0.40, h: ResponsiveHelper.height(20)),
                SizedBox(height: ResponsiveHelper.height(20)),
              ],
            ),
          ),

          SizedBox(height: ResponsiveHelper.height(44)),

          /// "Concerns" label
          _box(w: sw * 0.35, h: ResponsiveHelper.height(18)),
          SizedBox(height: ResponsiveHelper.height(14)),

          /// Concern items
          ...List.generate(2, (i) => Padding(
            padding: EdgeInsets.only(bottom: ResponsiveHelper.height(12)),
            child: Container(
              width: double.infinity,
              padding: ResponsiveHelper.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _box(
                    w: ResponsiveHelper.iconSize(36),
                    h: ResponsiveHelper.iconSize(36),
                    radius: 8,
                  ),
                  SizedBox(width: ResponsiveHelper.width(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _box(w: double.infinity, h: ResponsiveHelper.height(20)),
                        SizedBox(height: ResponsiveHelper.height(8)),
                        _box(w: sw * 0.5, h: ResponsiveHelper.height(20)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),

          SizedBox(height: ResponsiveHelper.height(10)),

          /// "Recommendations" label
          _box(w: sw * 0.42, h: ResponsiveHelper.height(20)),
          SizedBox(height: ResponsiveHelper.height(14)),

          /// Recommendation items
          ...List.generate(2, (i) => Padding(
            padding: EdgeInsets.only(bottom: ResponsiveHelper.height(12)),
            child: Container(
              width: double.infinity,
              padding: ResponsiveHelper.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _box(
                    w: ResponsiveHelper.iconSize(28),
                    h: ResponsiveHelper.iconSize(28),
                    radius: 14,
                  ),
                  SizedBox(width: ResponsiveHelper.width(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _box(w: double.infinity, h: ResponsiveHelper.height(14)),
                        SizedBox(height: ResponsiveHelper.height(8)),
                        _box(w: sw * 0.45, h: ResponsiveHelper.height(14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),

          SizedBox(height: ResponsiveHelper.height(24)),
        ],
      ),
    );
  }
}