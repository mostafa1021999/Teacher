import 'dart:io';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:teacher/cubit/teacher_cubit.dart';
import '../componants/componants.dart';
import 'package:http_parser/http_parser.dart';

class Homework extends StatelessWidget {
  var LessonId;

  Homework({super.key,required this.LessonId});
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<TeacherCubit, TeacherState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    var homeworklist=TeacherCubit.get(context).homework;
    return ConditionalBuilder(condition: state is !GetHomeworkLoading && homeworklist!=null,
      fallback: (context)=> const Center(child: CircularProgressIndicator(),),
      builder: (context)=> Padding(
        padding: const EdgeInsets.all(8.0),
        child:
        quizAndHomework(homeworklist,true, (){getFileFromFiles(context,LessonId,);})
      ),
    );
    },
);
  }

  getFileFromFiles(context,lessonid) async {
  FilePickerResult? filePickerResult;
  File? pickedFile;

  filePickerResult = await FilePicker.platform.pickFiles();

  if (filePickerResult != null) {
    pickedFile = File(filePickerResult.files.single.path.toString());
    var fileName = pickedFile.path.split('/').last;
    print(fileName);
    var formData = FormData.fromMap({
      'title': 'Upload Dokumen',
      'file': await MultipartFile.fromFile(pickedFile.path,
          filename: fileName, contentType: MediaType('application', 'pdf')),
      "type": "application/pdf"
    });

    var response = await Dio().post("https://e-learning-platform-server.onrender.com/api/submits/$lessonid",
        options: Options(
            contentType: 'multipart/form-data',
            headers: {HttpHeaders.authorizationHeader: "Bearer "+ token}),
        data: formData).catchError((e) => print(e.response.toString()));
    print(response.data);
    return response;
  }
}
  Widget quizAndHomework(model,isHomework,invar){return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(child: CircularPercentIndicator(
        radius: 60.0,
        lineWidth: 10.0,
        animation: true,
        percent:model?.data.length ==0 ? 0.0: model?.data[0].mark /model?.data[0].refMark,
        center:  Text(
          model?.data.length ==0 ? "0.0%": "${model?.data[0].mark}/${model?.data[0].refMark}",
          style:fontDescription,
        ),
        footer:    Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text("Homework degree", style: fontDescription,),
        ),
        circularStrokeCap: CircularStrokeCap.round,

        progressColor: mainColor,
      )),
      model?.data.length ==0 ? bottom(isHomework?'Upload homework':"Start quiz",isHomework? Icons.upload:null, invar):
      Text("submitted", style: fontSubmit,
      ),
    ],
  );}}
