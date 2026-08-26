class PatientListModel {
  List<Patients>? patients;
  Pagination? pagination;

  PatientListModel({this.patients, this.pagination});

  PatientListModel.fromJson(Map<String, dynamic> json) {
    if (json['patients'] != null) {
      patients = <Patients>[];
      json['patients'].forEach((v) {
        patients!.add(new Patients.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.patients != null) {
      data['patients'] = this.patients!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Patients {
  String? id;
  String? name;
  String? email;
  int? age;
  int? weight;
  int? gutScore;
  String? grade;
  String? scoreUpdatedAt;
  bool? hasFlareUp;
  String? connectedSince;
  String? lastLoggedFood;

  Patients(
      {this.id,
        this.name,
        this.email,
        this.age,
        this.weight,
        this.gutScore,
        this.grade,
        this.scoreUpdatedAt,
        this.hasFlareUp,
        this.connectedSince,
        this.lastLoggedFood});

  Patients.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    age = json['age'];
    weight = json['weight'];
    gutScore = json['gutScore'];
    grade = json['grade'];
    scoreUpdatedAt = json['scoreUpdatedAt'];
    hasFlareUp = json['hasFlareUp'];
    connectedSince = json['connectedSince'];
    lastLoggedFood = json['lastLoggedFood'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['age'] = this.age;
    data['weight'] = this.weight;
    data['gutScore'] = this.gutScore;
    data['grade'] = this.grade;
    data['scoreUpdatedAt'] = this.scoreUpdatedAt;
    data['hasFlareUp'] = this.hasFlareUp;
    data['connectedSince'] = this.connectedSince;
    data['lastLoggedFood'] = this.lastLoggedFood;
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
