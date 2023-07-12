import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher/componants/componants.dart';
import 'package:teacher/models/coursemodel.dart';
import 'package:teacher/models/homeworkmodel.dart';
import 'package:teacher/models/lessonmodel.dart';
import 'package:teacher/models/loginmodel.dart';
import 'package:teacher/models/optionmodel.dart';
import 'package:teacher/models/questionmodel.dart';
import 'package:teacher/models/quizmodel.dart';
import 'package:teacher/modules/mainQuiz.dart';
import '../Dio Helper/dio.dart';
import 'package:http/http.dart' as http;

part 'teacher_state.dart';

class TeacherCubit extends Cubit<TeacherState> {
  bool type= true;
  StreamSubscription? _subscription;
  IconData icon=Icons.visibility_off_outlined;
  TeacherCubit() : super(TeacherInitial());
  static TeacherCubit get(context) => BlocProvider.of(context);
  int current = 0;
  List<Tab> bottom = [
    Tab(child:Text('Lesson',style: fontAppName)),
    Tab(child:Text('Homework',style: fontAppName)),
    Tab(child:Text('quizzes',style: fontAppName)),
  ];
  void changenavigator(int index) {
    current = index;
    emit(OtherState());
  }
  LoginUser ?l;
  void userLogin({
    required String phoneNumber,
    required String password
  }){
    emit(LoginLoading());
    DioHelper.postData(url: 'api/users/signin', data: {
      'phoneNumber' : phoneNumber,
      'password' : password,
    }).then((value) {
      l= LoginUser.fromJson(value.data);
      emit(LoginSuccess(l!));
      print(l!.data!.user!.token);
    }).catchError((error) {
      emit(LoginError(error.toString()));
      print(error.toString());
    });
  }
  void changePassType(){
    type =!type;
    icon =  type ?  Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(SetPass());
  }

  Course? page;
  void coursesPage(usertoken){
    emit(CourseLoading());
    DioHelper.getData(url: 'api/courses/user',
      token: usertoken,
    ).then((value) {
      page=Course.fromJson(value.data);
      token=usertoken;
      emit(CourseSuccess());
    }).catchError((error) {
      emit(CourseError());
    });
  }

  Lesson? lessonPage;
  void getLesson(courseId){
    emit(GetLessonLoading());
    DioHelper.getData(url: 'api/lessons/units/$courseId',
      token: token,
    ).then((value) {
      lessonPage=Lesson.fromJson(value.data);
      emit(GetLessonSuccess());
    }).catchError((error) {
      emit(GetLessonError());
    });
  }

  HomeworksData? homework;
   void getHomework (lessonId) async {
     emit(GetHomeworkLoading());
     String url = "https://e-learning-platform-server.onrender.com/api/submits/$lessonId";
     final response = await http.get(Uri.parse(url),
         headers: {
           "Authorization": "Bearer ${token}"
         }
     );
     var responseData = json.decode(response.body);
     homework = HomeworksData.fromJson(responseData);
     emit(GetHomeworkSuccess());
   }

  QuizModel? quizzes;
  void quizPage(lessonid){
    emit(QuizLoading());
    DioHelper.getData(url: 'api/quizzes/lesson/$lessonid',
      token: token,
    ).then((value) {
      quizzes=QuizModel.fromJson(value.data);
      emit(QuizSuccess());
    }).catchError((error) {
      emit(QuizError());
    });
  }

  Questionss? questionss;
  void questionOptions(questionid){
    emit(QuestionLoading());
    DioHelper.getData(url: 'api/quizzes/questions/$questionid',
      token: token,
    ).then((value) {
      optionIndex=null;
      questionss=Questionss.fromJson(value.data);
      emit(QuestionSuccess());
    }).catchError((error) {
      emit(QuestionError());
    });
  }
  OptionsModel ?lll;
  void postaswer({
    required String index ,
    required String questionid,
    required String quizId,
    required int score,
  }){
    emit(SubmitLoading());
    DioHelper.postData(url: 'api/quizzes/questions/check/$questionid', token: token,data: {
      'index' : index,
    }).then((value) {
      selectedAnswer = null;
      lll=OptionsModel.fromJson(value.data);
      arr.add(lll!.data!.score);
      if(submit){
        for (var i = 0; i < arr.length; i++){
          if(arr[i]==true)
          {score++;}
        }
        postScore(score: '$score', quizId: quizId);
        arr=[];
      }
        emit(SubmitSuccess());
    }).catchError((error) {
      emit(SubmitError(error));
    });
  }
  void changeAnswer(){
    emit(ChangeAnswer());
  }
  void postScore({
    required String score ,
    required String quizId,
  }){
    emit(ScoreLoading());
    DioHelper.postData(url: 'api/quizzes/score/$quizId', token: token,data: {
      'score' : score,
    }).then((value) {
      emit(ScoreSuccess());
    }).catchError((error) {
      emit(ScoreError(error));
    });
  }
}
