class Questionss {
  QuestionData? data;

  Questionss.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new QuestionData.fromJson(json['data']) : null;
  }

}

class QuestionData {
  String? sId;
  dynamic text;
  List<Options>? options;
  String? createdAt;
  String? updatedAt;
  int? iV;

  QuestionData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    text = json['text'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}

class Options {
  String? value;
  bool? selected;
  String? sId;
  String? createdAt;
  String? updatedAt;

  Options.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    selected = json['selected'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}