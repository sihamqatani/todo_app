import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/cubit/app_States.dart';
import 'package:todoapp/shared/cubit/app_cubit.dart';

class HomeLayout extends StatelessWidget {
  Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var tittleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  /* void initState() {
    super.initState();
    createDataBase();
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
        if (state is AppInsertDataBaseState) {
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(AppCubit.get(context)
                .titles[AppCubit.get(context).currentIndex]),
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
            child: Icon(AppCubit.get(context).fabIcon),
            onPressed: () {
              if (AppCubit.get(context).isBottomSheetShown) {
                   if(formKey.currentState.validate()) {
                  AppCubit.get(context).insertIntoDatabase(
                      title: tittleController.text,
                      time: timeController.text,
                      date: dateController.text);

                  AppCubit.get(context)
                      .changeBottomState(isShow: false, icon: Icons.edit);}
                } else {
                scaffoldKey.currentState
                    .showBottomSheet(
                        (context) => Container(
                              color: Colors.white,
                              width: double.infinity,

                              padding: EdgeInsets.all(14),
                              // height: 250,
                              child: Form(key: formKey,
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
                                              .then((value) =>
                                                  timeController.text = value
                                                      .format(context)
                                                      .toString());
                                          // print(value.format(context);;

                                          print('tapped time');
                                        },
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return 'text must not be empty';

                                        }},
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
                                                  lastDate: DateTime.parse(
                                                      '2021-06-07'))
                                              .then((value) =>
                                                  dateController.text =
                                                      DateFormat.yMMMd()
                                                          .format(value));
                                          // print(value.format(context);;
                                        },
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return 'date must not be empty';
                                          }

                                        },
                                        label: 'date labet',
                                        prefix: Icons.calendar_today),
                                  ],
                                ),
                              ),
                            ),
                        elevation: 20)
                    .closed
                    .then((value) {
                  AppCubit.get(context)
                      .changeBottomState(isShow: false, icon: Icons.edit);
                  // AppCubit.get(context).isBottomSheetShown = false;
                  //setState(() {
                  //  fabIcon = Icons.edit;
                  // });
                });
                AppCubit.get(context)
                    .changeBottomState(isShow: true, icon: Icons.add);
                // AppCubit.get(context).isBottomSheetShown = true;
                /*setState(() {
                  fabIcon = Icons.add;
                });*/
              }
            },
          ),
          body: ConditionalBuilder(
            condition: state is! AppGetDataBaseLoadingState,
            builder: (context) => AppCubit.get(context)
                .screen[AppCubit.get(context).currentIndex],
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
        );
      }),
    );
  }
}
