class FoodLogTabModel {
  String? sId;
  String? userId;
  String? logMethod;
  String? mealType;
  List<Foods>? foods;
  String? rawText;
  int? previousScore;
  int? scoreModifier;
  int? updatedScore;
  String? grade;
  String? summary;
  List<dynamic>? foodDetails;
  List<dynamic>? recommendations;
  String? loggedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  FoodLogTabModel({
    this.sId,
    this.userId,
    this.logMethod,
    this.mealType,
    this.foods,
    this.rawText,
    this.previousScore,
    this.scoreModifier,
    this.updatedScore,
    this.grade,
    this.summary,
    this.foodDetails,
    this.recommendations,
    this.loggedAt,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  FoodLogTabModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    logMethod = json['logMethod'];
    mealType = json['mealType'];

    if (json['foods'] != null) {
      foods = (json['foods'] as List)
          .map((v) => Foods.fromJson(v))
          .toList();
    }

    rawText = json['rawText'];
    previousScore = json['previousScore'];
    scoreModifier = json['scoreModifier'];
    updatedScore = json['updatedScore'];
    grade = json['grade'];
    summary = json['summary'];

    foodDetails = json['foodDetails'] != null
        ? List<dynamic>.from(json['foodDetails'])
        : null;

    recommendations = json['recommendations'] != null
        ? List<dynamic>.from(json['recommendations'])
        : null;

    loggedAt = json['loggedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['_id'] = sId;
    data['userId'] = userId;
    data['logMethod'] = logMethod;
    data['mealType'] = mealType;

    if (foods != null) {
      data['foods'] = foods!.map((v) => v.toJson()).toList();
    }

    data['rawText'] = rawText;
    data['previousScore'] = previousScore;
    data['scoreModifier'] = scoreModifier;
    data['updatedScore'] = updatedScore;
    data['grade'] = grade;
    data['summary'] = summary;
    data['foodDetails'] = foodDetails;
    data['recommendations'] = recommendations;
    data['loggedAt'] = loggedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;

    return data;
  }
}

class Foods {
  int? usdaId;
  int? quantity;
  String? unit;
  String? foodDescription;
  String? rawFood;

  Foods({
    this.usdaId,
    this.quantity,
    this.unit,
    this.foodDescription,
    this.rawFood,
  });

  Foods.fromJson(Map<String, dynamic> json) {
    usdaId = json['usda_id'];
    quantity = json['quantity'];
    unit = json['unit'];
    foodDescription = json['food_description'];
    rawFood = json['raw_food'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['usda_id'] = usdaId;
    data['quantity'] = quantity;
    data['unit'] = unit;
    data['food_description'] = foodDescription;
    data['raw_food'] = rawFood;
    return data;
  }
}