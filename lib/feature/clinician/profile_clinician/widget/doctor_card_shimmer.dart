import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';

class DoctorCardShimmer extends StatefulWidget {
  const DoctorCardShimmer();

  @override
  State<DoctorCardShimmer> createState() => _DoctorCardShimmerState();
}

class _DoctorCardShimmerState extends State<DoctorCardShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _anim = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _box(double w, double h, {double r = 8}) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(r),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value, 0),
            colors: const [
              Color(0xFFE8E8E8),
              Color(0xFFF5F5F5),
              Color(0xFFEEEEEE),
              Color(0xFFE8E8E8),
            ],
            stops: const [0.0, 0.35, 0.65, 1.0],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = ResponsiveHelper.width(48);

    return Padding(
      padding: ResponsiveHelper.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Avatar
          _box(avatarSize, avatarSize, r: avatarSize / 2),
          SizedBox(width: ResponsiveHelper.width(12)),
          // Name + specialty
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(ResponsiveHelper.width(130), ResponsiveHelper.height(14)),
                SizedBox(height: ResponsiveHelper.height(6)),
                _box(ResponsiveHelper.width(90), ResponsiveHelper.height(12)),
              ],
            ),
          ),
          // Action button placeholder
          _box(ResponsiveHelper.width(72), ResponsiveHelper.height(32), r: 8),
        ],
      ),
    );
  }
}


// ── 2. Obx() টা এটা দিয়ে replace করো ──
