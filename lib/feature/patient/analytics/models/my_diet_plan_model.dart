class MyDietPlanModel {
  String? id;
  String? patientId;
  ClinicianId? clinicianId;
  List<String>? foodsToAvoid;
  List<String>? foodsToIncrease;
  String? additionalNotes;
  List<MealSuggestions>? mealSuggestions;
  bool? isActive;
  String? notifiedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  MyDietPlanModel(
      {this.id,
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
        this.iV});

  MyDietPlanModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    patientId = json['patientId'];
    clinicianId = json['clinicianId'] != null
        ? new ClinicianId.fromJson(json['clinicianId'])
        : null;
    foodsToAvoid = json['foodsToAvoid'].cast<String>();
    foodsToIncrease = json['foodsToIncrease'].cast<String>();
    additionalNotes = json['additionalNotes'];
    if (json['mealSuggestions'] != null) {
      mealSuggestions = <MealSuggestions>[];
      json['mealSuggestions'].forEach((v) {
        mealSuggestions!.add(new MealSuggestions.fromJson(v));
      });
    }
    isActive = json['isActive'];
    notifiedAt = json['notifiedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['patientId'] = this.patientId;
    if (this.clinicianId != null) {
      data['clinicianId'] = this.clinicianId!.toJson();
    }
    data['foodsToAvoid'] = this.foodsToAvoid;
    data['foodsToIncrease'] = this.foodsToIncrease;
    data['additionalNotes'] = this.additionalNotes;
    if (this.mealSuggestions != null) {
      data['mealSuggestions'] =
          this.mealSuggestions!.map((v) => v.toJson()).toList();
    }
    data['isActive'] = this.isActive;
    data['notifiedAt'] = this.notifiedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class ClinicianId {
  String? sId;
  String? name;
  String? email;
  ClinicianProfile? clinicianProfile;
  String? id;

  ClinicianId(
      {this.sId, this.name, this.email, this.clinicianProfile, this.id});

  ClinicianId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    clinicianProfile = json['clinicianProfile'] != null
        ? new ClinicianProfile.fromJson(json['clinicianProfile'])
        : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    if (this.clinicianProfile != null) {
      data['clinicianProfile'] = this.clinicianProfile!.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}

class ClinicianProfile {
  String? department;
  String? phone;
  String? location;
  bool? isProfileComplete;

  ClinicianProfile(
      {this.department, this.phone, this.location, this.isProfileComplete});

  ClinicianProfile.fromJson(Map<String, dynamic> json) {
    department = json['department'];
    phone = json['phone'];
    location = json['location'];
    isProfileComplete = json['isProfileComplete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['department'] = this.department;
    data['phone'] = this.phone;
    data['location'] = this.location;
    data['isProfileComplete'] = this.isProfileComplete;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mealType'] = this.mealType;
    data['foodSuggestion'] = this.foodSuggestion;
    return data;
  }
}
