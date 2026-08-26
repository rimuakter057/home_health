import 'package:flutter/material.dart';
import '../../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../../utils/color/app_colors.dart';

/// ─────────────────────────────────────────────
/// Shimmer base widget
/// ─────────────────────────────────────────────
class HomeClinicianShimmerWidget extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const HomeClinicianShimmerWidget({super.key,
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  State<HomeClinicianShimmerWidget> createState() => _HomeClinicianShimmerWidgetState();
}

class _HomeClinicianShimmerWidgetState extends State<HomeClinicianShimmerWidget>
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

/// ─────────────────────────────────────────────
/// Full-screen shimmer skeleton for HomeClinicianScreen
/// ─────────────────────────────────────────────
class HomeClinicianShimmer extends StatelessWidget {
  const HomeClinicianShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: ResponsiveHelper.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────
              _HeaderShimmer(w: w),

              SizedBox(height: ResponsiveHelper.height(20)),

              // ── Search bar ──────────────────────────────
              HomeClinicianShimmerWidget(
                width: double.infinity,
                height: ResponsiveHelper.height(48),
                radius: 12,
              ),

              SizedBox(height: ResponsiveHelper.height(20)),

              // ── Dashboard cards (2-column grid) ─────────
              _SummaryGridShimmer(w: w),

              SizedBox(height: ResponsiveHelper.height(8)),

              // ── Section header: Priority Alerts ─────────
              _SectionHeaderShimmer(w: w),

              SizedBox(height: ResponsiveHelper.height(8)),

              // ── Alert card ──────────────────────────────
              _AlertCardShimmer(w: w),

              SizedBox(height: ResponsiveHelper.height(8)),

              // ── Section header: Recent Activity ─────────
              _SectionHeaderShimmer(w: w),

              SizedBox(height: ResponsiveHelper.height(12)),

              // ── Activity items ──────────────────────────
              ...[0, 1, 2].map((_) => _ActivityItemShimmer(w: w)),

              SizedBox(height: ResponsiveHelper.height(36)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Header shimmer ───────────────────────────────────────
class _HeaderShimmer extends StatelessWidget {
  final double w;
  const _HeaderShimmer({required this.w});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar circle
        HomeClinicianShimmerWidget(
          width: ResponsiveHelper.width(48),
          height: ResponsiveHelper.width(48),
          radius: ResponsiveHelper.width(24),
        ),
        SizedBox(width: ResponsiveHelper.width(12)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeClinicianShimmerWidget(
              width: ResponsiveHelper.width(80),
              height: ResponsiveHelper.height(12),
              radius: 6,
            ),
            SizedBox(height: ResponsiveHelper.height(6)),
            HomeClinicianShimmerWidget(
              width: ResponsiveHelper.width(140),
              height: ResponsiveHelper.height(16),
              radius: 6,
            ),
          ],
        ),
        const Spacer(),
        HomeClinicianShimmerWidget(
          width: ResponsiveHelper.width(36),
          height: ResponsiveHelper.width(36),
          radius: 10,
        ),
      ],
    );
  }
}

// ─── Summary 2×2 grid shimmer ─────────────────────────────
class _SummaryGridShimmer extends StatelessWidget {
  final double w;
  const _SummaryGridShimmer({required this.w});

  @override
  Widget build(BuildContext context) {
    final cardWidth =
        (MediaQuery.of(context).size.width - ResponsiveHelper.padding(16) * 2 - 14) /
            2;
    final cardHeight = cardWidth / 1.4;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 14,
        childAspectRatio: 1.4,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: HomeClinicianShimmerWidget(
            width: cardWidth,
            height: cardHeight,
            radius: 12,
          ),
        );
      },
    );
  }
}

// ─── Section header shimmer ───────────────────────────────
class _SectionHeaderShimmer extends StatelessWidget {
  final double w;
  const _SectionHeaderShimmer({required this.w});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.height(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HomeClinicianShimmerWidget(
            width: ResponsiveHelper.width(130),
            height: ResponsiveHelper.height(16),
            radius: 6,
          ),
          HomeClinicianShimmerWidget(
            width: ResponsiveHelper.width(55),
            height: ResponsiveHelper.height(13),
            radius: 6,
          ),
        ],
      ),
    );
  }
}

// ─── Alert card shimmer ───────────────────────────────────
class _AlertCardShimmer extends StatelessWidget {
  final double w;
  const _AlertCardShimmer({required this.w});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          HomeClinicianShimmerWidget(
            width: ResponsiveHelper.width(44),
            height: ResponsiveHelper.width(44),
            radius: ResponsiveHelper.width(22),
          ),
          SizedBox(width: ResponsiveHelper.width(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HomeClinicianShimmerWidget(
                      width: ResponsiveHelper.width(100),
                      height: ResponsiveHelper.height(14),
                      radius: 6,
                    ),
                    HomeClinicianShimmerWidget(
                      width: ResponsiveHelper.width(60),
                      height: ResponsiveHelper.height(12),
                      radius: 6,
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.height(6)),
                HomeClinicianShimmerWidget(
                  width: double.infinity,
                  height: ResponsiveHelper.height(12),
                  radius: 6,
                ),
                SizedBox(height: ResponsiveHelper.height(4)),
                HomeClinicianShimmerWidget(
                  width: ResponsiveHelper.width(140),
                  height: ResponsiveHelper.height(12),
                  radius: 6,
                ),
                SizedBox(height: ResponsiveHelper.height(10)),
                // Severity badge + button row
                Row(
                  children: [
                    HomeClinicianShimmerWidget(
                      width: ResponsiveHelper.width(80),
                      height: ResponsiveHelper.height(24),
                      radius: 20,
                    ),
                    const Spacer(),
                    HomeClinicianShimmerWidget(
                      width: ResponsiveHelper.width(80),
                      height: ResponsiveHelper.height(30),
                      radius: 8,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Activity item shimmer ────────────────────────────────
class _ActivityItemShimmer extends StatelessWidget {
  final double w;
  const _ActivityItemShimmer({required this.w});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.height(8)),
          child: Row(
            children: [
              HomeClinicianShimmerWidget(
                width: ResponsiveHelper.width(40),
                height: ResponsiveHelper.width(40),
                radius: ResponsiveHelper.width(20),
              ),
              SizedBox(width: ResponsiveHelper.width(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeClinicianShimmerWidget(
                      width: ResponsiveHelper.width(120),
                      height: ResponsiveHelper.height(13),
                      radius: 6,
                    ),
                    SizedBox(height: ResponsiveHelper.height(5)),
                    HomeClinicianShimmerWidget(
                      width: double.infinity,
                      height: ResponsiveHelper.height(11),
                      radius: 6,
                    ),
                  ],
                ),
              ),
              SizedBox(width: ResponsiveHelper.width(8)),
              HomeClinicianShimmerWidget(
                width: ResponsiveHelper.width(48),
                height: ResponsiveHelper.height(11),
                radius: 6,
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
      ],
    );
  }
}