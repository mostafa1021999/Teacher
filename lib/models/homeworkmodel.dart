class HomeworksData {
  List<Data> data=[];

  HomeworksData.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((element){
      print(element);
      print(element);
      print(element);
      data.add(Data.fromJson(element));});  }
}

class Data {
  String? sId;
  String? file;
  bool? reviewed;
  dynamic mark;
  String? createdAt;
  String? updatedAt;
  dynamic refMark;

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    file = json['file'];
    reviewed = json['reviewed'];
    mark = json['mark'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    refMark = json['refMark'];

  }
}

