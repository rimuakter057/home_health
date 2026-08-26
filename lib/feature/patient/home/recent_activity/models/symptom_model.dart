class SymptomModel {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  SymptomModel({this.success, this.statusCode, this.message, this.data});

  SymptomModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['chat'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['chat'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Logs>? logs;
  Pagination? pagination;

  Data({this.logs, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['logs'] != null) {
      logs = <Logs>[];
      json['logs'].forEach((v) {
        logs!.add(new Logs.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.logs != null) {
      data['logs'] = this.logs!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Logs {
  String? sId;
  String? userId;
  List<String>? symptoms;
  String? severity;
  String? note;
  String? loggedAt;
  int? previousScore;
  int? scorePenalty;
  int? updatedScore;
  String? grade;
  String? summary;
  List<PerSymptomDetails>? perSymptomDetails;
  NoteAnalysis? noteAnalysis;
  String?culpritMessage;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Logs(
      {this.sId,
        this.userId,
        this.symptoms,
        this.severity,
        this.note,
        this.loggedAt,
        this.previousScore,
        this.scorePenalty,
        this.updatedScore,
        this.grade,
        this.summary,
        this.perSymptomDetails,
        this.noteAnalysis,
        this.culpritMessage,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Logs.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    symptoms = json['symptoms'].cast<String>();
    severity = json['severity'];
    note = json['note'];
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
    noteAnalysis = json['noteAnalysis'] != null
        ? new NoteAnalysis.fromJson(json['noteAnalysis'])
        : null;
    culpritMessage = json['culpritMessage'];
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
    data['note'] = this.note;
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
    if (this.noteAnalysis != null) {
      data['noteAnalysis'] = this.noteAnalysis!.toJson();
    }
    data['culpritMessage']=this.culpritMessage;
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
  int? confidence;

  PerSymptomDetails(
      {this.symptom,
        this.scorePenalty,
        this.severityNote,
        this.timeNote,
        this.clinicalNote,
        this.source,
        this.confidence});

  PerSymptomDetails.fromJson(Map<String, dynamic> json) {
    symptom = json['symptom'];
    scorePenalty = json['score_penalty'];
    severityNote = json['severity_note'];
    timeNote = json['time_note'];
    clinicalNote = json['clinical_note'];
    source = json['source'];
    confidence = json['confidence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['symptom'] = this.symptom;
    data['score_penalty'] = this.scorePenalty;
    data['severity_note'] = this.severityNote;
    data['time_note'] = this.timeNote;
    data['clinical_note'] = this.clinicalNote;
    data['source'] = this.source;
    data['confidence'] = this.confidence;
    return data;
  }
}

class NoteAnalysis {
  bool? analysed;
  int? detectedSymptomCount;
  bool? novelSymptomFlag;
  String? novelSymptomHint;
  int? additionalPenalty;
  String? analysisSummary;
  RawScores? rawScores;

  NoteAnalysis(
      {this.analysed,
        this.detectedSymptomCount,
        this.novelSymptomFlag,
        this.novelSymptomHint,
        this.additionalPenalty,
        this.analysisSummary,
        this.rawScores});

  NoteAnalysis.fromJson(Map<String, dynamic> json) {
    analysed = json['analysed'];
    detectedSymptomCount = json['detected_symptom_count'];
    novelSymptomFlag = json['novel_symptom_flag'];
    novelSymptomHint = json['novel_symptom_hint'];
    additionalPenalty = json['additional_penalty'];
    analysisSummary = json['analysis_summary'];
    rawScores = json['raw_scores'] != null
        ? new RawScores.fromJson(json['raw_scores'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['analysed'] = this.analysed;
    data['detected_symptom_count'] = this.detectedSymptomCount;
    data['novel_symptom_flag'] = this.novelSymptomFlag;
    data['novel_symptom_hint'] = this.novelSymptomHint;
    data['additional_penalty'] = this.additionalPenalty;
    data['analysis_summary'] = this.analysisSummary;
    if (this.rawScores != null) {
      data['raw_scores'] = this.rawScores!.toJson();
    }
    return data;
  }
}

class RawScores {
  int? bloating;
  int? gas;
  int? constipation;
  int? diarrhea;
  int? nausea;
  int? heartburn;
  int? abdominalPain;
  int? cramps;
  int? fatigue;
  int? acidReflux;

  RawScores(
      {this.bloating,
        this.gas,
        this.constipation,
        this.diarrhea,
        this.nausea,
        this.heartburn,
        this.abdominalPain,
        this.cramps,
        this.fatigue,
        this.acidReflux});

  RawScores.fromJson(Map<String, dynamic> json) {
    bloating = json['Bloating'];
    gas = json['Gas'];
    constipation = json['Constipation'];
    diarrhea = json['Diarrhea'];
    nausea = json['Nausea'];
    heartburn = json['Heartburn'];
    abdominalPain = json['Abdominal Pain'];
    cramps = json['Cramps'];
    fatigue = json['Fatigue'];
    acidReflux = json['Acid Reflux'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Bloating'] = this.bloating;
    data['Gas'] = this.gas;
    data['Constipation'] = this.constipation;
    data['Diarrhea'] = this.diarrhea;
    data['Nausea'] = this.nausea;
    data['Heartburn'] = this.heartburn;
    data['Abdominal Pain'] = this.abdominalPain;
    data['Cramps'] = this.cramps;
    data['Fatigue'] = this.fatigue;
    data['Acid Reflux'] = this.acidReflux;
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
