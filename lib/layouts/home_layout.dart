import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/shared/components/constants.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:todoapp/shared/cubit/app_States.dart';
import 'package:todoapp/shared/cubit/app_cubit.dart';

class HomeLayout extends StatelessWidget {
  Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var tittleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  /* void initState() {
    super.initState();
    createDataBase();
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create:(context)=>AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(listener: (context,state){},
        builder:(context,state){return  Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
                AppCubit.get(context).titles[AppCubit.get(context).currentIndex]),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: AppCubit.get(context).currentIndex,
            onTap: (int index) {
              AppCubit.get(context).changeIndex(index);
              //setState(() {
              //  currentIndex = index;
              // });
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline), label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined), label: 'Archvied'),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(fabIcon),
            onPressed: () {
              if (isBottomSheetShown) {
                insertIntoDatabase(
                    title: timeController.text,
                    time: timeController.text,
                    date: dateController.text)
                    .then((value) {
                  Navigator.pop(context);
                  isBottomSheetShown = false;
                  // setState(() {
                  //   fabIcon = Icons.edit;
                  // }
                  //   );
                });
              } else {
                scaffoldKey.currentState
                    .showBottomSheet(
                        (context) => Container(
                      color: Colors.white,
                      width: double.infinity,

                      padding: EdgeInsets.all(14),
                      // height: 250,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaulttextForm(
                              controller: tittleController,
                              type: TextInputType.text,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'text must not be empty';
                                }
                                return null;
                              },
                              label: 'task label',
                              prefix: Icons.title),
                          SizedBox(
                            height: 20,
                          ),
                          defaulttextForm(
                              controller: timeController,
                              type: TextInputType.datetime,
                              onTap: () {
                                showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                    .then((value) => timeController.text =
                                    value.format(context).toString());
                                // print(value.format(context);;

                                print('tapped time');
                              },
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'text must not be empty';
                                }
                                return null;
                              },
                              label: 'timelabel',
                              prefix: Icons.timer),
                          defaulttextForm(
                              controller: dateController,
                              type: TextInputType.datetime,
                              onTap: () {
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate:
                                    DateTime.parse('2021-06-07'))
                                    .then((value) => dateController.text =
                                    DateFormat.yMMMd().format(value));
                                // print(value.format(context);;
                              },
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'date must not be empty';
                                }
                                return null;
                              },
                              label: 'date labet',
                              prefix: Icons.calendar_today),
                        ],
                      ),
                    ),
                    elevation: 20)
                    .closed
                    .then((value) {
                  isBottomSheetShown = false;
                  //setState(() {
                  //  fabIcon = Icons.edit;
                  // });
                });
                isBottomSheetShown = true;
                /*setState(() {
                  fabIcon = Icons.add;
                });*/
              }
            },
          ),
          body: ConditionalBuilder(
            condition: true,
            builder: (context) =>
            AppCubit.get(context).screen[AppCubit.get(context).currentIndex],
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
        );}
      ),
    );
  }

  void createDataBase() async {
    database = await openDatabase('todo1.db', version: 1,
        onCreate: (database, version) {
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
      getFromDataBase(database).then((value) {
        tasks = value;
        print(tasks);
      });
      print('database opened');
    });
  }

  Future insertIntoDatabase(
      {@required String title,
      @required String time,
      @required String date}) async {
    await database.transaction((txn) => txn
        .rawInsert(
            'INSERT INTO task1(title,time,date,status) VALUES("$title","$time","$date","new")')
        .then((value) => print('$value inserted is ok'))
        .catchError((error) => print('catch error${error.toString()}')));
  }

  Future<List<Map>> getFromDataBase(database) async {
    return await database.rawQuery('SELECT * FROM task1');
  }
}
