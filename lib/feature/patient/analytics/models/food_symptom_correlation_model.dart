enum BubbleSeverity { none, low, medium, high, critical }

class CulpritFood {
  final int usdaId;
  final String foodName;
  final int timesTriggered;

  CulpritFood({
    required this.usdaId,
    required this.foodName,
    required this.timesTriggered,
  });

  factory CulpritFood.fromJson(Map<String, dynamic> json) {
    return CulpritFood(
      usdaId: json['usda_id'] as int,
      foodName: json['food_name'] as String,
      timesTriggered: json['times_triggered'] as int,
    );
  }
}

class FoodSymptomCorrelation {
  final String symptom;
  final String? foodName;
  final String message;
  final int totalLogged;
  final int timesTriggered;
  final double percentage;
  final List<CulpritFood> culpritFoods;

  FoodSymptomCorrelation({
    required this.symptom,
    this.foodName,
    required this.message,
    required this.totalLogged,
    required this.timesTriggered,
    required this.percentage,
    required this.culpritFoods,
  });

  factory FoodSymptomCorrelation.fromJson(Map<String, dynamic> json) {
    return FoodSymptomCorrelation(
      symptom: json['symptom'] as String,
      foodName: json['food_name'] as String?,
      message: json['message'] as String,
      totalLogged: json['total_logged'] as int,
      timesTriggered: json['times_triggered'] as int,
      percentage: (json['percentage'] as num).toDouble(),
      culpritFoods: (json['culprit_foods'] as List<dynamic>)
          .map((e) => CulpritFood.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Returns a list of unique food names from culprit foods
  List<String> get uniqueFoodNames =>
      culpritFoods.map((e) => e.foodName).toSet().toList();
}

class FoodSymptomCorrelationResponse {
  final List<FoodSymptomCorrelation> data;

  FoodSymptomCorrelationResponse({required this.data});

  factory FoodSymptomCorrelationResponse.fromJson(Map<String, dynamic> json) {
    return FoodSymptomCorrelationResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) =>
          FoodSymptomCorrelation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Sorted by percentage descending — highest risk first
  List<FoodSymptomCorrelation> get sortedByRisk {
    final sorted = List<FoodSymptomCorrelation>.from(data);
    sorted.sort((a, b) => b.percentage.compareTo(a.percentage));
    return sorted;
  }

  /// All unique food names across every symptom entry
  List<String> get allUniqueFoods {
    final foods = <String>{};
    for (final entry in data) {
      foods.addAll(entry.uniqueFoodNames);
    }
    return foods.toList();
  }
}