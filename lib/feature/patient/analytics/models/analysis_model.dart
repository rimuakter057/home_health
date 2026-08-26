class AnalysisModel {
  String? id;
  String? userId;
  int? iV;
  int? categorisedCount;
  String? createdAt;
  int? foodsAnalysed;
  String? generatedAt;
  List<TopCategories>? topCategories;
  String? updatedAt;
  List<int>? usdaIdsUsed;

  AnalysisModel(
      {this.id,
        this.userId,
        this.iV,
        this.categorisedCount,
        this.createdAt,
        this.foodsAnalysed,
        this.generatedAt,
        this.topCategories,
        this.updatedAt,
        this.usdaIdsUsed});

  AnalysisModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    iV = json['__v'];
    categorisedCount = json['categorised_count'];
    createdAt = json['createdAt'];
    foodsAnalysed = json['foods_analysed'];
    generatedAt = json['generatedAt'];
    if (json['top_categories'] != null) {
      topCategories = <TopCategories>[];
      json['top_categories'].forEach((v) {
        topCategories!.add(new TopCategories.fromJson(v));
      });
    }
    updatedAt = json['updatedAt'];
    usdaIdsUsed = json['usda_ids_used'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['userId'] = this.userId;
    data['__v'] = this.iV;
    data['categorised_count'] = this.categorisedCount;
    data['createdAt'] = this.createdAt;
    data['foods_analysed'] = this.foodsAnalysed;
    data['generatedAt'] = this.generatedAt;
    if (this.topCategories != null) {
      data['top_categories'] =
          this.topCategories!.map((v) => v.toJson()).toList();
    }
    data['updatedAt'] = this.updatedAt;
    data['usda_ids_used'] = this.usdaIdsUsed;
    return data;
  }
}

class TopCategories {
  String? category;
  int? foodCount;
  String? insight;
  String? severity;

  TopCategories({this.category, this.foodCount, this.insight, this.severity});

  TopCategories.fromJson(Map<String, dynamic> json) {
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
