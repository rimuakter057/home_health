class ChatMessageModel {
  String? id;
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
  List<dynamic>? deletedFor; // ✅ Fixed
  String? createdAt;
  String? updatedAt;
  int? iV;

  ChatMessageModel({
    this.id,
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

  static String? _parseId(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map) {
      return value['_id']?.toString() ?? value['id']?.toString();
    }
    return value.toString();
  }

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString() ?? json['id']?.toString();
    conversationId = _parseId(json['conversationId']);
    senderId = _parseId(json['senderId']);
    receiverId = _parseId(json['receiverId']);
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
    deletedFor = json['deletedFor'] != null          // ✅ Fixed
        ? List<dynamic>.from(json['deletedFor'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = id;
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
    data['deletedFor'] = deletedFor;                 // ✅ Fixed
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}