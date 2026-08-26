// class MyPlanTabModel {
//   String? id;
//   PatientId? patientId;
//   String? clinicianId;
//   List<String>? foodsToAvoid;
//   List<String>? foodsToIncrease;
//   String? additionalNotes;
//   List<MealSuggestions>? mealSuggestions;
//   bool? isActive;
//   String? notifiedAt;
//   String? createdAt;
//   String? updatedAt;
//   int? iV;
//
//   MyPlanTabModel(
//       {this.id,
//         this.patientId,
//         this.clinicianId,
//         this.foodsToAvoid,
//         this.foodsToIncrease,
//         this.additionalNotes,
//         this.mealSuggestions,
//         this.isActive,
//         this.notifiedAt,
//         this.createdAt,
//         this.updatedAt,
//         this.iV});
//
//   MyPlanTabModel.fromJson(Map<String, dynamic> json) {
//     id = json['_id'];
//     patientId = json['patientId'] != null
//         ? new PatientId.fromJson(json['patientId'])
//         : null;
//     clinicianId = json['clinicianId'];
//     foodsToAvoid = json['foodsToAvoid'].cast<String>();
//     foodsToIncrease = json['foodsToIncrease'].cast<String>();
//     additionalNotes = json['additionalNotes'];
//     if (json['mealSuggestions'] != null) {
//       mealSuggestions = <MealSuggestions>[];
//       json['mealSuggestions'].forEach((v) {
//         mealSuggestions!.add(new MealSuggestions.fromJson(v));
//       });
//     }
//     isActive = json['isActive'];
//     notifiedAt = json['notifiedAt'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.id;
//     if (this.patientId != null) {
//       data['patientId'] = this.patientId!.toJson();
//     }
//     data['clinicianId'] = this.clinicianId;
//     data['foodsToAvoid'] = this.foodsToAvoid;
//     data['foodsToIncrease'] = this.foodsToIncrease;
//     data['additionalNotes'] = this.additionalNotes;
//     if (this.mealSuggestions != null) {
//       data['mealSuggestions'] =
//           this.mealSuggestions!.map((v) => v.toJson()).toList();
//     }
//     data['isActive'] = this.isActive;
//     data['notifiedAt'] = this.notifiedAt;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['__v'] = this.iV;
//     return data;
//   }
// }
//
// class PatientId {
//   String? sId;
//   String? name;
//   String? email;
//   PatientProfile? patientProfile;
//   String? id;
//
//   PatientId({this.sId, this.name, this.email, this.patientProfile, this.id});
//
//   PatientId.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//     email = json['email'];
//     patientProfile = json['patientProfile'] != null
//         ? new PatientProfile.fromJson(json['patientProfile'])
//         : null;
//     id = json['id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['name'] = this.name;
//     data['email'] = this.email;
//     if (this.patientProfile != null) {
//       data['patientProfile'] = this.patientProfile!.toJson();
//     }
//     data['id'] = this.id;
//     return data;
//   }
// }
//
// class PatientProfile {
//   String? gender;
//   int? age;
//   double? sleepAvg;
//   int? weight;
//   bool? isEliminationStage;
//   List<String>? foodSensitivities;
//   List<String>? symptoms;
//
//   PatientProfile(
//       {this.gender,
//         this.age,
//         this.sleepAvg,
//         this.weight,
//         this.isEliminationStage,
//         this.foodSensitivities,
//         this.symptoms});
//
//   PatientProfile.fromJson(Map<String, dynamic> json) {
//     gender = json['gender'];
//     age = json['age'];
//     sleepAvg = json['sleepAvg'];
//     weight = json['weight'];
//     isEliminationStage = json['isEliminationStage'];
//     foodSensitivities = json['foodSensitivities'].cast<String>();
//     symptoms = json['symptoms'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['gender'] = this.gender;
//     data['age'] = this.age;
//     data['sleepAvg'] = this.sleepAvg;
//     data['weight'] = this.weight;
//     data['isEliminationStage'] = this.isEliminationStage;
//     data['foodSensitivities'] = this.foodSensitivities;
//     data['symptoms'] = this.symptoms;
//     return data;
//   }
// }
//
// class MealSuggestions {
//   String? mealType;
//   String? foodSuggestion;
//
//   MealSuggestions({this.mealType, this.foodSuggestion});
//
//   MealSuggestions.fromJson(Map<String, dynamic> json) {
//     mealType = json['mealType'];
//     foodSuggestion = json['foodSuggestion'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['mealType'] = this.mealType;
//     data['foodSuggestion'] = this.foodSuggestion;
//     return data;
//   }
// }











class MyPlanTabModel {
  String? id;
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

  MyPlanTabModel({
    this.id,
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

  MyPlanTabModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    patientId = json['patientId'] != null
        ? PatientId.fromJson(json['patientId'])
        : null;
    clinicianId = json['clinicianId'];
    foodsToAvoid = (json['foodsToAvoid'] as List?)?.cast<String>() ?? [];
    foodsToIncrease = (json['foodsToIncrease'] as List?)?.cast<String>() ?? [];
    additionalNotes = json['additionalNotes'];
    mealSuggestions = (json['mealSuggestions'] as List?)
        ?.map((v) => MealSuggestions.fromJson(v))
        .toList();
    isActive = json['isActive'];
    notifiedAt = json['notifiedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
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
  double? sleepAvg;  // ✅ double রাখা হয়েছে
  int? weight;
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
    age = json['age'];
    sleepAvg = (json['sleepAvg'] as num?)?.toDouble(); // ✅ int/double দুটোই handle হবে
    weight = json['weight'];
    isEliminationStage = json['isEliminationStage'];
    foodSensitivities = (json['foodSensitivities'] as List?)?.cast<String>() ?? []; // ✅ null safe
    symptoms = (json['symptoms'] as List?)?.cast<String>() ?? []; // ✅ null safe
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
    return {
      'mealType': mealType,
      'foodSuggestion': foodSuggestion,
    };
  }
}
