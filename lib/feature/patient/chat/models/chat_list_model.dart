class ChatListModel {
  String? conversationId;
  Participant? participant;
  LastMessage? lastMessage;
  String? lastMessageAt;
  int? unreadCount;

  ChatListModel(
      {this.conversationId,
        this.participant,
        this.lastMessage,
        this.lastMessageAt,
        this.unreadCount});

  ChatListModel.fromJson(Map<String, dynamic> json) {
    conversationId = json['_id'];
    participant = json['participant'] != null
        ? new Participant.fromJson(json['participant'])
        : null;
    lastMessage = json['lastMessage'] != null
        ? new LastMessage.fromJson(json['lastMessage'])
        : null;
    lastMessageAt = json['lastMessageAt'];
    unreadCount = json['unreadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.conversationId;
    if (this.participant != null) {
      data['participant'] = this.participant!.toJson();
    }
    if (this.lastMessage != null) {
      data['lastMessage'] = this.lastMessage!.toJson();
    }
    data['lastMessageAt'] = this.lastMessageAt;
    data['unreadCount'] = this.unreadCount;
    return data;
  }
}

class Participant {
  String? receiverId;
  String? name;
  String? email;
  ClinicianProfile? clinicianProfile;
  String?profilePicture;
  String? id;

  Participant(
      {this.receiverId, this.name, this.email, this.clinicianProfile,this.profilePicture, this.id});

  Participant.fromJson(Map<String, dynamic> json) {
    receiverId = json['_id'];
    name = json['name'];
    email = json['email'];
    clinicianProfile = json['clinicianProfile'] != null
        ? new ClinicianProfile.fromJson(json['clinicianProfile'])
        : null;

    profilePicture=json['profilePicture'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.receiverId;
    data['name'] = this.name;
    data['email'] = this.email;
    if (this.clinicianProfile != null) {
      data['clinicianProfile'] = this.clinicianProfile!.toJson();
    }
    data['profilePicture']=this.profilePicture;
    data['id'] = this.id;
    return data;
  }
}

class ClinicianProfile {
  bool? isProfileComplete;

  ClinicianProfile({this.isProfileComplete});

  ClinicianProfile.fromJson(Map<String, dynamic> json) {
    isProfileComplete = json['isProfileComplete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isProfileComplete'] = this.isProfileComplete;
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
  String? fileUrl;
  String? fileName;
  int? fileSize;
  String? status;
  bool? isEdited;
  bool? isDeleted;
  List<dynamic>? deletedFor; // ✅ Fixed type
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
    this.fileUrl,
    this.fileName,
    this.fileSize,
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
    fileUrl = json['fileUrl'];
    fileName = json['fileName'];
    fileSize = json['fileSize'];
    status = json['status'];
    isEdited = json['isEdited'];
    isDeleted = json['isDeleted'];
    deletedFor = json['deletedFor'] != null          // ✅ Fixed parsing
        ? List<dynamic>.from(json['deletedFor'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['conversationId'] = conversationId;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['senderRole'] = senderRole;
    data['receiverRole'] = receiverRole;
    data['content'] = content;
    data['messageType'] = messageType;
    data['fileUrl'] = fileUrl;
    data['fileName'] = fileName;
    data['fileSize'] = fileSize;
    data['status'] = status;
    data['isEdited'] = isEdited;
    data['isDeleted'] = isDeleted;
    data['deletedFor'] = deletedFor;                 // ✅ Fixed serialization
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
