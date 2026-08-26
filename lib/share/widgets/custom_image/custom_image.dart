import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ImageType { png, svg }

class CustomImage extends StatefulWidget {
  final String imageSrc;
  final Color? imageColor;
  final double? height;
  final double? scale;
  final double? width;
  final double? sizeWidth;
  final double? sizeHeight;
  final ImageType imageType;
  final BoxFit? fit;
  final double horizontal;
  final double vertical;
  final BoxFit? boxFit;

  const CustomImage({
    required this.imageSrc,
    this.imageColor,
    this.sizeWidth,
    this.sizeHeight,
    this.imageType = ImageType.svg,
    super.key,
    this.fit,
    this.scale,
    this.horizontal = 0.0,
    this.vertical = 0.0,
    this.boxFit,
    this.height,
    this.width,
  });

  @override
  State<CustomImage> createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage> {
  late Widget imageWidget;

  @override
  Widget build(BuildContext context) {
    if (widget.imageSrc.endsWith('.svg')) {
      imageWidget = SvgPicture.asset(
        widget.imageSrc,
        color: widget.imageColor,
        height: widget.height != null
            ? ResponsiveHelper.iconSize(widget.height!)
            : null,

        width: widget.width != null
            ? ResponsiveHelper.iconSize(widget.width!)
            : null,
        fit: widget.boxFit ?? BoxFit.cover,
      );
    } else if (widget.imageSrc.endsWith('.png')) {
      imageWidget = Image.asset(
        widget.imageSrc,
        fit: widget.fit,
        color: widget.imageColor,
        height: widget.height != null
            ? ResponsiveHelper.iconSize(widget.height!)
            : null,

        width: widget.width != null
            ? ResponsiveHelper.iconSize(widget.width!)
            : null,
        //height: common_widget.height,
        // width: common_widget.width,
        scale: widget.scale ?? 1,
      );
    } else {
      imageWidget = const SizedBox(); // fallback safety
    }

    return Container(
      margin: ResponsiveHelper.symmetric(
        horizontal: widget.horizontal,
        vertical: widget.vertical,
      ),

      height: widget.height != null
          ? ResponsiveHelper.iconSize(widget.height!)
          : null,

      width: widget.width != null
          ? ResponsiveHelper.iconSize(widget.width!)
          : null,
      child: imageWidget,
    );
  }
}



