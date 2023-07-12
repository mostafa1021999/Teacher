class QuizModel {
  List<QuizData> data=[];

  QuizModel.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((element){data.add(QuizData.fromJson(element));});  }
}

class QuizData {
  List<TakenBy> takenBy=[];
  String? sId;
  String? lesson;
  List<String> questions=[];
  String? createdAt;
  String? updatedAt;
  int? iV;

  QuizData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    lesson = json['lesson'];
    questions = json['questions'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    json['takenBy'].forEach((element){takenBy.add(TakenBy.fromJson(element));});
  }
}

class TakenBy {
  String? user;
  int ?score;
  String? sId;

  TakenBy.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    score = json['score'];
    sId = json['_id'];
  }
}
