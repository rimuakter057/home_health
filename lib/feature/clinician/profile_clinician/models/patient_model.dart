class PatientModel {
  String? id;
  String? name;
  String? email;
  String?profileImage;
  int? age;
  int? weight;
  int? gutScore;
  String? grade;
  String? status;
  String? scoreUpdatedAt;
  String? connectedSince;
  String? lastLoggedFood;

  PatientModel(
      {this.id,
        this.name,
        this.email,
        this.profileImage,
        this.age,
        this.weight,
        this.gutScore,
        this.grade,
        this.status,
        this.scoreUpdatedAt,
        this.connectedSince,
        this.lastLoggedFood});

  PatientModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    profileImage=json['profileImage'];
    age = json['age'];
    weight = json['weight'];
    gutScore = json['gutScore'];
    grade = json['grade'];
    status = json['status'];
    scoreUpdatedAt = json['scoreUpdatedAt'];
    connectedSince = json['connectedSince'];
    lastLoggedFood = json['lastLoggedFood'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['profileImage']=this.profileImage;
    data['age'] = this.age;
    data['weight'] = this.weight;
    data['gutScore'] = this.gutScore;
    data['grade'] = this.grade;
    data['status'] = this.status;
    data['scoreUpdatedAt'] = this.scoreUpdatedAt;
    data['connectedSince'] = this.connectedSince;
    data['lastLoggedFood'] = this.lastLoggedFood;
    return data;
  }
}
