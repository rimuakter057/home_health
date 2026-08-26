class SearchHomeClinician {
  String? myId;
  String? sId;
  Participant? participant;
  LastMessage? lastMessage;
  String? lastMessageAt;
  int? unreadCount;

  SearchHomeClinician({
    this.myId,
    this.sId,
    this.participant,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount,
  });

  SearchHomeClinician.fromJson(Map<String, dynamic> json) {
    myId = json['myId'];
    sId = json['_id'];
    participant = json['participant'] != null
        ? Participant.fromJson(json['participant'])
        : null;
    lastMessage = json['lastMessage'] != null
        ? LastMessage.fromJson(json['lastMessage'])
        : null;
    lastMessageAt = json['lastMessageAt'];
    unreadCount = json['unreadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['myId'] = myId;
    data['_id'] = sId;
    if (participant != null) data['participant'] = participant!.toJson();
    if (lastMessage != null) data['lastMessage'] = lastMessage!.toJson();
    data['lastMessageAt'] = lastMessageAt;
    data['unreadCount'] = unreadCount;
    return data;
  }
}

class Participant {
  String? sId;
  String? name;
  String? email;
  String? profilePicture;
  PatientProfile? patientProfile;
  String? id;

  Participant({
    this.sId,
    this.name,
    this.email,
    this.profilePicture,
    this.patientProfile,
    this.id,
  });

  Participant.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    profilePicture = json['profilePicture'];
    patientProfile = json['patientProfile'] != null
        ? PatientProfile.fromJson(json['patientProfile'])
        : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['profilePicture'] = profilePicture;
    if (patientProfile != null) data['patientProfile'] = patientProfile!.toJson();
    data['id'] = id;
    return data;
  }
}

class PatientProfile {
  String? gender;
  int? age;
  double? sleepAvg;
  double? weight;
  bool? isEliminationStage;
  List<String>? foodSensitivities;
  List<String>? symptoms;

  PatientProfile({
    this.gender,
    this.age,
    this.sleepAvg,
    this.weight,
    this.isEliminationStage,
    this.foodSensitivities,
    this.symptoms,
  });

  PatientProfile.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    age = json['age'];
    sleepAvg = (json['sleepAvg'] as num?)?.toDouble();
    weight = (json['weight'] as num?)?.toDouble();
    isEliminationStage = json['isEliminationStage'];
    foodSensitivities = json['foodSensitivities'] != null
        ? List<String>.from(json['foodSensitivities'])
        : null;
    symptoms = json['symptoms'] != null
        ? List<String>.from(json['symptoms'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gender'] = gender;
    data['age'] = age;
    data['sleepAvg'] = sleepAvg;
    data['weight'] = weight;
    data['isEliminationStage'] = isEliminationStage;
    data['foodSensitivities'] = foodSensitivities;
    data['symptoms'] = symptoms;
    return data;
  }
}

class LastMessage {
  String? sId;
  String? conversationId;
  String? senderId;
  String? receiverId;
  String? senderRole;
  String? receiverRole;
  String? content;
  String? messageType;
  String? status;
  bool? isEdited;
  bool? isDeleted;
  List<dynamic>? deletedFor;
  String? createdAt;
  String? updatedAt;
  int? iV;

  LastMessage({
    this.sId,
    this.conversationId,
    this.senderId,
    this.receiverId,
    this.senderRole,
    this.receiverRole,
    this.content,
    this.messageType,
    this.status,
    this.isEdited,
    this.isDeleted,
    this.deletedFor,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  LastMessage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    conversationId = json['conversationId'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    senderRole = json['senderRole'];
    receiverRole = json['receiverRole'];
    content = json['content'];
    messageType = json['messageType'];
    status = json['status'];
    isEdited = json['isEdited'];
    isDeleted = json['isDeleted'];
    deletedFor = json['deletedFor'] != null
        ? List<dynamic>.from(json['deletedFor'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['conversationId'] = conversationId;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['senderRole'] = senderRole;
    data['receiverRole'] = receiverRole;
    data['content'] = content;
    data['messageType'] = messageType;
    data['status'] = status;
    data['isEdited'] = isEdited;
    data['isDeleted'] = isDeleted;
    data['deletedFor'] = deletedFor;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}