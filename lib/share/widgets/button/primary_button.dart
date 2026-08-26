import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../helper/responsive_helper/responsive_helper.dart';
import '../../../utils/color/app_colors.dart';
import '../../../utils/extension/base_extension.dart';

/*
class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool outlined;
  final Widget? prefixIcon;// Optional icon

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onTap,
    this.outlined = false,
    this.prefixIcon, // Not required
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:
          outlined ? Colors.transparent : AppColors.primaryColor,
          foregroundColor:
          outlined ? AppColors.primaryColor : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: outlined
                ? const BorderSide(color: AppColors.primaryColor)
                : BorderSide.none,
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              const SizedBox(width: 8),
            ],
            Text(title, style: context.bodyMedium),
          ],
        ),
      ),
    );
  }
}
*/


/*
class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool outlined;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? height;
  final double? fontSize;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onTap,
    this.outlined = false,
    this.prefixIcon,
    this.suffixIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.height,
    this.fontSize,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.primaryColor;
    final fgColor = foregroundColor ?? AppColors.white;

    final buttonStyle = ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: outlined ? Colors.transparent : bgColor,
      foregroundColor: outlined ? bgColor : fgColor,
      minimumSize: Size(double.infinity, ResponsiveHelper.buttonHeight(height ?? 52)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
        side: outlined
            ? BorderSide(color: bgColor)
            : BorderSide.none,
      ),
      textStyle: GoogleFonts.poppins(
        fontSize: ResponsiveHelper.fontSize(fontSize ?? 16),
        fontWeight: FontWeight.w600,
      ),
    );

    return SizedBox(
      height: ResponsiveHelper.buttonHeight(height ?? 52),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: buttonStyle,
        //onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              SizedBox(width: ResponsiveHelper.spacing(8)),
            ],
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                maxLines: 1,
                style: context.bodyMedium.copyWith(
                  fontSize: ResponsiveHelper.fontSize(fontSize ?? 16),
                  fontWeight: FontWeight.w600,
                  color: outlined ? bgColor : fgColor,
                ),
              ),
            ),
            if (suffixIcon != null) ...[          // ✅ added
              SizedBox(width: ResponsiveHelper.spacing(8)),
              suffixIcon!,
            ],
          ],
        ),
      ),
    );
  }
}
*/
class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool outlined;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? height;
  final double? fontSize;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onTap,
    this.outlined = false,
    this.prefixIcon,
    this.suffixIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.height,
    this.fontSize,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.primaryColor;
    final fgColor = foregroundColor ?? AppColors.white;

    final buttonStyle = ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: outlined ? Colors.transparent : bgColor,
      foregroundColor: outlined ? bgColor : fgColor,
      minimumSize: Size(
        double.infinity,
        ResponsiveHelper.buttonHeight(height ?? 52),
      ),
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
        side: outlined ? BorderSide(color: bgColor) : BorderSide.none,
      ),
      textStyle: GoogleFonts.poppins(
        fontSize: ResponsiveHelper.fontSize(fontSize ?? 16),
        fontWeight: FontWeight.w600,
      ),
    );

    return SizedBox(
      height: ResponsiveHelper.buttonHeight(height ?? 52),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: buttonStyle,
        child: isLoading
            ? SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: outlined ? bgColor : fgColor,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              SizedBox(width: ResponsiveHelper.spacing(8)),
            ],
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                maxLines: 1,
                style: context.bodyMedium.copyWith(
                  fontSize: ResponsiveHelper.fontSize(fontSize ?? 16),
                  fontWeight: FontWeight.w600,
                  color: outlined ? bgColor : fgColor,
                ),
              ),
            ),
            if (suffixIcon != null) ...[
              SizedBox(width: ResponsiveHelper.spacing(8)),
              suffixIcon!,
            ],
          ],
        ),
      ),
    );
  }
}


/*
// Normal primary button
PrimaryButton(
  title: 'Login',
  onTap: () {},
)

// Outlined button
PrimaryButton(
  title: 'Cancel',
  onTap: () {},
  outlined: true,
)

// Orange button (log food)
PrimaryButton(
  title: 'Log Food',
  onTap: () {},
  backgroundColor: AppColors.orange,
  foregroundColor: AppColors.black,
)

// Danger/red button
PrimaryButton(
  title: 'Delete Account',
  onTap: () {},
  backgroundColor: AppColors.errorColor,
)

// Custom height & font
PrimaryButton(
  title: 'Get Started',
  onTap: () {},
  height: 60,
  fontSize: 18,
)

// With suffix icon
PrimaryButton(
  title: 'Next',
  onTap: () {},
  suffixIcon: Icon(Icons.arrow_forward, color: AppColors.white),
)

// With both prefix and suffix
PrimaryButton(
  title: 'Verified',
  onTap: () {},
  prefixIcon: Icon(Icons.lock, color: AppColors.white),
  suffixIcon: Icon(Icons.check, color: AppColors.white),
)


*/