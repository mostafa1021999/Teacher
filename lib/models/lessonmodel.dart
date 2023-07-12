class Lesson {
  List<LessonData> data=[];

  Lesson.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((element){data.add(LessonData.fromJson(element));});  }
}

class LessonData {
  String? id;
  String? name;
  List<LessonsData> lessons=[];

  LessonData.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    name = json["name"];
    json['lessons'].forEach((element){lessons.add(LessonsData.fromJson(element));});  }
}

class LessonsData {
  String? id;
  String? name;
  String? video;
  String? file;
  String? description;
  String? createdAt;

  LessonsData.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    name = json["name"];
    video = json["video"];
    file = json["file"];
    description = json["description"];
    createdAt = json["createdAt"];
  }
}