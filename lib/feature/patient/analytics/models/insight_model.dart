class InsightModel {
  String? id;
  String? foodLogId;
  String? targetFood;
  String? caseType;
  String?source;
  String? severity;
  String? note;
  bool? cached;
  bool? aiUnavailable;
  String? createdAt;

  InsightModel({
    this.id,
    this.foodLogId,
    this.targetFood,
    this.caseType,
    this.source,
    this.severity,
    this.note,
    this.cached,
    this.aiUnavailable,
    this.createdAt,
  });

  InsightModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    foodLogId = json['foodLogId'];
    targetFood = json['target_food'];
    caseType = json['case'];
    source=json['source'];
    severity = json['severity'];
    note = json['note'];
    cached = json['cached'];
    aiUnavailable = json['aiUnavailable'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['foodLogId'] = foodLogId;
    data['target_food'] = targetFood;
    data['case'] = caseType;
    data['source']=source;
    data['severity'] = severity;
    data['note'] = note;
    data['cached'] = cached;
    data['aiUnavailable'] = aiUnavailable;
    data['createdAt'] = createdAt;
    return data;
  }
}