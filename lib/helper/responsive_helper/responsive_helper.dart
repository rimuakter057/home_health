// ignore_for_file: unused_field

import 'package:flutter/material.dart';

/// Responsive Helper for perfect scaling on iPhone and iPad
class ResponsiveHelper {
  static late double _screenWidth;
  static late double _screenHeight;
  static late bool _isTablet;

  /// Initialize responsive helper
  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;
    _isTablet = _screenWidth > 600;
  }

  /// Check if device is tablet
  static bool get isTablet => _isTablet;

  /// Get screen width
  static double get screenWidth => _screenWidth;

  /// Get screen height
  static double get screenHeight => _screenHeight;

  /// Get responsive font size
  static double fontSize(double phoneSize) {
    if (_isTablet) {
      if (_screenWidth > 800) {
        return phoneSize * 1.3; // iPad Pro
      }
      return phoneSize * 1.15; // iPad mini/regular
    }
    return phoneSize;
  }

  static titleFontSize(double phoneSize) {
    if (_isTablet) {
      if (_screenWidth > 800) {
        return phoneSize * 1.4; // iPad Pro
      }
      return phoneSize * 1.2; // iPad mini/regular
    }
  }

  /// Get responsive spacing (for gaps between elements)
  static double spacing(double phoneSpacing) {
    if (_isTablet) {
      if (_screenWidth > 800) {
        return phoneSpacing * 1.4;
      }
      return phoneSpacing * 1.2;
    }
    return phoneSpacing;
  }

  /// Get responsive padding (for edge padding)
  static double padding(double phonePadding) {
    if (_isTablet) {
      if (_screenWidth > 800) {
        return phonePadding * 1.8; // iPad Pro - reduced from 2.5
      }
      return phonePadding * 1.5; // iPad regular - reduced from 2.5
    }
    return phonePadding;
  }


  /// EdgeInsets.all responsive
  static EdgeInsets all(double value) {
    return EdgeInsets.all(padding(value));
  }

  /// EdgeInsets.symmetric responsive
  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(
      horizontal: padding(horizontal),
      vertical: padding(vertical),
    );
  }

  /// Get max content width
  static double get maxContentWidth {
    if (_isTablet) {
      return _screenWidth > 800 ? 600 : 500;
    }
    return _screenWidth;
  }

  /// Get responsive width multiplier
  static double width(double phoneWidth) {
    if (_isTablet) {
      if (_screenWidth > 800) {
        return phoneWidth * 1.3;
      }
      return phoneWidth * 1.2;
    }
    return phoneWidth;
  }

  /// Get responsive height multiplier
  static double height(double phoneHeight) {
    if (_isTablet) {
      if (_screenWidth > 800) {
        return phoneHeight * 1.3;
      }
      return phoneHeight * 1.2;
    }
    return phoneHeight;
  }

  /// Get responsive icon size
  static double iconSize(double phoneIconSize) {
    if (_isTablet) {
      if (_screenWidth > 800) {
        return phoneIconSize * 1.4;
      }
      return phoneIconSize * 1.2;
    }
    return phoneIconSize;
  }

  /// Get responsive border width
  static double borderWidth(double phoneBorderWidth) {
    if (_isTablet) {
      return phoneBorderWidth * 1.5;
    }
    return phoneBorderWidth;
  }

  /// Get responsive border radius
  static double borderRadius(double phoneRadius) {
    if (_isTablet) {
      if (_screenWidth > 800) {
        return phoneRadius * 1.4;
      }
      return phoneRadius * 1.2;
    }
    return phoneRadius;
  }

  /// Get responsive button height
  static double buttonHeight(double phoneHeight) {
    if (_isTablet) {
      if (_screenWidth > 800) {
        return phoneHeight * 1.2; // iPad Pro
      }
      return phoneHeight * 1.15; // iPad regular
    }
    return phoneHeight;
  }
}
