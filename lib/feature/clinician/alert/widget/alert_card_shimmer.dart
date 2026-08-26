import 'package:flutter/material.dart';
import '../../../../helper/responsive_helper/responsive_helper.dart';

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

/// PriorityAlertCard shape-এর সাথে match করা shimmer
class AlertCardShimmer extends StatelessWidget {
  const AlertCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.height(12)),
      child: Container(
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            _ShimmerBox(
              width: ResponsiveHelper.width(44),
              height: ResponsiveHelper.width(44),
              radius: ResponsiveHelper.width(22),
            ),
            SizedBox(width: ResponsiveHelper.width(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + time row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ShimmerBox(
                        width: ResponsiveHelper.width(110),
                        height: ResponsiveHelper.height(14),
                        radius: 6,
                      ),
                      _ShimmerBox(
                        width: ResponsiveHelper.width(55),
                        height: ResponsiveHelper.height(12),
                        radius: 6,
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.height(8)),
                  // Message line 1
                  _ShimmerBox(
                    width: double.infinity,
                    height: ResponsiveHelper.height(12),
                    radius: 6,
                  ),
                  SizedBox(height: ResponsiveHelper.height(4)),
                  // Message line 2
                  _ShimmerBox(
                    width: ResponsiveHelper.width(160),
                    height: ResponsiveHelper.height(12),
                    radius: 6,
                  ),
                  SizedBox(height: ResponsiveHelper.height(10)),
                  // Severity badge + Review button

                  _ShimmerBox(
                    width: double.infinity,
                    height: ResponsiveHelper.height(30),

                  ),

                  // Row(
                  //   children: [
                  //     _ShimmerBox(
                  //       width: ResponsiveHelper.width(90),
                  //       height: ResponsiveHelper.height(26),
                  //       radius: 20,
                  //     ),
                  //     const Spacer(),
                  //     _ShimmerBox(
                  //       width: ResponsiveHelper.width(80),
                  //       height: ResponsiveHelper.height(32),
                  //       radius: 8,
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}