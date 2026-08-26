class AllClinicianModel {
String? id;
String? name;
String? email;
String?profilePicture;
ClinicianProfile? clinicianProfile;
bool? isRequestSent;
String? connectionStatus;

AllClinicianModel({this.id, this.name, this.email, this.clinicianProfile, this.isRequestSent, this.connectionStatus});

AllClinicianModel.fromJson(Map<String, dynamic> json) {
id = json['_id'];
name = json['name'];
email = json['email'];
profilePicture =json['profilePicture'];
print("✅ parsed profilePicture: $profilePicture"); // ← এটা add করো
clinicianProfile = json['clinicianProfile'] != null ? new ClinicianProfile.fromJson(json['clinicianProfile']) : null;
isRequestSent = json['isRequestSent'];
connectionStatus = json['connectionStatus'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
data['_id'] = this.id;
data['name'] = this.name;
data['email'] = this.email;
data['profilePicture'] =this.profilePicture;
if (this.profilePicture != null) {
data['clinicianProfile'] = this.clinicianProfile!.toJson();
}
data['isRequestSent'] = this.isRequestSent;
data['connectionStatus'] = this.connectionStatus;
return data;
}
}

class ClinicianProfile {
String? department;
String? phone;
String? location;
bool? isProfileComplete;

ClinicianProfile({this.department, this.phone, this.location, this.isProfileComplete});

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
