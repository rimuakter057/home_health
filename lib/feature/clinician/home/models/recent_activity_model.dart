class RecentActivityModel {
  String? type;
  String? activityId;
  PatientRecent? patient;
  String? description;
  String? mealType;
  String? loggedAt;
  String? timeAgo;

  RecentActivityModel(
      {this.type,
        this.activityId,
        this.patient,
        this.description,
        this.mealType,
        this.loggedAt,
        this.timeAgo});

  RecentActivityModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    activityId = json['activityId'];
    patient =
    json['patient'] != null ? new PatientRecent.fromJson(json['patient']) : null;
    description = json['description'];
    mealType = json['mealType'];
    loggedAt = json['loggedAt'];
    timeAgo = json['timeAgo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['activityId'] = this.activityId;
    if (this.patient != null) {
      data['patient'] = this.patient!.toJson();
    }
    data['description'] = this.description;
    data['mealType'] = this.mealType;
    data['loggedAt'] = this.loggedAt;
    data['timeAgo'] = this.timeAgo;
    return data;
  }
}

class PatientRecent {
  String? id;
  String? name;
  String? email;
  String?profileImage;

  PatientRecent({this.id, this.name, this.email,this.profileImage});

  PatientRecent.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    profileImage=json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['profileImage']=this.profileImage;
    return data;
  }
}
