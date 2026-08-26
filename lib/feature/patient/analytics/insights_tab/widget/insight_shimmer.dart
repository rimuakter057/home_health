import 'package:flutter/material.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';

class InsightShimmer extends StatefulWidget {
  const InsightShimmer({super.key});

  @override
  State<InsightShimmer> createState() => _InsightShimmerState();
}

class _InsightShimmerState extends State<InsightShimmer>
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

  Widget _box({required double w, required double h, double radius = 8}) {
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

  Widget _cardShimmer(double sw) {
    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// target food pill
          _box(w: sw * 0.38, h: ResponsiveHelper.height(28), radius: 20),
          SizedBox(height: ResponsiveHelper.height(14)),

          /// case type row
          Row(
            children: [
              _box(
                w: ResponsiveHelper.iconSize(16),
                h: ResponsiveHelper.iconSize(16),
                radius: 4,
              ),
              SizedBox(width: ResponsiveHelper.width(8)),
              _box(w: sw * 0.30, h: ResponsiveHelper.height(13)),
            ],
          ),
          SizedBox(height: ResponsiveHelper.height(12)),

          /// note lines
          _box(w: double.infinity, h: ResponsiveHelper.height(14)),
          SizedBox(height: ResponsiveHelper.height(8)),
          _box(w: sw * 0.80, h: ResponsiveHelper.height(14)),
          SizedBox(height: ResponsiveHelper.height(8)),
          _box(w: sw * 0.60, h: ResponsiveHelper.height(14)),
          SizedBox(height: ResponsiveHelper.height(14)),

          /// severity pill
          _box(w: sw * 0.22, h: ResponsiveHelper.height(26), radius: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Column(
      children: [
        // /// ── Day Filter Bar shimmer ──────────────────────────────────────
        // Container(
        //   width: double.infinity,
        //   padding: EdgeInsets.fromLTRB(
        //     ResponsiveHelper.padding(16),
        //     ResponsiveHelper.spacing(8),
        //     ResponsiveHelper.padding(16),
        //     ResponsiveHelper.spacing(12),
        //   ),
        //   child: Row(
        //     children: [
        //       _box(w: sw * 0.30, h: ResponsiveHelper.height(36), radius: 24),
        //       SizedBox(width: ResponsiveHelper.width(10)),
        //       _box(w: sw * 0.32, h: ResponsiveHelper.height(36), radius: 24),
        //     ],
        //   ),
        // ),

        /// ── Card List shimmer ───────────────────────────────────────────
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(
              ResponsiveHelper.padding(16),
              ResponsiveHelper.spacing(12),
              ResponsiveHelper.padding(16),
              ResponsiveHelper.spacing(24),
            ),
            itemCount: 5,
            separatorBuilder: (_, __) =>
                SizedBox(height: ResponsiveHelper.height(12)),
            itemBuilder: (_, __) => _cardShimmer(sw),
          ),
        ),
      ],
    );
  }
}