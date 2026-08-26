class MainHomeModel {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  MainHomeModel({this.success, this.statusCode, this.message, this.data});

  MainHomeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['chat'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['chat'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Logs>? logs;
  MealCounts? mealCounts;
  Pagination? pagination;

  Data({this.logs, this.mealCounts, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['logs'] != null) {
      logs = <Logs>[];
      json['logs'].forEach((v) {
        logs!.add(new Logs.fromJson(v));
      });
    }
    mealCounts = json['mealCounts'] != null
        ? new MealCounts.fromJson(json['mealCounts'])
        : null;
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.logs != null) {
      data['logs'] = this.logs!.map((v) => v.toJson()).toList();
    }
    if (this.mealCounts != null) {
      data['mealCounts'] = this.mealCounts!.toJson();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Logs {
  String? sId;
  String? userId;
  String? logMethod;
  String? mealType;
  List<Foods>? foods;
  int? previousScore;
  int? scoreModifier;
  int? updatedScore;
  String? grade;
  String? summary;
  List<FoodDetails>? foodDetails;
  List<String>? recommendations;
  String? loggedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Logs(
      {this.sId,
        this.userId,
        this.logMethod,
        this.mealType,
        this.foods,
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
        this.iV});

  Logs.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    logMethod = json['logMethod'];
    mealType = json['mealType'];
    if (json['foods'] != null) {
      foods = <Foods>[];
      json['foods'].forEach((v) {
        foods!.add(new Foods.fromJson(v));
      });
    }
    previousScore = json['previousScore'];
    scoreModifier = json['scoreModifier'];
    updatedScore = json['updatedScore'];
    grade = json['grade'];
    summary = json['summary'];
    if (json['foodDetails'] != null) {
      foodDetails = <FoodDetails>[];
      json['foodDetails'].forEach((v) {
        foodDetails!.add(new FoodDetails.fromJson(v));
      });
    }
    recommendations = json['recommendations'].cast<String>();
    loggedAt = json['loggedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['logMethod'] = this.logMethod;
    data['mealType'] = this.mealType;
    if (this.foods != null) {
      data['foods'] = this.foods!.map((v) => v.toJson()).toList();
    }
    data['previousScore'] = this.previousScore;
    data['scoreModifier'] = this.scoreModifier;
    data['updatedScore'] = this.updatedScore;
    data['grade'] = this.grade;
    data['summary'] = this.summary;
    if (this.foodDetails != null) {
      data['foodDetails'] = this.foodDetails!.map((v) => v.toJson()).toList();
    }
    data['recommendations'] = this.recommendations;
    data['loggedAt'] = this.loggedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Foods {
  int? usdaId;
  int? quantity;
  String? unit;
  String? foodDescription;
  String? rawFood;

  Foods(
      {this.usdaId,
        this.quantity,
        this.unit,
        this.foodDescription,
        this.rawFood});

  Foods.fromJson(Map<String, dynamic> json) {
    usdaId = json['usda_id'];
    quantity = json['quantity'];
    unit = json['unit'];
    foodDescription = json['food_description'];
    rawFood = json['raw_food'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usda_id'] = this.usdaId;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['food_description'] = this.foodDescription;
    data['raw_food'] = this.rawFood;
    return data;
  }
}

class FoodDetails {
  int? usdaId;
  String? foodDescription;
  int? portionGrams;
  int? scoreModifier;
  int? nutrientModifier;
  int? hfModifier;
  String? digestibility;
  double? hfConfidence;
  String? mealTypeNote;
  NutrientProfile? nutrientProfile;
  List<NutrientImpacts>? nutrientImpacts;
  List<String>? nutrientNotes;
  String? hfNote;

  FoodDetails(
      {this.usdaId,
        this.foodDescription,
        this.portionGrams,
        this.scoreModifier,
        this.nutrientModifier,
        this.hfModifier,
        this.digestibility,
        this.hfConfidence,
        this.mealTypeNote,
        this.nutrientProfile,
        this.nutrientImpacts,
        this.nutrientNotes,
        this.hfNote});

  FoodDetails.fromJson(Map<String, dynamic> json) {
    usdaId = json['usda_id'];
    foodDescription = json['food_description'];
    portionGrams = json['portion_grams'];
    scoreModifier = json['score_modifier'];
    nutrientModifier = json['nutrient_modifier'];
    hfModifier = json['hf_modifier'];
    digestibility = json['digestibility'];
    hfConfidence = json['hf_confidence'];
    mealTypeNote = json['meal_type_note'];
    nutrientProfile = json['nutrient_profile'] != null
        ? new NutrientProfile.fromJson(json['nutrient_profile'])
        : null;
    if (json['nutrient_impacts'] != null) {
      nutrientImpacts = <NutrientImpacts>[];
      json['nutrient_impacts'].forEach((v) {
        nutrientImpacts!.add(new NutrientImpacts.fromJson(v));
      });
    }
    nutrientNotes = json['nutrient_notes'].cast<String>();
    hfNote = json['hf_note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usda_id'] = this.usdaId;
    data['food_description'] = this.foodDescription;
    data['portion_grams'] = this.portionGrams;
    data['score_modifier'] = this.scoreModifier;
    data['nutrient_modifier'] = this.nutrientModifier;
    data['hf_modifier'] = this.hfModifier;
    data['digestibility'] = this.digestibility;
    data['hf_confidence'] = this.hfConfidence;
    data['meal_type_note'] = this.mealTypeNote;
    if (this.nutrientProfile != null) {
      data['nutrient_profile'] = this.nutrientProfile!.toJson();
    }
    if (this.nutrientImpacts != null) {
      data['nutrient_impacts'] =
          this.nutrientImpacts!.map((v) => v.toJson()).toList();
    }
    data['nutrient_notes'] = this.nutrientNotes;
    data['hf_note'] = this.hfNote;
    return data;
  }
}

class NutrientProfile {
  double? calories;
  double? protein;
  double? totalFat;
  double? carbs;
  double? sodium;
  double? satFat;
  double? cholesterol;
  double? sugar;
  double? calcium;
  double? iron;
  double? potassium;
  double? vitaminC;
  double? vitaminE;
  double? vitaminD;
  int? portionGrams;

  NutrientProfile(
      {this.calories,
        this.protein,
        this.totalFat,
        this.carbs,
        this.sodium,
        this.satFat,
        this.cholesterol,
        this.sugar,
        this.calcium,
        this.iron,
        this.potassium,
        this.vitaminC,
        this.vitaminE,
        this.vitaminD,
        this.portionGrams});

  NutrientProfile.fromJson(Map<String, dynamic> json) {
    calories = json['calories'];
    protein = json['protein'];
    totalFat = json['total_fat'];
    carbs = json['carbs'];
    sodium = json['sodium'];
    satFat = json['sat_fat'];
    cholesterol = json['cholesterol'];
    sugar = json['sugar'];
    calcium = json['calcium'];
    iron = json['iron'];
    potassium = json['potassium'];
    vitaminC = json['vitamin_c'];
    vitaminE = json['vitamin_e'];
    vitaminD = json['vitamin_d'];
    portionGrams = json['portion_grams'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['calories'] = this.calories;
    data['protein'] = this.protein;
    data['total_fat'] = this.totalFat;
    data['carbs'] = this.carbs;
    data['sodium'] = this.sodium;
    data['sat_fat'] = this.satFat;
    data['cholesterol'] = this.cholesterol;
    data['sugar'] = this.sugar;
    data['calcium'] = this.calcium;
    data['iron'] = this.iron;
    data['potassium'] = this.potassium;
    data['vitamin_c'] = this.vitaminC;
    data['vitamin_e'] = this.vitaminE;
    data['vitamin_d'] = this.vitaminD;
    data['portion_grams'] = this.portionGrams;
    return data;
  }
}

class NutrientImpacts {
  String? nutrient;
  double? value;
  String? unit;
  int? delta;
  String? note;
  String? direction;

  NutrientImpacts(
      {this.nutrient,
        this.value,
        this.unit,
        this.delta,
        this.note,
        this.direction});

  NutrientImpacts.fromJson(Map<String, dynamic> json) {
    nutrient = json['nutrient'];
    value = json['value'];
    unit = json['unit'];
    delta = json['delta'];
    note = json['note'];
    direction = json['direction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nutrient'] = this.nutrient;
    data['value'] = this.value;
    data['unit'] = this.unit;
    data['delta'] = this.delta;
    data['note'] = this.note;
    data['direction'] = this.direction;
    return data;
  }
}

class MealCounts {
  int? breakfast;
  int? lunch;
  int? dinner;
  int? snack;

  MealCounts({this.breakfast, this.lunch, this.dinner, this.snack});

  MealCounts.fromJson(Map<String, dynamic> json) {
    breakfast = json['Breakfast'];
    lunch = json['Lunch'];
    dinner = json['Dinner'];
    snack = json['Snack'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Breakfast'] = this.breakfast;
    data['Lunch'] = this.lunch;
    data['Dinner'] = this.dinner;
    data['Snack'] = this.snack;
    return data;
  }
}

class Pagination {
  int? total;
  String? page;
  String? limit;
  int? totalPages;

  Pagination({this.total, this.page, this.limit, this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['totalPages'] = this.totalPages;
    return data;
  }
}
