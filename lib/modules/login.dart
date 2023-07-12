import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher/componants/componants.dart';
import 'package:teacher/cubit/teacher_cubit.dart';
import 'package:teacher/cubit/them_cubit.dart';
import 'package:teacher/modules/main.dart';
import 'package:teacher/sharedPreferences/sharedPreferences.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController(), passwordController=TextEditingController();
    var formKey=GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => TeacherCubit(),
      child: BlocConsumer<TeacherCubit, TeacherState>(
        listener: (context, state) {
          if(state is LoginSuccess){
            if((state.loger.status)=='ok'){
              Save.saveData(key: 'save', value: true).then((value){});
              Save.saveData(key: 'name', value: state.loger.data!.user!.name).then((value){});
              Save.saveData(key: 'token', value: state.loger.data!.user!.token).then((value){});
              Save.saveData(key: 'phone', value: state.loger.data!.user!.phoneNumber).then((value){});
              Save.saveData(key: 'userid', value: state.loger.data!.user!.sId).then((value){});
              navigateAndFinish(context,
                  MyApp(start: MyHomePage(title: appTitle,name: state.loger.data!.user!.name !,phone:state.loger.data!.user!.phoneNumber !),
                    usertoken: '${state.loger.data!.user!.token}',),
                  );
            }
          }else if(state is LoginError){
            toasts('Phone number or password is wrong', Colors.red);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      colors:ThemCubit.get(context).isdark? [
                        mainColor,
                        boxHomeworkColor,
                        mainColor
                      ]:
                      [
                        Colors.black12,
                        Colors.grey,
                        Colors.grey
                      ]
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 80,),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Login', style:  TextStyle(color: Colors.white, fontSize: 40),),
                        SizedBox(height: 10,),
                        Text('Welcome Back', style:  TextStyle(color: Colors.white, fontSize: 18),),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: ThemCubit.get(context).isdark? Colors.white:Colors.black87 ,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: <Widget>[
                                const SizedBox(height: 30,),
                                const SizedBox(height: 30,),
                                TextFormField(
                                  validator: (value){
                                    if(value!.isEmpty){return'enter valid phone number';}
                                    return null;
                                  },
                                  controller: phoneController,
                                  decoration:const  InputDecoration(label: Text('phone number') , prefixIcon: Icon(Icons.phone_outlined) , border:  OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                Container(
                                    decoration:const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                                    ),
                                    child: const SizedBox(height: 30,)),
                                TextFormField(
                                  onFieldSubmitted:(value){
                                    if(formKey.currentState!.validate()){
                                      TeacherCubit.get(context).userLogin(phoneNumber: phoneController.text,
                                          password: passwordController.text);}
                                  },
                                  validator: (value){
                                    if(value!.isEmpty){return 'enter valid password';}
                                    return null;
                                  },
                                  controller: passwordController,
                                  decoration: InputDecoration(label:  const Text('Password') ,
                                    prefixIcon: const Icon(Icons.lock) ,
                                    border: const OutlineInputBorder(),
                                    suffixIcon: IconButton(onPressed: (){TeacherCubit.get(context).changePassType();}, icon: Icon(TeacherCubit.get(context).icon)),
                                  ),
                                  keyboardType: TextInputType.visiblePassword, obscureText: TeacherCubit.get(context).type,
                                ),

                                const SizedBox(height: 20,),
                                ConditionalBuilder(builder: (context) =>
                                    Container(
                                      width: double.infinity,
                                      color: mainColor,child: MaterialButton(onPressed: (){
                                      if(formKey.currentState!.validate()){
                                        TeacherCubit.get(context).userLogin(phoneNumber: phoneController.text,
                                            password: passwordController.text);}

                                    },
                                      child:  const Text('Login'  , style: TextStyle( fontWeight: FontWeight.bold , fontSize: 25,color: Colors.white)),
                                    ),), condition: state is ! LoginLoading, fallback: (context) => const Center(child: CircularProgressIndicator(),),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}