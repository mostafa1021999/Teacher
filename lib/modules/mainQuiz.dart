import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tex_js/flutter_tex_js.dart';
import 'package:teacher/componants/componants.dart';
import 'package:teacher/cubit/teacher_cubit.dart';
import 'main.dart';

List<Options> ?questionLists;
int ?optionIndex;
String? selectedAnswer;
bool submit=false;

class QuizScreen extends StatelessWidget {
  int index;
  int score;
  QuizScreen({super.key,required this.index,required this.score});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCubit, TeacherState>(
  listener: (context, state) {

  },
  builder: (context, state) {
    var question=TeacherCubit.get(context).questionss;
    var quizList= TeacherCubit.get(context).quizzes;
    return Scaffold(
      body: ConditionalBuilder(condition: state is !QuestionLoading && question!=null ,
        fallback: (context)=> const Center(child: CircularProgressIndicator(),),
        builder: (context)=>  Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Question ${currentQuestionIndex + 1}/${quizList!.data[index].questions.length}",
                style: const TextStyle(
                  color: mainColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child:
                TexImage('${question!.data!.text}',color: Colors.white,fontSize: 18,),
              )
            ],
          ),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context,index)=>_answerButton(question.data!.options![index].value,context,index), separatorBuilder:(context,index) =>const Padding(padding:  EdgeInsets.zero,),
                  itemCount:question.data!.options!.length ,),
            ),
            const SizedBox(height: 20,),


            _nextButton(context,quizList.data[index].questions.length,quizList.data[index].questions[quesIndex],quizList.data[index].sId),
            const Expanded(child: Spacer())
          ]),
        ),
      ),
    );
  },
);

  }

  Widget _answerButton(answer,context,Thisindex) {
    bool isSelected = answer == selectedAnswer;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        child:
        TexImage('$answer',color: cardFontColor,fontSize: 15,),
        style: ElevatedButton.styleFrom(
          shape:  StadiumBorder(),
          primary: isSelected ? mainColor : boxHomeworkColor,
          onPrimary: isSelected ? boxHomeworkColor : Colors.black,
        ),
        onPressed: () {
            optionIndex=Thisindex;
            selectedAnswer = answer;
            print(answer);
            TeacherCubit.get(context).changeAnswer();
        },
      ),
    );
  }

  _nextButton(context,len,questionIndex,quizId) {
    bool isLastQuestion = false;
    if (currentQuestionIndex == len - 1) {
      isLastQuestion = true;
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(

          shape: const StadiumBorder(),
          primary: optionIndex==null ? Colors.black38 : boxHomeworkColor,
          onPrimary: Colors.white,
        ),
        onPressed: () {
          if(optionIndex!=null) {
            TeacherCubit.get(context).postaswer(
              questionid: questionIndex,
              index: '$optionIndex', quizId: '$quizId',
              score: score,);
          }
          if (isLastQuestion) {
            quesIndex++;
            TeacherCubit.get(context).questionOptions('$questionIndex');
            quesIndex=0;
            TeacherCubit.get(context).questionOptions('$questionIndex');
            submit= true;
            navigateAndFinish(context, MyApp(start: page!, usertoken: token,));
            }
           else {
            currentQuestionIndex++;
            if (currentQuestionIndex != len - 1)
            {quesIndex++;}
            else
            {quesIndex=0;}
            TeacherCubit.get(context).questionOptions('$questionIndex');
              TeacherCubit.get(context).changeAnswer();
          }
        },
        child: isLastQuestion ? const Text("Submit"):const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Next'),
            SizedBox(width: 10,),
            Icon(Icons.arrow_forward_outlined,size: 25,),
          ],
        ),
      ),
    );

  }
  _showScoreDialog(context,len) {
    bool isPassed = false;
    currentQuestionIndex=0;
    if (score >= len * 0.5) {
      isPassed = true;
    }
    String title = isPassed ? "Passed " : "Failed";

    return AlertDialog(
      title: Text(
        title + " | Score is $score",
        style: TextStyle(color: isPassed ? Colors.green : Colors.redAccent),
      ),
      content: ElevatedButton(
        child: const Text("Restart"),
        onPressed: () {
          Navigator.pop(context);
            currentQuestionIndex = 0;
            score = 0;
            selectedAnswer = null;
          TeacherCubit.get(context).changeAnswer();
        },
      ),
    );
  }
}