import 'package:ezygut/helper/responsive_helper/responsive_helper.dart' show ResponsiveHelper;
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// Reusable animated shimmer box
// ─────────────────────────────────────────────
class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: const [
                Color(0xFFE8E8E8),
                Color(0xFFF5F5F5),
                Color(0xFFEEEEEE),
                Color(0xFFE8E8E8),
              ],
              stops: const [0.0, 0.35, 0.65, 1.0],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Single patient card shimmer — AppCard shape match
// ─────────────────────────────────────────────
class PatientCardShimmer extends StatelessWidget {
  const PatientCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.height(12)),
      padding: ResponsiveHelper.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row 1: avatar + name + time + chevron ──
          Row(
            children: [
              _ShimmerBox(
                width: ResponsiveHelper.width(52),
                height: ResponsiveHelper.width(52),
                radius: ResponsiveHelper.width(26),
              ),
              SizedBox(width: ResponsiveHelper.width(12)),
              Expanded(
                child: _ShimmerBox(
                  width: double.infinity,
                  height: ResponsiveHelper.height(14),
                  radius: 6,
                ),
              ),
              SizedBox(width: ResponsiveHelper.width(8)),
              _ShimmerBox(
                width: ResponsiveHelper.width(50),
                height: ResponsiveHelper.height(12),
                radius: 6,
              ),
              SizedBox(width: ResponsiveHelper.width(8)),
              _ShimmerBox(
                width: ResponsiveHelper.width(20),
                height: ResponsiveHelper.height(20),
                radius: 4,
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.height(10)),

          // ── Row 2: status badge + age ──
          Row(
            children: [
              _ShimmerBox(
                width: ResponsiveHelper.width(72),
                height: ResponsiveHelper.height(24),
                radius: 8,
              ),
              SizedBox(width: ResponsiveHelper.width(10)),
              _ShimmerBox(
                width: ResponsiveHelper.width(44),
                height: ResponsiveHelper.height(14),
                radius: 6,
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.height(14)),

          // ── Row 3: two action buttons ──
          Row(
            children: [
              Expanded(
                child: _ShimmerBox(
                  width: double.infinity,
                  height: ResponsiveHelper.height(40),
                  radius: 8,
                ),
              ),
              SizedBox(width: ResponsiveHelper.width(12)),
              Expanded(
                child: _ShimmerBox(
                  width: double.infinity,
                  height: ResponsiveHelper.height(40),
                  radius: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}