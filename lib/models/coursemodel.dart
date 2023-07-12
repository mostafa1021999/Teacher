class Course {
  List<CourseData> data =[];

  Course.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((element){data.add(CourseData.fromJson(element));});  }

}

class CourseData {
  String? sid;
  String? name;
  String? year;
  String? createdAt;
  String? updatedAt;
  String? id;


  CourseData.fromJson(Map<String, dynamic> json) {
    sid = json["_id"];
    name = json["name"];
    year = json["year"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    id = json["id"];
  }

}