

import 'dart:ui';

import 'package:ezygut/utils/enum/app_enum.dart';

class PatientModel {
  final String name;
  final int age;
  final String time;
  final PatientStatus status;
  final String image;
  final VoidCallback? onTap;

  PatientModel({
    required this.name,
    required this.age,
    required this.time,
    required this.status,
    required this.image,
    this.onTap,
  });
}