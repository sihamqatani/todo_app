import 'package:flutter/material.dart';
import 'package:todoapp/modules/archived_screen.dart';
import 'package:todoapp/modules/done_screen.dart';
import 'package:todoapp/modules/new_task_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/shared/components/components.dart';

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<Widget> screen = [NewTaskScreen(), DoneScreen(), ArchivedScreen()];
  List<String> titles = ['Newtask', 'Done', 'Archived'];
  Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var tittleController = TextEditingController();
  @override
  void initState() {
    super.initState();
    createDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
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
            Navigator.pop(context);
            isBottomSheetShown = false;
            setState(() {
              fabIcon = Icons.edit;
            });
          } else {
            scaffoldKey.currentState.showBottomSheet((context) => Container(
                  color: Colors.lightBlue,
                  width: double.infinity,
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        defaulttextForm(
                            controller: tittleController,
                            type: TextInputType.text,
                            validator: (String value){if(value.isEmpty){return 'text must not be empty';}return null;},
                            label: 'text label',
                            prefix: Icons.title),
                      ],
                    ),
                  ),
                ));
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
      ),
      body: screen[currentIndex],
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
      print('database opened');
    });
  }

  void insertIntoDatabase() {
    database.transaction((txn) => txn
        .rawInsert(
            'INSERT INTO task1(title,date,time,status) VALUES("first task","125","08","new")')
        .then((value) => print('$value inserted is ok'))
        .catchError((error) => print('catch error${error.toString()}')));
  }
}
