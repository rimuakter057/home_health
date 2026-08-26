import 'package:flutter/material.dart';
import '../../../../../helper/responsive_helper/responsive_helper.dart';

class FoodLogShimmerWidget extends StatefulWidget {
  const FoodLogShimmerWidget({super.key});

  @override
  State<FoodLogShimmerWidget> createState() => _FoodLogShimmerWidgetState();
}

class _FoodLogShimmerWidgetState extends State<FoodLogShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _animation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    double? radius,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              radius ?? ResponsiveHelper.borderRadius(8),
            ),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: const [
                Color(0xFFE8E8E8),
                Color(0xFFF5F5F5),
                Color(0xFFE8E8E8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _shimmerCircle(double size) {
    final s = ResponsiveHelper.iconSize(size);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          width: s,
          height: s,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: const [
                Color(0xFFE8E8E8),
                Color(0xFFF5F5F5),
                Color(0xFFE8E8E8),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Single FoodItemCard skeleton
  Widget _foodCardShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.spacing(12)),
      padding: EdgeInsets.all(ResponsiveHelper.padding(14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Food image thumbnail ──
          _shimmerBox(
            width: ResponsiveHelper.width(64),
            height: ResponsiveHelper.height(64),
            radius: ResponsiveHelper.borderRadius(10),
          ),

          SizedBox(width: ResponsiveHelper.spacing(12)),

          // ── Text content ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food name
                _shimmerBox(
                  width: ResponsiveHelper.width(160),
                  height: ResponsiveHelper.height(18),
                ),
                SizedBox(height: ResponsiveHelper.spacing(8)),

                // Subtitle / category
                _shimmerBox(
                  width: ResponsiveHelper.width(100),
                  height: ResponsiveHelper.height(18),
                ),

              ],
            ),
          ),

          SizedBox(width: ResponsiveHelper.spacing(10)),

          // ── Right side: time + menu icon ──
          _shimmerCircle(30),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        ResponsiveHelper.padding(16),
        ResponsiveHelper.spacing(12),
        ResponsiveHelper.padding(16),
        ResponsiveHelper.spacing(24),
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) => _foodCardShimmer(),
    );
  }
}