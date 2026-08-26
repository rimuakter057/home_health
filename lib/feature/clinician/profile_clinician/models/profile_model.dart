class ProfileClinicianModel {
  String? id;
  String? name;
  String? email;
  String? role;
  String? authProvider;
  bool? isVerified;
  bool? isActive;
  bool? rememberMe;
  ClinicianProfile? clinicianProfile;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ProfileClinicianModel(
      {this.id,
        this.name,
        this.email,
        this.role,
        this.authProvider,
        this.isVerified,
        this.isActive,
        this.rememberMe,
        this.clinicianProfile,
        this.createdAt,
        this.updatedAt,
        this.iV});

  ProfileClinicianModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    authProvider = json['authProvider'];
    isVerified = json['isVerified'];
    isActive = json['isActive'];
    rememberMe = json['rememberMe'];
    clinicianProfile = json['clinicianProfile'] != null
        ? new ClinicianProfile.fromJson(json['clinicianProfile'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    data['authProvider'] = this.authProvider;
    data['isVerified'] = this.isVerified;
    data['isActive'] = this.isActive;
    data['rememberMe'] = this.rememberMe;
    if (this.clinicianProfile != null) {
      data['clinicianProfile'] = this.clinicianProfile!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
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
