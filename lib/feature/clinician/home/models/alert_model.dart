class AlertModel {
  String? alertId;
  Patient? patient;
  List<String>? symptoms;
  String? severity;
  String? loggedAt;
  String? timeAgo;

  AlertModel(
      {this.alertId,
        this.patient,
        this.symptoms,
        this.severity,
        this.loggedAt,
        this.timeAgo});

  AlertModel.fromJson(Map<String, dynamic> json) {
    alertId = json['alertId'];
    patient =
    json['patient'] != null ? new Patient.fromJson(json['patient']) : null;
    symptoms = json['symptoms'].cast<String>();
    severity = json['severity'];
    loggedAt = json['loggedAt'];
    timeAgo = json['timeAgo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alertId'] = this.alertId;
    if (this.patient != null) {
      data['patient'] = this.patient!.toJson();
    }
    data['symptoms'] = this.symptoms;
    data['severity'] = this.severity;
    data['loggedAt'] = this.loggedAt;
    data['timeAgo'] = this.timeAgo;
    return data;
  }
}

class Patient {
  String? id;
  String? name;
  String? email;
  String?profileImage;

  Patient({this.id, this.name, this.email,this.profileImage});

  Patient.fromJson(Map<String, dynamic> json) {
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
