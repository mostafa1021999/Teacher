import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher/componants/componants.dart';
import 'package:teacher/cubit/teacher_cubit.dart';
import 'package:teacher/modules/mainQuiz.dart';

class Quiz extends StatelessWidget {
  const Quiz({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCubit, TeacherState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    var quizList= TeacherCubit.get(context).quizzes;
    return ConditionalBuilder(condition: state is !QuizLoading && quizList!=null,
      fallback: (context)=> const Center(child: CircularProgressIndicator(),),
      builder: (context)=> Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context,index)=>homeworkScreen(context,true,(){
              currentQuestionIndex=0;
              TeacherCubit.get(context).questionOptions('${quizList.data[index].questions[0]}');
              navigate(context, QuizScreen(index: index, score: 0,));},index,quizList.data[index],false,0),
            separatorBuilder:(context,index) =>const Padding(padding:  EdgeInsets.all(10.0),),
            itemCount: quizList!.data.length),
      ),
    );
  },
);
  }
}