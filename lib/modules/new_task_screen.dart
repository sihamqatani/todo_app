import 'package:flutter/material.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/components/constants.dart';

class NewTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return buildTaskItem(tasks[index]);
        },
        separatorBuilder: (context, index) {
          return Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          );
        },
        itemCount: tasks.length);
  }
}
