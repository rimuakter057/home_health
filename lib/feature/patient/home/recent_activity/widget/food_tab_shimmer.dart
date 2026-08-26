import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';

class FoodTabShimmer extends StatefulWidget {
  const FoodTabShimmer({super.key});

  @override
  State<FoodTabShimmer> createState() => _FoodTabShimmerState();
}

class _FoodTabShimmerState extends State<FoodTabShimmer>
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

  /// MealCardAll shimmer
  /// icon box (left) + title + time + food items (right)
  Widget _mealCard(double sw) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.height(10)),
      padding: ResponsiveHelper.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// meal type icon box
          _box(
            w: ResponsiveHelper.iconSize(42),
            h: ResponsiveHelper.iconSize(42),
            radius: 10,
          ),

          SizedBox(width: ResponsiveHelper.width(12)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// title row + time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _box(w: sw * 0.42, h: ResponsiveHelper.height(15)),
                    _box(w: sw * 0.14, h: ResponsiveHelper.height(13)),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.height(10)),

                /// food item lines
                _box(w: sw * 0.55, h: ResponsiveHelper.height(13)),
                SizedBox(height: ResponsiveHelper.height(6)),
                _box(w: sw * 0.40, h: ResponsiveHelper.height(13)),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        SizedBox(height: ResponsiveHelper.height(8)),

        /// Date header shimmer
        _box(w: sw * 0.38, h: ResponsiveHelper.height(16)),
        SizedBox(height: ResponsiveHelper.height(12)),

        /// Meal cards
        _mealCard(sw),
        _mealCard(sw),

        SizedBox(height: ResponsiveHelper.height(16)),

        /// Second date group
        _box(w: sw * 0.30, h: ResponsiveHelper.height(16)),
        SizedBox(height: ResponsiveHelper.height(12)),

        _mealCard(sw),
      ],
    );
  }
}