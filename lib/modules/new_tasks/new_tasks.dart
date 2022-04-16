import 'package:flutter/material.dart';
import 'package:todo_app/widgets/components.dart';
import 'package:todo_app/widgets/constants.dart';

class NewTasks extends StatefulWidget {
  const NewTasks({Key key}) : super(key: key);
  @override
  State<NewTasks> createState() => _NewTasksState();
}

class _NewTasksState extends State<NewTasks> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => tasksItem(tasksList[index]),
        separatorBuilder: (context, index) => Container(
          width: double.infinity,
          height: 1,
          color: Colors.grey.withOpacity(.3),
          margin: EdgeInsets.symmetric(horizontal: 8,vertical: 0),
        ),
        itemCount: tasksList.length);
  }
}
