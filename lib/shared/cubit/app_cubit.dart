import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/modules/archived_screen.dart';
import 'package:todoapp/modules/done_screen.dart';
import 'package:todoapp/modules/new_task_screen.dart';
import 'package:todoapp/shared/cubit/app_States.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) {
    return BlocProvider.of(context);
  }

  int currentIndex = 0;
  List<Widget> screen = [NewTaskScreen(), DoneScreen(), ArchivedScreen()];
  List<String> titles = ['Newtask', 'Done', 'Archived'];
  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDataBase() {
    openDatabase('todo1.db', version: 1, onCreate: (database, version) {
      print('database created');
      database
          .execute(
              'CREATE TABLE  task1(id INTEGER PRIMARY KEY ,title TEXT,date TEXT ,time TEXT,status TEXT)')
          .then((value) {
        print('table created');
      }).catchError((error) {
        print('error happened when createa table${error.toString()}');
      });
    }, onOpen: (database) {
      getFromDataBase(database);
      print('database opened');
    }).then((value) {
      database = value;

      emit(AppCreateDataBaseState());
    });
  }

  Future insertIntoDatabase(
      {@required String title,
      @required String time,
      @required String date}) async {
    await database.transaction((txn) => txn
            .rawInsert(
                'INSERT INTO task1(title,time,date,status) VALUES("$title","$time","$date","new")')
            .then((value) {
          print('$value inserted is ok');
          emit(AppInsertDataBaseState());
          getFromDataBase(database);
        }).catchError((error) => print('catch error${error.toString()}')));
  }

  void updateDataBase({@required String status, @required int id}) async {
    await database.rawUpdate('UPDATE task1 SET status = ? WHERE id = ?',
        ['updated $status', id]).then((value) {
      getFromDataBase(database);
      emit(AppUpdateDataBaseState());
    });
  }

  void getFromDataBase(database) {
    newTasks =[];
    doneTasks =[];
    archiveTasks =[];
    emit(AppGetDataBaseLoadingState());
    database.rawQuery('SELECT * FROM task1').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else {
          if (element['status'] == 'archive')
          archiveTasks.add(element);
        else
          doneTasks.add(element);
        }
      });

      emit(AppGetDataBaseState());
    });
  }
  void deleteFromDataBase({@required int id})async{
    database.rawDelete('DELETE FROM task1 WHERE id=?',[id]).then((value) {
      getFromDataBase(database);
      emit(AppDeleteDataBaseState());
    } );
    
  }

  void changeBottomState({@required bool isShow, @required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
