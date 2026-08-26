class PatientAuthModel {
  final String token;
  final UserModel user;

  PatientAuthModel({
    required this.token,
    required this.user,
  });

  factory PatientAuthModel.fromJson(Map<String, dynamic> json) {
    return PatientAuthModel(
      token: json['token'] ?? '',
      user: UserModel.fromJson(json['user']),
    );
  }
}

// ── User Model ────────────────────────────────────────────────────────────────

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isVerified;
  final bool isActive;
  final PatientProfile? patientProfile;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isVerified,
    required this.isActive,
    this.patientProfile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? false,
      patientProfile: json['patientProfile'] != null
          ? PatientProfile.fromJson(json['patientProfile'])
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

// ── Patient Profile ───────────────────────────────────────────────────────────

class PatientProfile {
  final String gender;
  final int age;
  final double sleepAvg;
  final double weight;
  final bool isEliminationStage;
  final List<String> foodSensitivities;
  final List<String> symptoms;

  PatientProfile({
    required this.gender,
    required this.age,
    required this.sleepAvg,
    required this.weight,
    required this.isEliminationStage,
    required this.foodSensitivities,
    required this.symptoms,
  });

  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    return PatientProfile(
      gender: json['gender'] ?? '',
      age: json['age'] ?? 0,
      sleepAvg: (json['sleepAvg'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      isEliminationStage: json['isEliminationStage'] ?? false,
      foodSensitivities: List<String>.from(json['foodSensitivities'] ?? []),
      symptoms: List<String>.from(json['symptoms'] ?? []),
    );
  }
}