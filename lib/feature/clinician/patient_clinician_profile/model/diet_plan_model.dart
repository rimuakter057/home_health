class DietPlanModel {
  String? sId;
  PatientId? patientId;
  String? clinicianId;
  List<String>? foodsToAvoid;
  List<String>? foodsToIncrease;
  String? additionalNotes;
  List<MealSuggestions>? mealSuggestions;
  bool? isActive;
  String? notifiedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  DietPlanModel({
    this.sId,
    this.patientId,
    this.clinicianId,
    this.foodsToAvoid,
    this.foodsToIncrease,
    this.additionalNotes,
    this.mealSuggestions,
    this.isActive,
    this.notifiedAt,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  DietPlanModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    patientId = json['patientId'] != null
        ? PatientId.fromJson(json['patientId'])
        : null;
    clinicianId = json['clinicianId'];
    foodsToAvoid = (json['foodsToAvoid'] as List?)?.cast<String>() ?? [];
    foodsToIncrease = (json['foodsToIncrease'] as List?)?.cast<String>() ?? [];
    additionalNotes = json['additionalNotes'];
    if (json['mealSuggestions'] != null) {
      mealSuggestions = <MealSuggestions>[];
      json['mealSuggestions'].forEach((v) {
        mealSuggestions!.add(MealSuggestions.fromJson(v));
      });
    }
    isActive = json['isActive'];
    notifiedAt = json['notifiedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    if (patientId != null) {
      data['patientId'] = patientId!.toJson();
    }
    data['clinicianId'] = clinicianId;
    data['foodsToAvoid'] = foodsToAvoid;
    data['foodsToIncrease'] = foodsToIncrease;
    data['additionalNotes'] = additionalNotes;
    if (mealSuggestions != null) {
      data['mealSuggestions'] = mealSuggestions!.map((v) => v.toJson()).toList();
    }
    data['isActive'] = isActive;
    data['notifiedAt'] = notifiedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class PatientId {
  String? sId;
  String? name;
  String? email;
  PatientProfile? patientProfile;
  String? id;

  PatientId({this.sId, this.name, this.email, this.patientProfile, this.id});

  PatientId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    patientProfile = json['patientProfile'] != null
        ? PatientProfile.fromJson(json['patientProfile'])
        : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    if (patientProfile != null) {
      data['patientProfile'] = patientProfile!.toJson();
    }
    data['id'] = id;
    return data;
  }
}

class PatientProfile {
  String? gender;
  int? age;
  double? sleepAvg;
  double? weight;
  bool? isEliminationStage;
  List<String>? foodSensitivities;
  List<String>? symptoms;

  PatientProfile({
    this.gender,
    this.age,
    this.sleepAvg,
    this.weight,
    this.isEliminationStage,
    this.foodSensitivities,
    this.symptoms,
  });

  PatientProfile.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    age = (json['age'] as num?)?.toInt();
    sleepAvg = (json['sleepAvg'] as num?)?.toDouble(); // ✅ fix
    weight = (json['weight'] as num?)?.toDouble();     // ✅ fix
    isEliminationStage = json['isEliminationStage'];
    foodSensitivities = (json['foodSensitivities'] as List?)?.cast<String>() ?? [];
    symptoms = (json['symptoms'] as List?)?.cast<String>() ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['gender'] = gender;
    data['age'] = age;
    data['sleepAvg'] = sleepAvg;
    data['weight'] = weight;
    data['isEliminationStage'] = isEliminationStage;
    data['foodSensitivities'] = foodSensitivities;
    data['symptoms'] = symptoms;
    return data;
  }
}

class MealSuggestions {
  String? mealType;
  String? foodSuggestion;

  MealSuggestions({this.mealType, this.foodSuggestion});

  MealSuggestions.fromJson(Map<String, dynamic> json) {
    mealType = json['mealType'];
    foodSuggestion = json['foodSuggestion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['mealType'] = mealType;
    data['foodSuggestion'] = foodSuggestion;
    return data;
  }
}