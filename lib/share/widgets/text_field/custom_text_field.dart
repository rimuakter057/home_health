import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import '../../../helper/responsive_helper/responsive_helper.dart';
import '../../../utils/color/app_colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.cursorColor = AppColors.primaryColor,
    this.inputTextStyle,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.minLines = 1,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.validator,
    this.hintText,
    this.title,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.isPassword = false,
    this.enabled = true,
    this.isLoading = false,
    this.errorText,
    this.inputFormatters,
    this.readOnly = false,
    this.maxLength,
    this.fillColor,
    this.autovalidateMode,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Color cursorColor;
  final TextStyle? inputTextStyle;
  final TextAlign textAlign;
  final int maxLines;
  final int minLines;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final String? Function(String?)? validator;
  final String? hintText;
  final String? title;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BoxConstraints? prefixIconConstraints;  // Add this
  final BoxConstraints? suffixIconConstraints;  // Add this (optional)
  final bool isPassword;
  final bool enabled;
  final bool isLoading;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final int? maxLength;
  final Color? fillColor;
  final AutovalidateMode? autovalidateMode;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late ValueNotifier<bool> _obscureNotifier;
  FocusNode? _internalFocusNode;
  bool _isUnfocusedValidated = false;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _obscureNotifier = ValueNotifier(widget.isPassword);
    _effectiveFocusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!_effectiveFocusNode.hasFocus) {
      if (!_isUnfocusedValidated && mounted) {
        setState(() {
          _isUnfocusedValidated = true;
        });
      }
    } else {
      // Rebuild on focus gain so autovalidateMode is disabled while typing
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode)?.removeListener(_handleFocusChange);
      _effectiveFocusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_handleFocusChange);
    _internalFocusNode?.dispose();
    _obscureNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.w500,
            ),
          ),
          Gap(ResponsiveHelper.spacing(12)),
        ],

        ValueListenableBuilder<bool>(
          valueListenable: _obscureNotifier,
          builder: (context, obscure, _) {
            return TextFormField(
              controller: widget.controller,
              focusNode: _effectiveFocusNode,
              enabled: widget.enabled && !widget.isLoading,
              readOnly: widget.readOnly,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              cursorColor: widget.cursorColor,
              style:
                  widget.inputTextStyle ??
                  TextStyle(fontSize: ResponsiveHelper.fontSize(16)),
              textAlign: widget.textAlign,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              maxLength: widget.maxLength,
              inputFormatters: widget.inputFormatters,
              obscureText: widget.isPassword ? obscure : false,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onFieldSubmitted,
              onEditingComplete: widget.onEditingComplete,
              validator: widget.validator,
              autovalidateMode: widget.autovalidateMode ??
                  (_isUnfocusedValidated
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled),
              decoration: InputDecoration(
                hintText: widget.hintText,
                errorText: widget.errorText,

                /// Background color
                filled: true,
                fillColor: widget.fillColor ??
                    AppColors.primaryColor.withOpacity(0.20),


                prefixIcon: widget.prefixIcon,
                prefixIconConstraints: widget.prefixIconConstraints,

                suffixIcon: widget.isPassword
                    ? IconButton(
                  onPressed: () {
                    _obscureNotifier.value = !_obscureNotifier.value;
                  },
                  icon: Icon(
                    obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.secondaryText,
                  ),
                )
                    : widget.isLoading
                    ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
                    : widget.suffixIcon,
                suffixIconConstraints: widget.suffixIconConstraints,

                // Default Border
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(8),
                  ),
                  borderSide: BorderSide(
                    color: AppColors.primaryColor.withOpacity(0.5),
                    width: 1,
                  ),
                ),

                // Focused Border
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(8),
                  ),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 1.5,
                  ),
                ),

                // Error Border
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(8),
                  ),
                  borderSide: const BorderSide(
                    color: AppColors.errorColor,
                    width: 1,
                  ),
                ),

                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(8),
                  ),
                  borderSide: const BorderSide(
                    color: AppColors.errorColor,
                    width: 1.5,
                  ),
                ),
              ),

            );
          },
        ),
      ],
    );
  }
}
