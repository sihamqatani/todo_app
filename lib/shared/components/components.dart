import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/shared/cubit/app_cubit.dart';

Widget defaulttextForm(
        {@required TextEditingController controller,
        @required TextInputType type,
        Function onSubmitt,
        Function onChange,
        @required Function validator,
        @required String label,
        IconData prefix,
        Function onTap,
        bool isClickable = true}) =>
    TextFormField(
      enabled: isClickable,
      decoration: InputDecoration(
        prefixIcon: Icon(prefix),
        labelText: label,
      ),
      controller: controller,
      onTap: onTap,
      keyboardType: type,
      onChanged: onChange,
      onFieldSubmitted: onSubmitt,
      validator: validator,
    );

Widget buildTaskItem(Map model, context) {
  return Dismissible(key:Key(model['id'].toString()) ,
    onDismissed:( direction){
     AppCubit.get(context).deleteFromDataBase(id: model['id']);
    }  ,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text('${model['time']}'),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${model['title']}'),
                Text('${model['date']}'),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(
              icon: Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              onPressed: () {
                AppCubit.get(context)
                    .updateDataBase(status: 'done', id: model['id']);
              }),
          SizedBox(
            width: 20,
          ),
          IconButton(
              icon: Icon(
                Icons.archive,
                color: Colors.black12,
              ),
              onPressed: () {
                AppCubit.get(context)
                    .updateDataBase(status: 'archive', id: model['id']);
              }),
        ],
      ),
    ),
  );
}
Widget buildTasks({@required List<Map>tasks}){
  return ConditionalBuilder(
    condition: tasks.length > 0,
    builder: (context) => ListView.separated(
        itemBuilder: (context, index) {
          return buildTaskItem(tasks[index], context);
        },
        separatorBuilder: (context, index) {
          return Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          );
        },
        itemCount: tasks.length),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            color: Colors.grey,
            size: 100,
          ),
          Text(
            'No tasks Yet , Please Add Some Tasks',
            style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  ) ;
}
