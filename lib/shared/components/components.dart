import 'package:flutter/material.dart';

Widget defaulttextForm({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmitt,
  Function onChange,
  @required Function validator,
  @required String label,
  IconData prefix,
  Function onTap,
  bool isClickable=true
}) =>
    TextFormField(enabled:isClickable ,
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
Widget buildTaskItem(Map model){
  return  Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(children: [
      CircleAvatar(radius:40 ,
        child: Text('${model['time']}'),),
      SizedBox(width: 20,),
      Column(mainAxisSize: MainAxisSize.min,
        children: [
          Text('${model['title']}'),
          Text('${model['date']}'),
        ],),
    ],),
  );
}
