import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:teacher/Dio%20Helper/dio.dart';
import 'package:teacher/componants/componants.dart';
import 'package:teacher/cubit/them_cubit.dart';
import 'package:teacher/modules/chat.dart';
import 'package:teacher/modules/classes.dart';
import 'package:teacher/cubit/teacher_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher/modules/login.dart';
import 'package:teacher/sharedPreferences/sharedPreferences.dart';

import 'check internet.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  bool isConnected = await InternetConnectionChecker().hasConnection;
  if(isConnected ){
    toasts('No internet', Colors.redAccent);
  }
  await Save.init();
  DioHelper.init();
  bool ?login = Save.getData(key:'save');
  if(login ==true){
    name=Save.getData(key: 'name');
    phone=Save.getData(key: 'phone');
    token=Save.getData(key: 'token');
    userId=Save.getData(key: 'userid');
    page=MyHomePage(title: appTitle,name: name,phone: phone,);
  }else{
    page=Login();
  }
  await Future.delayed(Duration(seconds: 3));
  runApp(MyApp(start: page!, usertoken: token,));
}

class MyApp extends StatelessWidget {
  final String usertoken;
  final Widget start;
   MyApp({required this.start,super.key, required this.usertoken});
  final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    dividerColor: Colors.black12,
  );

  final lightTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    dividerColor: Colors.white54,
  );
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TeacherCubit()..coursesPage(usertoken),),
        BlocProvider(create: (context) => ThemCubit()..changeapppmode(formshare: isdark))
      ],
      child: BlocConsumer<TeacherCubit, TeacherState>(
        listener: (context, state) {
        },
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: mainColor,),
            themeMode: ThemCubit.get(context).isdark? ThemeMode.light:ThemeMode.dark ,
            darkTheme: ThemeData(
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.transparent,
              ),      textTheme: const TextTheme(bodyText1: TextStyle(color: Colors.white)),
              primarySwatch: Colors.grey,
              primaryColor: Colors.black,
              brightness: Brightness.dark,
              backgroundColor: const Color(0xFF212121),
              hintColor: Colors.white,
              dividerColor: Colors.black12,
              appBarTheme: const AppBarTheme(
                color: Colors.black54,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.black54,),
              ),),
            title: appTitle,
            home: start,
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title,required this.name,required this.phone});

  final String title;
  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCubit, TeacherState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Center(child: Text(appTitle,style: fontAppName,)),
              actions: [
                Padding(   padding: const EdgeInsets.all(10.0),
                    child:IconButton( onPressed: () {  navigate(context,const ChatPage()); },
                      icon: const Icon(Icons.chat_outlined,size: 30),))],),
            body: classes(),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration:  BoxDecoration(
                      color: ThemCubit.get(context).isdark? mainColor:Colors.black,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        drawerHeader(Colors.white,Icons.person,name),
                        drawerHeader(Colors.white,Icons.phone_android,phone),
                      ],),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        drawerItems(Colors.black,Icons.menu_book,'Courses',(){navigate(context,MyHomePage(title: title, name: name, phone: phone) );}),
                        drawerItems(Colors.black,Icons.chat,'Chat',(){navigate(context,ChatPage() );}),
                        drawerItems(Colors.black,Icons.dark_mode_outlined,'Dark mode',(){ThemCubit.get(context).changeapppmode();
                        TeacherCubit.get(context).changeAnswer();}),
                        drawerItems(Colors.black,Icons.exit_to_app,'LOGOUT',(){
                          Save.saveData(key: 'save', value: false).then((value){
                            navigateAndFinish(context,const Login());});
                        })

                      ],
                    ),
                  )

                ],
              ),
            ),
          );});
  }
}
