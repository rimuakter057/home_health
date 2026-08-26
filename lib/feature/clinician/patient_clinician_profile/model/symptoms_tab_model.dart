class SymptomsTabModel {
  String? sId;
  String? userId;
  List<String>? symptoms;
  String? severity;
  String? loggedAt;
  int? previousScore;
  int? scorePenalty;
  int? updatedScore;
  String? grade;
  String? summary;
  List<PerSymptomDetails>? perSymptomDetails;
  dynamic noteAnalysis;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SymptomsTabModel(
      {this.sId,
        this.userId,
        this.symptoms,
        this.severity,
        this.loggedAt,
        this.previousScore,
        this.scorePenalty,
        this.updatedScore,
        this.grade,
        this.summary,
        this.perSymptomDetails,
        this.noteAnalysis,
        this.createdAt,
        this.updatedAt,
        this.iV});

  SymptomsTabModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    symptoms = json['symptoms'].cast<String>();
    severity = json['severity'];
    loggedAt = json['loggedAt'];
    previousScore = json['previousScore'];
    scorePenalty = json['scorePenalty'];
    updatedScore = json['updatedScore'];
    grade = json['grade'];
    summary = json['summary'];
    if (json['perSymptomDetails'] != null) {
      perSymptomDetails = <PerSymptomDetails>[];
      json['perSymptomDetails'].forEach((v) {
        perSymptomDetails!.add(new PerSymptomDetails.fromJson(v));
      });
    }
    noteAnalysis = json['noteAnalysis'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['symptoms'] = this.symptoms;
    data['severity'] = this.severity;
    data['loggedAt'] = this.loggedAt;
    data['previousScore'] = this.previousScore;
    data['scorePenalty'] = this.scorePenalty;
    data['updatedScore'] = this.updatedScore;
    data['grade'] = this.grade;
    data['summary'] = this.summary;
    if (this.perSymptomDetails != null) {
      data['perSymptomDetails'] =
          this.perSymptomDetails!.map((v) => v.toJson()).toList();
    }
    data['noteAnalysis'] = this.noteAnalysis;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class PerSymptomDetails {
  String? symptom;
  int? scorePenalty;
  String? severityNote;
  String? timeNote;
  String? clinicalNote;
  String? source;
  dynamic confidence; // ✅ FIX

  PerSymptomDetails({
    this.symptom,
    this.scorePenalty,
    this.severityNote,
    this.timeNote,
    this.clinicalNote,
    this.source,
    this.confidence,
  });

  PerSymptomDetails.fromJson(Map<String, dynamic> json) {
    symptom = json['symptom'];
    scorePenalty = json['score_penalty'];
    severityNote = json['severity_note'];
    timeNote = json['time_note'];
    clinicalNote = json['clinical_note'];
    source = json['source'];
    confidence = json['confidence']; // safe now
  }

  Map<String, dynamic> toJson() {
    return {
      'symptom': symptom,
      'score_penalty': scorePenalty,
      'severity_note': severityNote,
      'time_note': timeNote,
      'clinical_note': clinicalNote,
      'source': source,
      'confidence': confidence,
    };
  }
}
