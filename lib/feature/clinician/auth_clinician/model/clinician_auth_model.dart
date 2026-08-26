class ClinicianAuthModel {
  final String token;
  final ClinicianUserModel user;

  ClinicianAuthModel({
    required this.token,
    required this.user,
  });

  factory ClinicianAuthModel.fromJson(Map<String, dynamic> json) {
    return ClinicianAuthModel(
      token: json['token'] ?? '',
      user: ClinicianUserModel.fromJson(json['user']),
    );
  }
}

// ── User Model ────────────────────────────────────────

class ClinicianUserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isVerified;
  final bool isActive;
  final ClinicianProfile? clinicianProfile;

  ClinicianUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isVerified,
    required this.isActive,
    this.clinicianProfile,
  });

  factory ClinicianUserModel.fromJson(Map<String, dynamic> json) {
    return ClinicianUserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? false,
      clinicianProfile: json['clinicianProfile'] != null
          ? ClinicianProfile.fromJson(json['clinicianProfile'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'role': role,
    'isVerified': isVerified,
    'isActive': isActive,
  };
}

// ── Clinician Profile ─────────────────────────────────

class ClinicianProfile {
  final String department;
  final String phone;
  final String location;
  final bool isProfileComplete;

  ClinicianProfile({
    required this.department,
    required this.phone,
    required this.location,
    required this.isProfileComplete,
  });

  factory ClinicianProfile.fromJson(Map<String, dynamic> json) {
    return ClinicianProfile(
      department: json['department'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      isProfileComplete: json['isProfileComplete'] ?? false,
    );
  }
}