import 'package:flutter/material.dart';

Widget defaulttextForm({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmitt,
  Function onChange,
  @required Function validator,
  @required String label,
  @required IconData prefix
}) =>
    TextFormField(decoration:InputDecoration(prefixIcon:Icon(prefix) ,
    labelText:label ,suffixIcon:Icon( prefix),  ) ,
      controller: controller,
      keyboardType: type,
      onChanged: onChange,
      onFieldSubmitted: onSubmitt
      ,
      validator:validator,
    );
