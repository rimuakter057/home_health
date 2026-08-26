class ProfileModel {
  String? sId;
  String? name;
  String? email;
  String? role;
  String? authProvider;
  bool? isVerified;
  bool? isActive;
  bool? rememberMe;
  PatientProfile? patientProfile;
  ClinicianProfile?clinicianProfile;
  String?profilePicture;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ProfileModel(
      {this.sId,
        this.name,
        this.email,
        this.role,
        this.authProvider,
        this.isVerified,
        this.isActive,
        this.rememberMe,
        this.patientProfile,
        this.clinicianProfile,
        this.profilePicture,
        this.createdAt,
        this.updatedAt,
        this.iV});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    authProvider = json['authProvider'];
    isVerified = json['isVerified'];
    isActive = json['isActive'];
    rememberMe = json['rememberMe'];
    patientProfile = json['patientProfile'] != null
        ? new PatientProfile.fromJson(json['patientProfile'])
        : null;
    clinicianProfile = json['clinicianProfile'] != null
        ? new ClinicianProfile.fromJson(json['clinicianProfile'])
        : null;
    profilePicture=json['profilePicture'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    data['authProvider'] = this.authProvider;
    data['isVerified'] = this.isVerified;
    data['isActive'] = this.isActive;
    data['rememberMe'] = this.rememberMe;
    if (this.patientProfile != null) {
      data['patientProfile'] = this.patientProfile!.toJson();
    }
    if (this.clinicianProfile != null) {
      data['clinicianProfile'] = this.clinicianProfile!.toJson();
    }
    data['profilePicture']=this.profilePicture;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class PatientProfile {
  String? gender;
  int? age;
  double? sleepAvg;
  int? weight;
  bool? isEliminationStage;
  List<String>? foodSensitivities;
  List<String>? symptoms;

  PatientProfile(
      {this.gender,
        this.age,
        this.sleepAvg,
        this.weight,
        this.isEliminationStage,
        this.foodSensitivities,
        this.symptoms});

// Inside class PatientProfile
  PatientProfile.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    age = json['age'];
    // Use .toDouble() to prevent type mismatch errors
    sleepAvg = json['sleepAvg']?.toDouble();
    weight = json['weight'];
    isEliminationStage = json['isEliminationStage'];
    foodSensitivities = json['foodSensitivities']?.cast<String>();
    symptoms = json['symptoms']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['sleepAvg'] = this.sleepAvg;
    data['weight'] = this.weight;
    data['isEliminationStage'] = this.isEliminationStage;
    data['foodSensitivities'] = this.foodSensitivities;
    data['symptoms'] = this.symptoms;
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

