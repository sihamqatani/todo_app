import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/layouts/home_layout.dart';
import 'package:todoapp/shared/app_cubit.dart';



void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',


      home:HomeLayout(),
    );
  }
}

