// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import '../../../../../helper/responsive_helper/responsive_helper.dart';

class HomeShimmerWidget extends StatefulWidget {
  const HomeShimmerWidget({super.key});

  @override
  State<HomeShimmerWidget> createState() => _HomeShimmerWidgetState();
}

class _HomeShimmerWidgetState extends State<HomeShimmerWidget>
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
    final r = radius ?? ResponsiveHelper.borderRadius(8);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(r),
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

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  /// Food / Symptom log row skeleton
  Widget _logRow({bool showBadge = false, bool showTrailingCircle = false}) {
    return Row(
      children: [
        _shimmerBox(
          width: ResponsiveHelper.iconSize(36),
          height: ResponsiveHelper.iconSize(36),
          radius: ResponsiveHelper.borderRadius(8),
        ),
        SizedBox(width: ResponsiveHelper.spacing(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerBox(
                width: ResponsiveHelper.width(120),
                height: ResponsiveHelper.fontSize(12),
              ),
              SizedBox(height: ResponsiveHelper.spacing(6)),
              _shimmerBox(
                width: ResponsiveHelper.width(80),
                height: ResponsiveHelper.fontSize(11),
              ),
            ],
          ),
        ),
        if (showBadge) ...[
          SizedBox(width: ResponsiveHelper.spacing(8)),
          _shimmerBox(
            width: ResponsiveHelper.width(50),
            height: ResponsiveHelper.height(24),
            radius: ResponsiveHelper.borderRadius(20),
          ),
        ],
        if (showTrailingCircle) ...[
          SizedBox(width: ResponsiveHelper.spacing(8)),
          _shimmerCircle(34),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header ──────────────────────────────────────
              Row(
                children: [
                //  SizedBox(width: ResponsiveHelper.spacing(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(
                          width: ResponsiveHelper.width(80),
                          height: ResponsiveHelper.fontSize(12),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(8)),
                        _shimmerBox(
                          width: ResponsiveHelper.width(140),
                          height: ResponsiveHelper.fontSize(16),
                        ),
                      ],
                    ),
                  ),
                  _shimmerCircle(36),
                ],
              ),

              SizedBox(height: ResponsiveHelper.spacing(20)),

              // ── Gut Health Score ─────────────────────────────
              _card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _shimmerBox(
                          width: ResponsiveHelper.width(120),
                          height: ResponsiveHelper.height(24),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(24)),

                        _shimmerBox(
                          width: ResponsiveHelper.width(60),
                          height: ResponsiveHelper.height(24),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(24)),
                        _shimmerBox(
                          width: ResponsiveHelper.width(60),
                          height: ResponsiveHelper.height(24),
                        ),
                      ],
                    ),
                    _shimmerCircle(90),
                  ],
                ),
              ),

              SizedBox(height: ResponsiveHelper.spacing(20)),

              // ── Gentle Note ──────────────────────────────────
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(
                      width: ResponsiveHelper.width(100),
                      height: ResponsiveHelper.height(13),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),
                    _shimmerBox(
                      width: double.infinity,
                      height: ResponsiveHelper.height(13),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(6)),
                    _shimmerBox(
                      width: ResponsiveHelper.width(200),
                      height: ResponsiveHelper.height(13),
                    ),
                  ],
                ),
              ),

              SizedBox(height: ResponsiveHelper.spacing(20)),

              // ── Action Buttons ───────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _shimmerBox(
                      width: double.infinity,
                      height: ResponsiveHelper.buttonHeight(52),
                      radius: ResponsiveHelper.borderRadius(12),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(10)),
                  Expanded(
                    child: _shimmerBox(
                      width: double.infinity,
                      height: ResponsiveHelper.buttonHeight(52),
                      radius: ResponsiveHelper.borderRadius(12),
                    ),
                  ),
                ],
              ),

              SizedBox(height: ResponsiveHelper.spacing(20)),

              // ── Recent Activity label ────────────────────────
              _shimmerBox(
                width: ResponsiveHelper.width(130),
                height: ResponsiveHelper.fontSize(14),
              ),
              SizedBox(height: ResponsiveHelper.spacing(12)),

              _shimmerBox(
                width: ResponsiveHelper.width(90),
                height: ResponsiveHelper.fontSize(13),
              ),
              SizedBox(height: ResponsiveHelper.spacing(12)),

              // ── Food Logged list ─────────────────────────────
              _card(
                child: Column(
                  children: List.generate(3, (i) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: i < 2 ? ResponsiveHelper.spacing(12) : 0,
                      ),
                      child: _logRow(showTrailingCircle: true),
                    );
                  }),
                ),
              ),

              SizedBox(height: ResponsiveHelper.spacing(12)),

              // ── Symptom Logged label ─────────────────────────
              _shimmerBox(
                width: ResponsiveHelper.width(110),
                height: ResponsiveHelper.height(13),
              ),
              SizedBox(height: ResponsiveHelper.spacing(8)),

              // ── Symptom Cards ────────────────────────────────
              _card(
                child: Column(
                  children: List.generate(2, (i) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: i < 1 ? ResponsiveHelper.spacing(12) : 0,
                      ),
                      child: _logRow(showBadge: true),
                    );
                  }),
                ),
              ),

              SizedBox(height: ResponsiveHelper.spacing(12)),

              // ── See All Logs button ──────────────────────────
              _shimmerBox(
                width: double.infinity,
                height: ResponsiveHelper.buttonHeight(44),
                radius: ResponsiveHelper.borderRadius(12),
              ),

              SizedBox(height: ResponsiveHelper.spacing(20)),
            ],
          ),
        ),
      ),
    );
  }
}