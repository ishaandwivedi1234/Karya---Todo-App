import 'package:flutter/material.dart';
import 'package:karya/model/task.dart';
import 'package:karya/widgets/appBar.dart';

class EditTask extends StatefulWidget {
  Task task;
  EditTask({this.task});
  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Edit Task", true),
      body: Container(
        child: Card(
          child: Text(widget.task.taskTitle),
        ),
      ),
    );
  }
}
