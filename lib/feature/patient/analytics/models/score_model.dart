class ScorePatientModel {

  String? id;
  String? userId;
  int? iV;

  List<Concerns>? concerns;
  String? createdAt;
  String? grade;
  List<Recommendations>? recommendations;
  int? score;
  String? tagline;
  String? updatedAt;

  ScorePatientModel(
      {
        this.id,
        this.userId,
        this.iV,

        this.concerns,
        this.createdAt,
        this.grade,
        this.recommendations,
        this.score,
        this.tagline,
        this.updatedAt});

  ScorePatientModel.fromJson(Map<String, dynamic> json) {

    id = json['_id'];
    userId = json['userId'];
    iV = json['__v'];

    if (json['concerns'] != null) {
      concerns = <Concerns>[];
      json['concerns'].forEach((v) {
        concerns!.add(new Concerns.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    grade = json['grade'];
    if (json['recommendations'] != null) {
      recommendations = <Recommendations>[];
      json['recommendations'].forEach((v) {
        recommendations!.add(new Recommendations.fromJson(v));
      });
    }
    score = json['score'];
    tagline = json['tagline'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['_id'] = this.id;
    data['userId'] = this.userId;
    data['__v'] = this.iV;


    if (this.concerns != null) {
      data['concerns'] = this.concerns!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['grade'] = this.grade;
    if (this.recommendations != null) {
      data['recommendations'] =
          this.recommendations!.map((v) => v.toJson()).toList();
    }
    data['score'] = this.score;
    data['tagline'] = this.tagline;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}




class Concerns {
  String? category;
  String? description;
  String? sId;

  Concerns({this.category, this.description, this.sId});

  Concerns.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    description = json['description'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['description'] = this.description;
    data['_id'] = this.sId;
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
