import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:teacher/sharedPreferences/sharedPreferences.dart';

dynamic appTitle = 'Teacher';
Widget ?page;
var fontHead=GoogleFonts.lato(fontSize:30,fontWeight: FontWeight.bold,color: cardFontColor);
var fontNontification=GoogleFonts.lato(fontSize:18,fontWeight: FontWeight.bold,color: cardFontColor);
var fontLessonName=GoogleFonts.lato(fontSize:30,fontWeight: FontWeight.bold,);
var fontCard=GoogleFonts.lato(fontSize: 20,fontWeight: FontWeight.bold,);
var fontAppName=GoogleFonts.aclonica();
var fontDescription=GoogleFonts.lato(fontSize:23,fontWeight: FontWeight.bold,);
var fontBottom=GoogleFonts.lato(fontSize:25,fontWeight: FontWeight.bold,color: cardFontColor);
var quizFontBottom=GoogleFonts.lato(fontSize:18,fontWeight: FontWeight.bold,color: cardFontColor);
var fontSubmit=GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize:30.0,color: Colors.green);
var DrawerFont=GoogleFonts.lato(fontSize:22,fontWeight: FontWeight.w700,);
bool? isdark=Save.getData(key: 'isdark');
String name='';
var courseId;
String phone='';
String userId='';
String token='';
int currentQuestionIndex = 1;
int quesIndex = 1;
double drawerItemSize=25;
var arr = [];
const boxHomeworkColor=Colors.blueAccent;
const mainColor=Colors.indigo;
const cardFontColor=Colors.white;

Widget drawerHeader(mainItemColor,itemIcon,itemName){
  return Row(children: [
    Icon(itemIcon,color: mainItemColor,size: drawerItemSize,),
    const SizedBox(width: 10,),
    Expanded(child: Text(itemName,overflow: TextOverflow.fade,style: TextStyle(color: mainItemColor,fontSize: drawerItemSize,),))
  ],);
}
void toasts(String mass , Color color) => Fluttertoast.showToast(
    msg: mass,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 16.0
);
Widget drawerItems(mainItemColor,itemIcon,String itemName,onTap){
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: InkWell(
      onTap: onTap,
      child: Row(children: [
        Icon(itemIcon,size: drawerItemSize,),
        const SizedBox(width: 10,),
        Text(itemName,style: DrawerFont,)
      ],),
    ),
  );
}
void navigate(context , widget) => Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
void navigateAndFinish(context , Widget) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Widget), (route) => false);

Widget buildLesson(context,invarcar,index,course,model) => InkWell(
  onTap:invarcar,
  child: Padding(
    padding: const EdgeInsets.only(top: 8,bottom: 8),
    child:
    course? Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20),
      child: Card(
        shadowColor: mainColor,
        elevation: 4,
        child: Column(
          mainAxisAlignment:course? MainAxisAlignment.center:MainAxisAlignment.start,
          crossAxisAlignment:course? CrossAxisAlignment.center: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200.0,
              child:  Image.asset('assets/main_image.jpeg',width: double.infinity,height: 150, fit: BoxFit.fill,),
            ),
            const SizedBox(height: 10,),
            Text('${model.name}',maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,style:GoogleFonts.lato(fontSize: 25,fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,)
          ],
        ),
      ),
    ) :
    Card(
      shadowColor: mainColor,
      elevation: 10,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: mainColor,
          child: Text(
            '$index',
            style: GoogleFonts.lato(color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)
          ),
        ),
        title: Text('${model.name}',maxLines: 2,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.bold),),
      ),
    )
  ),
);

Widget homeworkScreen(context,bool,invarcar,index,quiz,istaken,quizDegree){
  for (var i = 0; i < quiz.takenBy.length; i++){
    if(quiz.takenBy[i].user==userId)
    {istaken=true;
    quizDegree=quiz.takenBy[i].score;
    }
  }
  return SizedBox(
    height: 120,
    child: Card(
      elevation: 8,
      shadowColor: mainColor,
      child: Row(
        children: [
          const SizedBox(width: 10,),
          Column(
            children: [
              Text('Quiz ${index+1}',maxLines: 1,textAlign: TextAlign.center,
                style: fontDescription,),
              Spacer(),
              Text('10-2-2023',maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,),),
              SizedBox(height: 5,)
            ],        ),
          const Spacer(),
          istaken?
          CircularPercentIndicator(
            radius: 35.0,
            lineWidth: 10.0,
            animation: true,
            percent: quizDegree!/quiz.questions.length,
            center:  Text(
              "$quizDegree/${quiz.questions.length}",
              style:
              fontCard,
            ),
            footer:  Text("quiz degree",
              style:fontCard,
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: mainColor,
          ):Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: mainColor),
              width: 130,
              child: MaterialButton(onPressed:invarcar,
                child:  Text('Start exam' , style: quizFontBottom),
              ),
            ),
          ),
        ],
      ),
    ),
  );

}

Widget bottom(name,icon,invarCar){return Center(
  child: Padding(
    padding: const EdgeInsets.only(top: 20.0),
    child:   Container(
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: mainColor),
      width: double.infinity,
      child: MaterialButton(onPressed:invarCar,
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,color: Colors.white,size: 25,),
            Text('$name' , style: fontBottom),
          ],
        ),
      ),),
  ),
);}

Widget degree(isQuiz,model){return  CircularPercentIndicator(
  radius: 50.0,
  lineWidth: 10.0,
  animation: true,
  percent: 0.7,
  center:  Text(
    "70.0%",
    style:
    TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
  ),
  footer:  Text(
    isQuiz?
    "quiz degree":"homework degree",
    style:
    const TextStyle(fontWeight: FontWeight.bold, fontSize:22.0),
  ),
  circularStrokeCap: CircularStrokeCap.round,

  progressColor: mainColor,
);}

Widget notificationScreen(data,){return Card(
  elevation: 4,
  shadowColor: mainColor,
  child:
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text('$data',maxLines: 2,textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 19,fontWeight: FontWeight.bold,),),
          ),
        ],
      ),
);}
