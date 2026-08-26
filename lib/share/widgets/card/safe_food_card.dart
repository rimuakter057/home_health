import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/custom_image/custom_image.dart';
import 'package:flutter/material.dart';
import '../../../utils/color/app_colors.dart';
import '../../../utils/extension/base_extension.dart';
import 'app_card.dart';

class SafeFoodsContainer extends StatelessWidget {
  final List<String> items;
  final bool isLoading;
  final bool isGenerating;
  final VoidCallback? onRefresh;
  final String emptyMessage;
  final bool isPatient;
  const SafeFoodsContainer({
    super.key,
    required this.items,
    this.isLoading = false,
    this.isGenerating = false,
    this.onRefresh, required this.emptyMessage, this.isPatient = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ── Title + Refresh button ──
          Row(
            children: [
              Row(
                children: [
                  Text(
                    "Safe Foods",
                    style: context.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  
                  SizedBox(width: ResponsiveHelper.width(6),),
                  
                  GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColors.bgColor,
                            title:  Text("Safe Food",

                              style: context.bodyLarge.copyWith(color: AppColors.green,fontWeight: FontWeight.w600 ),
                            ),
                            content:  Text(
                              "These foods were not associated with any symptoms after being logged more than three times.",
                              style: context.bodyLarge.copyWith(color: AppColors.primaryColor ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child:  Text("Got it",
                                  style: context.bodyMedium,
                                ),
                              ),
                            ],

                          ),
                        );
                      },
                      child: CustomImage(imageSrc: "assets/icon/i.svg")),
                  
                ],
              ),
              const Spacer(),
              // isGenerating
              //     ? const SizedBox(
              //   width: 18,
              //   height: 18,
              //   child: CircularProgressIndicator(
              //     strokeWidth: 2,
              //     color: AppColors.green,
              //   ),
              // )
              //     : GestureDetector(
              //   onTap: onRefresh,
              //   child: const Icon(
              //     Icons.refresh_rounded,
              //     size: 20,
              //     color: AppColors.green,
              //   ),
              // ),




              if (isPatient) // ← এই condition যোগ করো
                isGenerating
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.green,
                  ),
                )
                    : GestureDetector(
                  onTap: onRefresh,
                  child: const Icon(
                    Icons.refresh_rounded,
                    size: 20,
                    color: AppColors.green,
                  ),
                ),





            ],
          ),

          const SizedBox(height: 16),

          /// ── Loading shimmer / chip list ──
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.green,
                ),
              ),
            )


          else if (items.isEmpty)
              Text(
                emptyMessage.isNotEmpty
                    ? emptyMessage
                    : 'Tap refresh to generate your safe food list.',
                style: context.labelMedium.copyWith(
                  color: AppColors.green,
                ),
              )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: items.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(.10),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: AppColors.green.withOpacity(.20),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 18,
                        color: AppColors.green,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item,
                        style: context.labelMedium.copyWith(
                          color: AppColors.green,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),




          /// show source note when <5
          if (items.isNotEmpty && items.length < 5 && emptyMessage.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment:  MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "NOTE: ",
                  style: context.labelSmall.copyWith(
                    color: AppColors.black,
                      fontWeight: FontWeight.w600
                  ),
                ),
                Expanded(
                  child: Text(
                    emptyMessage,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.bodySmall.copyWith(
                      color: AppColors.primaryColor,fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ],
            ),
          ],



        ],
      ),
    );
  }
}