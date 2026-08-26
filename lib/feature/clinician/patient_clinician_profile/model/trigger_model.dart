class TriggerModel {
  List<DetectedTriggers>? detectedTriggers;
  List<TopSymptoms>? topSymptoms;
  List<ChartData>? chartData;
  List<AiCategories>? aiCategories;
  int? periodDays;
  int? totalFoodLogs;
  int? totalSymptomLogs;
  bool? hasFoodTagsData;
  String? foodTagsGeneratedAt;

  TriggerModel(
      {this.detectedTriggers,
        this.topSymptoms,
        this.chartData,
        this.aiCategories,
        this.periodDays,
        this.totalFoodLogs,
        this.totalSymptomLogs,
        this.hasFoodTagsData,
        this.foodTagsGeneratedAt});

  TriggerModel.fromJson(Map<String, dynamic> json) {
    if (json['detectedTriggers'] != null) {
      detectedTriggers = <DetectedTriggers>[];
      json['detectedTriggers'].forEach((v) {
        detectedTriggers!.add(new DetectedTriggers.fromJson(v));
      });
    }
    if (json['topSymptoms'] != null) {
      topSymptoms = <TopSymptoms>[];
      json['topSymptoms'].forEach((v) {
        topSymptoms!.add(new TopSymptoms.fromJson(v));
      });
    }
    if (json['chartData'] != null) {
      chartData = <ChartData>[];
      json['chartData'].forEach((v) {
        chartData!.add(new ChartData.fromJson(v));
      });
    }
    if (json['aiCategories'] != null) {
      aiCategories = <AiCategories>[];
      json['aiCategories'].forEach((v) {
        aiCategories!.add(new AiCategories.fromJson(v));
      });
    }
    periodDays = json['periodDays'];
    totalFoodLogs = json['totalFoodLogs'];
    totalSymptomLogs = json['totalSymptomLogs'];
    hasFoodTagsData = json['hasFoodTagsData'];
    foodTagsGeneratedAt = json['foodTagsGeneratedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.detectedTriggers != null) {
      data['detectedTriggers'] =
          this.detectedTriggers!.map((v) => v.toJson()).toList();
    }
    if (this.topSymptoms != null) {
      data['topSymptoms'] = this.topSymptoms!.map((v) => v.toJson()).toList();
    }
    if (this.chartData != null) {
      data['chartData'] = this.chartData!.map((v) => v.toJson()).toList();
    }
    if (this.aiCategories != null) {
      data['aiCategories'] = this.aiCategories!.map((v) => v.toJson()).toList();
    }
    data['periodDays'] = this.periodDays;
    data['totalFoodLogs'] = this.totalFoodLogs;
    data['totalSymptomLogs'] = this.totalSymptomLogs;
    data['hasFoodTagsData'] = this.hasFoodTagsData;
    data['foodTagsGeneratedAt'] = this.foodTagsGeneratedAt;
    return data;
  }
}

class DetectedTriggers {
  String? sensitivity;
  String? matchedCategory;
  String? severity;

  DetectedTriggers({this.sensitivity, this.matchedCategory, this.severity});

  DetectedTriggers.fromJson(Map<String, dynamic> json) {
    sensitivity = json['sensitivity'];
    matchedCategory = json['matchedCategory'];
    severity = json['severity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sensitivity'] = this.sensitivity;
    data['matchedCategory'] = this.matchedCategory;
    data['severity'] = this.severity;
    return data;
  }
}

class TopSymptoms {
  String? symptom;
  int? count;

  TopSymptoms({this.symptom, this.count});

  TopSymptoms.fromJson(Map<String, dynamic> json) {
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

class ChartData {
  String? foodGroup;
  int? bloating;
  int? gas;
  int? pain;

  ChartData({this.foodGroup, this.bloating, this.gas, this.pain});

  ChartData.fromJson(Map<String, dynamic> json) {
    foodGroup = json['foodGroup'];
    bloating = json['Bloating'];
    gas = json['Gas'];
    pain = json['Pain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['foodGroup'] = this.foodGroup;
    data['Bloating'] = this.bloating;
    data['Gas'] = this.gas;
    data['Pain'] = this.pain;
    return data;
  }
}

class AiCategories {
  String? category;
  int? foodCount;
  String? insight;
  String? severity;

  AiCategories({this.category, this.foodCount, this.insight, this.severity});

  AiCategories.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    foodCount = json['food_count'];
    insight = json['insight'];
    severity = json['severity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['food_count'] = this.foodCount;
    data['insight'] = this.insight;
    data['severity'] = this.severity;
    return data;
  }
}
