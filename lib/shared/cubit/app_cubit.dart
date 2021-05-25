import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/modules/archived_screen.dart';
import 'package:todoapp/modules/done_screen.dart';
import 'package:todoapp/modules/new_task_screen.dart';
import 'package:todoapp/shared/cubit/app_States.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context){return BlocProvider.of(context);}
  int currentIndex = 0;
  List<Widget> screen = [NewTaskScreen(), DoneScreen(), ArchivedScreen()];
  List<String> titles = ['Newtask', 'Done', 'Archived'];
  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBarState());

  }

}