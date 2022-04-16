import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defaultFormField({
  @required String label,
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onChange,
  @required Function validate,
  Function onTab,
  IconData prefix,
  bool enabled,


}) =>
    TextFormField(
      controller: controller,
      keyboardType: type ,
      onFieldSubmitted: onSubmit ,
      onChanged: onChange,
      validator: validate,
      onTap: onTab,
      enabled: enabled,
      decoration: InputDecoration(
        label: Text(label),
        prefixIcon: Icon(prefix),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8)
        )
      ),
    );

Widget tasksItem(Map model) =>Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      CircleAvatar(
        radius: 40,
        child: Text(model['time']),
      ),
      SizedBox(width: 16,),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(model['title'],style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height: 4,),
          Text(model['date'],style: TextStyle(color: Colors.grey),),
        ],
      )
    ],
  ),
);