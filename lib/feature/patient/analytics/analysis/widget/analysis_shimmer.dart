import 'package:flutter/material.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';

class AnalysisShimmer extends StatefulWidget {
  const AnalysisShimmer({super.key});

  @override
  State<AnalysisShimmer> createState() => _AnalysisShimmerState();
}

class _AnalysisShimmerState extends State<AnalysisShimmer>
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

  /// _SectionHeader shimmer — colored bar + label
  Widget _sectionHeader(double sw) {
    return Row(
      children: [
        _box(w: 4, h: ResponsiveHelper.height(18), radius: 2),
        SizedBox(width: ResponsiveHelper.width(8)),
        _box(w: sw * 0.22, h: ResponsiveHelper.height(14)),
      ],
    );
  }

  /// _TriggerCard shimmer — icon box + food name + badge
  Widget _triggerCard(double sw) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.height(8)),
      child: Container(
        width: double.infinity,
        padding: ResponsiveHelper.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            _box(
              w: ResponsiveHelper.iconSize(40),
              h: ResponsiveHelper.iconSize(40),
              radius: 8,
            ),
            SizedBox(width: ResponsiveHelper.width(12)),
            Expanded(
              child: _box(w: sw * 0.40, h: ResponsiveHelper.height(22)),
            ),
            SizedBox(width: ResponsiveHelper.width(8)),
            _box(w: sw * 0.18, h: ResponsiveHelper.height(30), radius: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Padding(
      padding: ResponsiveHelper.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ── DetectedTriggersWidget shimmer ─────────────────────────
            Container(
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
                  /// title
                  _box(w: sw * 0.45, h: ResponsiveHelper.height(18)),
                  SizedBox(height: ResponsiveHelper.height(8)),

                  /// subtitle
                  _box(w: double.infinity, h: ResponsiveHelper.height(14)),
                  SizedBox(height: ResponsiveHelper.height(6)),
                  _box(w: sw * 0.70, h: ResponsiveHelper.height(14)),
                  SizedBox(height: ResponsiveHelper.height(20)),

                  /// High section
                  _sectionHeader(sw),
                  SizedBox(height: ResponsiveHelper.height(10)),
                  _triggerCard(sw),
                  _triggerCard(sw),
                  SizedBox(height: ResponsiveHelper.height(8)),

                  /// Medium section
                  _sectionHeader(sw),
                  SizedBox(height: ResponsiveHelper.height(10)),
                  _triggerCard(sw),
                  SizedBox(height: ResponsiveHelper.height(8)),

                  /// Low section
                  _sectionHeader(sw),
                  SizedBox(height: ResponsiveHelper.height(10)),
                  _triggerCard(sw),
                ],
              ),
            ),

            SizedBox(height: ResponsiveHelper.height(16)),

            /// ── ScoreTrendCard shimmer ──────────────────────────────────
            Container(
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
                  /// title
                  _box(w: sw * 0.35, h: ResponsiveHelper.height(18)),
                  SizedBox(height: ResponsiveHelper.height(16)),

                  /// chart area — Y axis labels + bars
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      /// Y axis labels
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          5,
                              (i) => Padding(
                            padding: EdgeInsets.only(
                                bottom: i < 4
                                    ? ResponsiveHelper.height(sh * 0.024)
                                    : 0),
                            child: _box(
                              w: sw * 0.06,
                              h: ResponsiveHelper.height(11),
                              radius: 4,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.width(8)),

                      /// Chart body
                      Expanded(
                        child: Column(
                          children: [
                            _box(
                              w: double.infinity,
                              h: ResponsiveHelper.height(sh * 0.155),
                              radius: 8,
                            ),
                            SizedBox(height: ResponsiveHelper.height(8)),

                            /// X axis day labels
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                7,
                                    (_) => _box(
                                  w: sw * 0.07,
                                  h: ResponsiveHelper.height(11),
                                  radius: 4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: ResponsiveHelper.height(24)),
          ],
        ),
      ),
    );
  }
}