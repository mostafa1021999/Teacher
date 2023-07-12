class OptionsModel {
  String? status;
  Data? data;

  OptionsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  bool ?score;
  String? question;
  String? student;
  String? sId;
  int ?iV;

  Data.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    question = json['question'];
    student = json['student'];
    sId = json['_id'];
    iV = json['__v'];
  }
}