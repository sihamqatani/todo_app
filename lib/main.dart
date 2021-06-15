import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/layouts/home_layout.dart';
import 'package:todoapp/shared/cubit_observer.dart';



void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',



      home:HomeLayout(),
    );
  }
}

