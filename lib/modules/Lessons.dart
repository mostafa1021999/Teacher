import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher/componants/componants.dart';
import 'package:teacher/cubit/teacher_cubit.dart';
import 'package:teacher/modules/chat.dart';
import 'package:teacher/modules/mainLesson.dart';

class UnitLesson extends StatelessWidget {
  const UnitLesson({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCubit, TeacherState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var lessonList= TeacherCubit.get(context).lessonPage;
        return  Scaffold(
          appBar: AppBar(title: Center(child: Text(appTitle,style: fontAppName,)),
            actions: [
              Padding(   padding: const EdgeInsets.only(left: 10.0),
                  child:IconButton( onPressed: () {  navigate(context,const ChatPage()); },
                    icon: const Icon(Icons.chat_outlined,size: 30),))],
          ),
          body: ConditionalBuilder(condition: state is !GetLessonLoading && lessonList!=null,
            fallback: (context)=> const Center(child: CircularProgressIndicator(),),
            builder: (context)=>ListView.separated(
              separatorBuilder:(context,index) =>const Padding(padding:  EdgeInsets.zero,),
              itemCount:lessonList!.data.length,
              itemBuilder: (context,index)=>Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Card(
                    color: Colors.black54,
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text('${lessonList.data[index].name}',maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,style:fontHead),
                        ),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          childAspectRatio: 2/ 0.5,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          crossAxisCount: 1,
                          children: List.generate(lessonList.data[index].lessons.length,
                                (lessonIndex) =>
                                buildLesson(context, () {
                                  lessonList.data[index].lessons[lessonIndex].id;
                                  TeacherCubit.get(context).getHomework('${lessonList.data[index].lessons[lessonIndex].id}',);
                                  TeacherCubit.get(context).quizPage('${lessonList.data[index].lessons[lessonIndex].id}',);
                                  navigate(context,  MainLesson(videoname: lessonList.data[index].lessons[lessonIndex].video,
                                    lessonDes: lessonList.data[index].lessons[lessonIndex].description,
                                    lessonName: lessonList.data[index].lessons[lessonIndex].name,
                                    clender: lessonList.data[index].lessons[lessonIndex].createdAt,
                                    filename: lessonList.data[index].lessons[lessonIndex].file,
                                    lessonid:lessonList.data[index].lessons[lessonIndex].id ,));
                                }, lessonIndex+1,false, lessonList.data[index].lessons[lessonIndex]),
                          ),),
                      ],),
                  ),
                ),
              ),
            ),
          ),
        );
      },

    );
  }
}