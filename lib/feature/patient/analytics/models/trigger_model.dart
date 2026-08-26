import 'dart:ui';

class TriggerCommonModel {
  String? symptom;
  int? days;
  List<Details>? high;
  List<Details>? medium;
  List<Details>? low;
  int? totalCulpritFoods;
  bool? hasData;
  String? message;

  TriggerCommonModel({
    this.symptom,
    this.days,
    this.high,
    this.medium,
    this.low,
    this.totalCulpritFoods,
    this.hasData,
    this.message,
  });

  TriggerCommonModel.fromJson(Map<String, dynamic> json) {
    symptom = json['symptom'];
    days = json['days'];
    if (json['high'] != null) {
      high = (json['high'] as List).map((e) => Details.fromJson(e)).toList();
    }
    if (json['medium'] != null) {
      medium = (json['medium'] as List).map((e) => Details.fromJson(e)).toList();
    }
    if (json['low'] != null) {
      low = (json['low'] as List).map((e) => Details.fromJson(e)).toList();
    }
    totalCulpritFoods = json['total_culprit_foods'];
    hasData = json['has_data'];
    message = json['message'];
  }
}

class Details {
  int? usdaId;
  String? foodName;
  int? timesTriggered;
  int? totalTimesEaten;
  int? percentage;
  String? riskLevel;

  Details({
    this.usdaId,
    this.foodName,
    this.timesTriggered,
    this.totalTimesEaten,
    this.percentage,
    this.riskLevel,
  });

  Details.fromJson(Map<String, dynamic> json) {
    usdaId = json['usda_id'];
    foodName = json['food_name'];
    timesTriggered = json['times_triggered'];
    totalTimesEaten = json['total_times_eaten'];
    percentage = json['percentage'];
    riskLevel = json['risk_level'];
  }
}


// ── TriggerLevel Enum ─────────────────────────────────────────────────────────

enum TriggerLevel { high, medium, low }

extension TriggerLevelX on TriggerLevel {
  String get label {
    switch (this) {
      case TriggerLevel.high:   return 'High';
      case TriggerLevel.medium: return 'Medium';
      case TriggerLevel.low:    return 'Low';
    }
  }

  Color get color {
    switch (this) {
      case TriggerLevel.high:   return const Color(0xFFE8604C);
      case TriggerLevel.medium: return const Color(0xFFE8A84C);
      case TriggerLevel.low:    return const Color(0xFF9E9E9E);
    }
  }
}