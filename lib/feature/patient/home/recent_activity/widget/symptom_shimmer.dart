import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';

class SymptomTabShimmer extends StatefulWidget {
  const SymptomTabShimmer({super.key});

  @override
  State<SymptomTabShimmer> createState() => _SymptomTabShimmerState();
}

class _SymptomTabShimmerState extends State<SymptomTabShimmer>
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

  Widget _card(double sw) {
    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.all(16),
      margin: EdgeInsets.only(top: ResponsiveHelper.padding(16)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// icon box (padding: all(22) + 20x20 icon = ~64x64)
          _box(
            w: ResponsiveHelper.iconSize(64),
            h: ResponsiveHelper.iconSize(64),
            radius: 8,
          ),

          SizedBox(width: ResponsiveHelper.width(12)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// symptoms text + time (right)
                Row(
                  children: [
                    Expanded(
                      child: _box(
                        w: double.infinity,
                        h: ResponsiveHelper.height(15),
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.width(12)),
                    _box(w: sw * 0.14, h: ResponsiveHelper.height(13)),
                  ],
                ),

                SizedBox(height: ResponsiveHelper.height(8)),

                /// severity
                _box(w: sw * 0.22, h: ResponsiveHelper.height(13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (_, __) => _card(sw),
    );
  }
}