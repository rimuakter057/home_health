import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';

class ClinicianListShimmer extends StatefulWidget {
  const ClinicianListShimmer({super.key});

  @override
  State<ClinicianListShimmer> createState() => _ClinicianListShimmerState();
}

class _ClinicianListShimmerState extends State<ClinicianListShimmer>
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

  Widget _tile(double sw) {
    return Padding(
      padding: ResponsiveHelper.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// avatar
          _box(
            w: ResponsiveHelper.iconSize(52),
            h: ResponsiveHelper.iconSize(52),
            radius: 26,
          ),

          SizedBox(width: ResponsiveHelper.width(12)),

          /// name + specialty
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(w: sw * 0.38, h: ResponsiveHelper.height(16)),
                SizedBox(height: ResponsiveHelper.height(8)),
                _box(w: sw * 0.28, h: ResponsiveHelper.height(13)),
              ],
            ),
          ),

          SizedBox(width: ResponsiveHelper.width(8)),

          /// status button
          _box(
            w: sw * 0.20,
            h: ResponsiveHelper.height(32),
            radius: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 8,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        thickness: 1,
        color: AppColors.white,
      ),
      itemBuilder: (_, __) => _tile(sw),
    );
  }
}