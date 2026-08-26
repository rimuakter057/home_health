import 'package:flutter/material.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';

class MyPlanShimmer extends StatefulWidget {
  const MyPlanShimmer({super.key});

  @override
  State<MyPlanShimmer> createState() => _MyPlanShimmerState();
}

class _MyPlanShimmerState extends State<MyPlanShimmer>
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

  Widget _planCard(double sw) {
    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.all(16),
      margin: EdgeInsets.only(bottom: ResponsiveHelper.height(10)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// title + days badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _box(w: sw * 0.50, h: ResponsiveHelper.height(17)),
              _box(w: sw * 0.22, h: ResponsiveHelper.height(28), radius: 6),
            ],
          ),

          SizedBox(height: ResponsiveHelper.height(12)),

          /// description lines
          _box(w: double.infinity, h: ResponsiveHelper.height(14)),
          SizedBox(height: ResponsiveHelper.height(8)),
          _box(w: sw * 0.75, h: ResponsiveHelper.height(14)),
          SizedBox(height: ResponsiveHelper.height(8)),
          _box(w: sw * 0.55, h: ResponsiveHelper.height(14)),

          SizedBox(height: ResponsiveHelper.height(16)),

          /// "Learn more →"
          Row(
            children: [
              _box(w: sw * 0.22, h: ResponsiveHelper.height(14)),
              SizedBox(width: ResponsiveHelper.width(6)),
              _box(
                w: ResponsiveHelper.iconSize(14),
                h: ResponsiveHelper.iconSize(14),
                radius: 4,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Padding(
      padding: ResponsiveHelper.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// "Personalized Plan" title
          _box(w: sw * 0.52, h: ResponsiveHelper.height(20)),
          SizedBox(height: ResponsiveHelper.height(8)),

          /// subtitle
          _box(w: sw * 0.68, h: ResponsiveHelper.height(14)),
          SizedBox(height: ResponsiveHelper.height(20)),

          /// plan cards
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (_, __) => _planCard(sw),
            ),
          ),
        ],
      ),
    );
  }
}