class FoodLogModel {
  final String userId;
  final String mealType;
  final String logMethod;
  final int previousScore;
  final int scoreModifier;
  final int updatedScore;
  final String grade;
  final String summary;
  final List<FoodItem> foods;
  final List<String> recommendations;
  final String loggedAt;

  FoodLogModel({
    required this.userId,
    required this.mealType,
    required this.logMethod,
    required this.previousScore,
    required this.scoreModifier,
    required this.updatedScore,
    required this.grade,
    required this.summary,
    required this.foods,
    required this.recommendations,
    required this.loggedAt,
  });

  factory FoodLogModel.fromJson(Map<String, dynamic> json) {
    return FoodLogModel(
      userId: json['userId'] ?? '',
      mealType: json['mealType'] ?? '',
      logMethod: json['logMethod'] ?? '',
      previousScore: json['previousScore'] ?? 0,
      scoreModifier: json['scoreModifier'] ?? 0,
      updatedScore: json['updatedScore'] ?? 0,
      grade: json['grade'] ?? '',
      summary: json['summary'] ?? '',
      foods: (json['foods'] as List? ?? [])
          .map((e) => FoodItem.fromJson(e))
          .toList(),
      recommendations: List<String>.from(json['recommendations'] ?? []),
      loggedAt: json['loggedAt'] ?? '',
    );
  }
}

class FoodItem {
  final String foodName;
  final int quantity;
  final String unit;

  FoodItem({
    required this.foodName,
    required this.quantity,
    required this.unit,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      foodName: json['raw_food'] ?? json['food_description'] ?? '',
      quantity: json['quantity'] ?? 100,
      unit: json['unit'] ?? 'g',
    );
  }

  Map<String, dynamic> toJson() => {
    'foodName': foodName,
    'quantity': quantity,
    'unit': unit,
  };
}