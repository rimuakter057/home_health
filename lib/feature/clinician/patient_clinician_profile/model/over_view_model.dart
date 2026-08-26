class OverViewModel {
  PatientOverview? patient;
  GutHealthScore? gutHealthScore;
  List<RecentActivity>? recentActivity;
  bool? hasDietPlan;
  String? dietPlanLastUpdated;

  OverViewModel(
      {this.patient,
        this.gutHealthScore,
        this.recentActivity,
        this.hasDietPlan,
        this.dietPlanLastUpdated});

  OverViewModel.fromJson(Map<String, dynamic> json) {
    patient =
    json['patient'] != null ? new PatientOverview.fromJson(json['patient']) : null;
    gutHealthScore = json['gutHealthScore'] != null
        ? new GutHealthScore.fromJson(json['gutHealthScore'])
        : null;
    if (json['recentActivity'] != null) {
      recentActivity = <RecentActivity>[];
      json['recentActivity'].forEach((v) {
        recentActivity!.add(new RecentActivity.fromJson(v));
      });
    }
    hasDietPlan = json['hasDietPlan'];
    dietPlanLastUpdated = json['dietPlanLastUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.patient != null) {
      data['patient'] = this.patient!.toJson();
    }
    if (this.gutHealthScore != null) {
      data['gutHealthScore'] = this.gutHealthScore!.toJson();
    }
    if (this.recentActivity != null) {
      data['recentActivity'] =
          this.recentActivity!.map((v) => v.toJson()).toList();
    }
    data['hasDietPlan'] = this.hasDietPlan;
    data['dietPlanLastUpdated'] = this.dietPlanLastUpdated;
    return data;
  }
}

class PatientOverview {
  String? id;
  String? name;
  String? email;
  int? age;
  int? weight;
  String? gender;
  List<String>? foodSensitivities;
  List<String>? symptoms;
  bool? hasFlareUp;

  PatientOverview(
      {this.id,
        this.name,
        this.email,
        this.age,
        this.weight,
        this.gender,
        this.foodSensitivities,
        this.symptoms,
        this.hasFlareUp});

  PatientOverview.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    age = json['age'];
    weight = json['weight'];
    gender = json['gender'];
    foodSensitivities = json['foodSensitivities'].cast<String>();
    symptoms = json['symptoms'].cast<String>();
    hasFlareUp = json['hasFlareUp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['age'] = this.age;
    data['weight'] = this.weight;
    data['gender'] = this.gender;
    data['foodSensitivities'] = this.foodSensitivities;
    data['symptoms'] = this.symptoms;
    data['hasFlareUp'] = this.hasFlareUp;
    return data;
  }
}

class GutHealthScore {
  int? score;
  String? grade;
  String? tagline;
  String? updatedAt;
  Breakdown? breakdown;
  List<Concerns>? concerns;
  List<Recommendations>? recommendations;

  GutHealthScore(
      {this.score,
        this.grade,
        this.tagline,
        this.updatedAt,
        this.breakdown,
        this.concerns,
        this.recommendations});

  GutHealthScore.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    grade = json['grade'];
    tagline = json['tagline'];
    updatedAt = json['updatedAt'];
    breakdown = json['breakdown'] != null
        ? new Breakdown.fromJson(json['breakdown'])
        : null;
    if (json['concerns'] != null) {
      concerns = <Concerns>[];
      json['concerns'].forEach((v) {
        concerns!.add(new Concerns.fromJson(v));
      });
    }
    if (json['recommendations'] != null) {
      recommendations = <Recommendations>[];
      json['recommendations'].forEach((v) {
        recommendations!.add(new Recommendations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;
    data['grade'] = this.grade;
    data['tagline'] = this.tagline;
    data['updatedAt'] = this.updatedAt;
    if (this.breakdown != null) {
      data['breakdown'] = this.breakdown!.toJson();
    }
    if (this.concerns != null) {
      data['concerns'] = this.concerns!.map((v) => v.toJson()).toList();
    }
    if (this.recommendations != null) {
      data['recommendations'] =
          this.recommendations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Breakdown {
  int? baseScore;
  int? agePenalty;
  int? sleepPenalty;
  int? weightPenalty;
  int? genderPenalty;
  int? foodPenalty;
  int? symptomPenalty;
  int? compoundPenalty;
  int? finalScore;

  Breakdown(
      {this.baseScore,
        this.agePenalty,
        this.sleepPenalty,
        this.weightPenalty,
        this.genderPenalty,
        this.foodPenalty,
        this.symptomPenalty,
        this.compoundPenalty,
        this.finalScore});

  Breakdown.fromJson(Map<String, dynamic> json) {
    baseScore = json['base_score'];
    agePenalty = json['age_penalty'];
    sleepPenalty = json['sleep_penalty'];
    weightPenalty = json['weight_penalty'];
    genderPenalty = json['gender_penalty'];
    foodPenalty = json['food_penalty'];
    symptomPenalty = json['symptom_penalty'];
    compoundPenalty = json['compound_penalty'];
    finalScore = json['final_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base_score'] = this.baseScore;
    data['age_penalty'] = this.agePenalty;
    data['sleep_penalty'] = this.sleepPenalty;
    data['weight_penalty'] = this.weightPenalty;
    data['gender_penalty'] = this.genderPenalty;
    data['food_penalty'] = this.foodPenalty;
    data['symptom_penalty'] = this.symptomPenalty;
    data['compound_penalty'] = this.compoundPenalty;
    data['final_score'] = this.finalScore;
    return data;
  }
}

class Concerns {
  String? category;
  String? description;
  String? id;

  Concerns({this.category, this.description, this.id});

  Concerns.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    description = json['description'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['description'] = this.description;
    data['_id'] = this.id;
    return data;
  }
}

class Recommendations {
  int? priority;
  String? advice;
  String? sId;

  Recommendations({this.priority, this.advice, this.sId});

  Recommendations.fromJson(Map<String, dynamic> json) {
    priority = json['priority'];
    advice = json['advice'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['priority'] = this.priority;
    data['advice'] = this.advice;
    data['_id'] = this.sId;
    return data;
  }
}

class RecentActivity {
  String? type;
  String? description;
  String? severity;
  String? loggedAt;
  String? mealType;

  RecentActivity(
      {this.type,
        this.description,
        this.severity,
        this.loggedAt,
        this.mealType});

  RecentActivity.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    description = json['description'];
    severity = json['severity'];
    loggedAt = json['loggedAt'];
    mealType = json['mealType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['description'] = this.description;
    data['severity'] = this.severity;
    data['loggedAt'] = this.loggedAt;
    data['mealType'] = this.mealType;
    return data;
  }
}
