import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:teacher/sharedPreferences/sharedPreferences.dart';
part 'them_state.dart';

class ThemCubit extends Cubit<ThemState> {
  ThemCubit() : super(ThemInitial());
  static ThemCubit get(context) => BlocProvider.of(context);
  bool isdark = false;

  void changeapppmode({bool? formshare}) {
    if (formshare != null) {
      isdark = formshare;
      emit(ChangeMode());
    }
    else {
      isdark = !isdark;
      Save.putData(key: 'isdark', value: isdark).then((value) =>
          emit(ChangeMode()));
    }
  }
}
