import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teacher/componants/componants.dart';
import 'package:teacher/cubit/teacher_cubit.dart';
import 'package:teacher/modules/chat.dart';
import 'package:teacher/modules/homeworks.dart';
import 'package:teacher/modules/quizzes.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';



class MainLesson extends StatelessWidget {
  var videoname;
  var filename;
  var lessonDes;
  var lessonName;
  var clender;
  var lessonid;
  MainLesson({super.key,required this.videoname,required this.lessonDes,required this.lessonName,required this.clender,required this.filename,required this.lessonid});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCubit,TeacherState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        TabController ?controller;
        final FlickManager flickManager=FlickManager(

          videoPlayerController:
          VideoPlayerController.network(
              'https://e-learning-platform-server.onrender.com/videos/$videoname'),
          autoPlay: false,
        );
        return DefaultTabController(
          initialIndex: 0,
          length: 3,
          child: Scaffold(
            appBar:AppBar(title: Center(child: Text(appTitle,style: fontAppName,)),actions: [
              Padding(   padding: const EdgeInsets.all(10.0),
                  child:IconButton( onPressed: () {  navigate(context,const ChatPage()); },
                    icon: const Icon(Icons.chat_outlined,size: 30),))],
            bottom: TabBar(
              controller: controller,
              tabs: TeacherCubit.get(context).bottom,
              onTap: (index) {
                TeacherCubit.get(context).changenavigator(index);
                TeacherCubit.get(index);
              },),),
            body: TabBarView(
              controller: controller,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            FlickVideoPlayer(flickManager: flickManager),
                            Padding(
                              padding:  const EdgeInsets.only(top: 10.0,),
                              child:  Text(
                                "$lessonName",
                                style: fontLessonName,
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Text('Lesson description',maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,style: fontDescription,),
                            const SizedBox(height: 10,),
                            HtmlWidget('''$lessonDes''',),              ],
                        ),
                      ),
                      bottom('Download PDF', Icons.download, (){
                        startDownloading(context,filename,lessonName);})
                    ],
                  ),
                ),
                // UploadImageScreen(),
                Homework(LessonId: lessonid),
                const Quiz(),
              ],
            ),
          ),
        );
      },
    );
  }
}

void startDownloading(context,filename,lessonName)async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  var dir = await DownloadsPathProvider.downloadsDirectory;

  if(status.isGranted){
    if(dir != null){
      String savename = "$lessonName.pdf";
      String savePath = dir.path + "/$savename";
      print(savePath);
      //output:  /storage/emulated/0/Download/banner.png

      try {
        await Dio().download(
            'https://e-learning-platform-server.onrender.com/files/$filename',
            savePath,
            onReceiveProgress: (received, total) {
              if (total != -1) {
                print((received / total * 100).toStringAsFixed(0) + "%");
                //you can build progressbar feature too
                
              }
            });
        print("File is saved to download folder.");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("File Downloaded"),
        ));
      } on DioError catch (e) {
        print(e.message);
      }
    }
  }

}


