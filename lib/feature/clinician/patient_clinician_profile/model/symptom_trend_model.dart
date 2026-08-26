class SymptomTrendModel {
  Period? period;
  List<Days>? days;
  List<ScoreTrend>? scoreTrend;
  List<WeeklySymptomSummary>? weeklySymptomSummary;
  WorstDay? worstDay;
  int? totalLogsThisWeek;
  int? totalSymptomsThisWeek;

  SymptomTrendModel(
      {this.period,
        this.days,
        this.scoreTrend,
        this.weeklySymptomSummary,
        this.worstDay,
        this.totalLogsThisWeek,
        this.totalSymptomsThisWeek});

  SymptomTrendModel.fromJson(Map<String, dynamic> json) {
    period =
    json['period'] != null ? new Period.fromJson(json['period']) : null;
    if (json['days'] != null) {
      days = <Days>[];
      json['days'].forEach((v) {
        days!.add(new Days.fromJson(v));
      });
    }
    if (json['scoreTrend'] != null) {
      scoreTrend = <ScoreTrend>[];
      json['scoreTrend'].forEach((v) {
        scoreTrend!.add(new ScoreTrend.fromJson(v));
      });
    }
    if (json['weeklySymptomSummary'] != null) {
      weeklySymptomSummary = <WeeklySymptomSummary>[];
      json['weeklySymptomSummary'].forEach((v) {
        weeklySymptomSummary!.add(new WeeklySymptomSummary.fromJson(v));
      });
    }
    worstDay = json['worstDay'] != null
        ? new WorstDay.fromJson(json['worstDay'])
        : null;
    totalLogsThisWeek = json['totalLogsThisWeek'];
    totalSymptomsThisWeek = json['totalSymptomsThisWeek'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.period != null) {
      data['period'] = this.period!.toJson();
    }
    if (this.days != null) {
      data['days'] = this.days!.map((v) => v.toJson()).toList();
    }
    if (this.scoreTrend != null) {
      data['scoreTrend'] = this.scoreTrend!.map((v) => v.toJson()).toList();
    }
    if (this.weeklySymptomSummary != null) {
      data['weeklySymptomSummary'] =
          this.weeklySymptomSummary!.map((v) => v.toJson()).toList();
    }
    if (this.worstDay != null) {
      data['worstDay'] = this.worstDay!.toJson();
    }
    data['totalLogsThisWeek'] = this.totalLogsThisWeek;
    data['totalSymptomsThisWeek'] = this.totalSymptomsThisWeek;
    return data;
  }
}

class Period {
  String? from;
  String? to;

  Period({this.from, this.to});

  Period.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}

class Days {
  String? date;
  String? day;
  int? totalSymptoms;
  int? score;
  List<Symptoms>? symptoms;

  Days({this.date, this.day, this.totalSymptoms, this.score, this.symptoms});

  Days.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    day = json['day'];
    totalSymptoms = json['totalSymptoms'];
    score = json['score'];
    if (json['symptoms'] != null) {
      symptoms = <Symptoms>[];
      json['symptoms'].forEach((v) {
        symptoms!.add(new Symptoms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['day'] = this.day;
    data['totalSymptoms'] = this.totalSymptoms;
    data['score'] = this.score;
    if (this.symptoms != null) {
      data['symptoms'] = this.symptoms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Symptoms {
  String? name;
  int? count;
  String? severity;

  Symptoms({this.name, this.count, this.severity});

  Symptoms.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    count = json['count'];
    severity = json['severity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['count'] = this.count;
    data['severity'] = this.severity;
    return data;
  }
}

class ScoreTrend {
  String? day;
  String? date;
  int? score;

  ScoreTrend({this.day, this.date, this.score});

  ScoreTrend.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    date = json['date'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['date'] = this.date;
    data['score'] = this.score;
    return data;
  }
}

class WeeklySymptomSummary {
  String? symptom;
  int? count;

  WeeklySymptomSummary({this.symptom, this.count});

  WeeklySymptomSummary.fromJson(Map<String, dynamic> json) {
    symptom = json['symptom'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['symptom'] = this.symptom;
    data['count'] = this.count;
    return data;
  }
}

class WorstDay {
  String? day;
  String? date;
  int? totalSymptoms;

  WorstDay({this.day, this.date, this.totalSymptoms});

  WorstDay.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    date = json['date'];
    totalSymptoms = json['totalSymptoms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['date'] = this.date;
    data['totalSymptoms'] = this.totalSymptoms;
    return data;
  }
}
