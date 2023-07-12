part of 'teacher_cubit.dart';

@immutable
abstract class TeacherState {}

class TeacherInitial extends TeacherState {}

class OtherState extends TeacherState{}

class SetPass extends TeacherState {}

class LoginLoading extends TeacherState{}

class LoginSuccess extends TeacherState{
  final LoginUser loger;
  LoginSuccess(this.loger);
}

class LoginError extends TeacherState{
  final error;
  LoginError(this.error);
}
class CourseLoading extends TeacherState{}

class CourseSuccess extends TeacherState{}

class CourseError extends TeacherState{}

class GetLessonLoading extends TeacherState{}

class GetLessonSuccess extends TeacherState{}

class GetLessonError extends TeacherState{}

class uploadSuccess extends TeacherState{}

class uploadnotSuccess extends TeacherState{}

class GetHomeworkLoading extends TeacherState{}

class GetHomeworkSuccess extends TeacherState{}

class GetHomeworkError extends TeacherState{}

class QuizLoading extends TeacherState{}

class QuizSuccess extends TeacherState{}

class QuizError extends TeacherState{}

class QuestionLoading extends TeacherState{}

class QuestionSuccess extends TeacherState{}

class QuestionError extends TeacherState{}

class ChangeAnswer extends TeacherState{}

class SubmitLoading extends TeacherState{}

class SubmitSuccess extends TeacherState{}

class SubmitError extends TeacherState{
  final error;
  SubmitError(this.error);
}

class ScoreLoading extends TeacherState{}

class ScoreSuccess extends TeacherState{}

class ScoreError extends TeacherState{
  final error;
  ScoreError(this.error);
}
