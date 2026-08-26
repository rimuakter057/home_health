class FoodLogListModel {
  final String id;
  final String mealType;
  final List<FoodItem> foods;
  final List<FoodDetail> foodDetails;
  final MealCountsModel mealCounts; // single object
  final int updatedScore;
  final int foodScore;
  final String grade;
  final String summary;
  final DateTime loggedAt;

  FoodLogListModel({
    required this.id,
    required this.mealType,
    required this.foods,
    required this.foodDetails,
    required this.mealCounts,
    required this.updatedScore,
    required this.foodScore,
    required this.grade,
    required this.summary,
    required this.loggedAt,
  });

  factory FoodLogListModel.fromJson(Map<String, dynamic> json) {
    return FoodLogListModel(
      id: json['_id'] ?? '',
      mealType: json['mealType'] ?? '',
      foods: (json['foods'] as List<dynamic>? ?? [])
          .map((f) => FoodItem.fromJson(f))
          .toList(),
      foodDetails: (json['foodDetails'] as List<dynamic>? ?? [])
          .map((f) => FoodDetail.fromJson(f))
          .toList(),
      mealCounts: json['mealCounts'] != null
          ? MealCountsModel.fromJson(json['mealCounts'])
          : MealCountsModel(breakfast: 0, lunch: 0, dinner: 0, snack: 0),
      updatedScore: json['updatedScore'] ?? 0,
      foodScore: json['food_score'] ?? 0,
      grade: json['grade'] ?? '',
      summary: json['summary'] ?? '',
      loggedAt: DateTime.tryParse(json['loggedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

// ── Food Item ─────────────────────────────────────────
class FoodItem {
  final String foodDescription;
  final String rawFood;
  final int quantity;
  final String unit;

  FoodItem({
    required this.foodDescription,
    required this.rawFood,
    required this.quantity,
    required this.unit,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      foodDescription: json['food_description'] ?? '',
      rawFood: json['raw_food'] ?? '',
      quantity: json['quantity'] ?? 0,
      unit: json['unit'] ?? '',
    );
  }
}

// ── Food Detail ───────────────────────────────────────
class FoodDetail {
  final NutrientProfile nutrientProfile;

  FoodDetail({required this.nutrientProfile});

  factory FoodDetail.fromJson(Map<String, dynamic> json) {
    return FoodDetail(
      nutrientProfile: NutrientProfile.fromJson(
        json['nutrient_profile'] ?? {},
      ),
    );
  }
}

// ── Nutrient Profile ──────────────────────────────────
class NutrientProfile {
  final double calories;
  final double protein;
  final double totalFat;
  final double carbs;
  final double sodium;
  final double sugar;
  final double calcium;
  final double iron;
  final double? potassium;
  final double vitaminC;
  final double? vitaminE;
  final double? vitaminD;
  final double portionGrams;

  NutrientProfile({
    required this.calories,
    required this.protein,
    required this.totalFat,
    required this.carbs,
    required this.sodium,
    required this.sugar,
    required this.calcium,
    required this.iron,
    this.potassium,
    required this.vitaminC,
    this.vitaminE,
    this.vitaminD,
    required this.portionGrams,
  });

  factory NutrientProfile.fromJson(Map<String, dynamic> json) {
    return NutrientProfile(
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      totalFat: (json['total_fat'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      sodium: (json['sodium'] ?? 0).toDouble(),
      sugar: (json['sugar'] ?? 0).toDouble(),
      calcium: (json['calcium'] ?? 0).toDouble(),
      iron: (json['iron'] ?? 0).toDouble(),
      potassium: json['potassium'] != null
          ? (json['potassium']).toDouble()
          : null,
      vitaminC: (json['vitamin_c'] ?? 0).toDouble(),
      vitaminE: json['vitamin_e'] != null
          ? (json['vitamin_e']).toDouble()
          : null,
      vitaminD: json['vitamin_d'] != null
          ? (json['vitamin_d']).toDouble()
          : null,
      portionGrams: (json['portion_grams'] ?? 0).toDouble(),
    );
  }
}


// ── Meal Counts ─────────────────────────────────────────
class MealCountsModel {
  final int breakfast;
  final int lunch;
  final int dinner;
  final int snack;

  MealCountsModel({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snack,
  });

  factory MealCountsModel.fromJson(Map<String, dynamic> json) {
    return MealCountsModel(
      breakfast: json['Breakfast'] ?? 0,
      lunch: json['Lunch'] ?? 0,
      dinner: json['Dinner'] ?? 0,
      snack: json['Snack'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Breakfast': breakfast,
      'Lunch': lunch,
      'Dinner': dinner,
      'Snack': snack,
    };
  }
}