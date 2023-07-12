import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher/componants/componants.dart';
import 'package:teacher/cubit/teacher_cubit.dart';
import 'package:teacher/modules/Lessons.dart';

class classes extends StatelessWidget {
  const classes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCubit, TeacherState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        var courseList= TeacherCubit.get(context).page;
        return ConditionalBuilder(condition: state is !CourseLoading && courseList!= null ,
          fallback: (context)=> const Center(child: CircularProgressIndicator(),),
          builder: (context)=> ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context,index)=>AnimatedContainer(
                curve: Curves.easeInOut,
                duration: Duration(microseconds: 200+(index*100)),
                child: buildLesson(context,(){ TeacherCubit.get(context).getLesson('${courseList.data[index].id}');
                navigate(context,const UnitLesson());},null,true,courseList.data[index]),
              ), separatorBuilder:(context,index) =>const Padding(padding:  EdgeInsets.all(10.0),),
              itemCount:courseList!.data.length ),
        );
      },
    );
  }
}
