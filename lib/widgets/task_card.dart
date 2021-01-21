import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:karya/model/task.dart';
import 'package:karya/model/user.dart';
import 'package:karya/pages/home.dart';

import 'package:karya/widgets/colors.dart';
import 'package:karya/widgets/text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskCard extends StatefulWidget {
  Task task;
  User currentUser;
  String token;

  TaskCard({this.task, this.token, this.currentUser});

  @override
  _TaskCardState createState() =>
      _TaskCardState(token: token, task: task, currentUser: currentUser);
}

class _TaskCardState extends State<TaskCard> {
  Task task;
  String token;
  User currentUser;
  @override
  _TaskCardState({this.token, this.task, this.currentUser});
  editTask() {
    setState(() {
      showInfo = showInfo ? false : true;
    });
  }

  setStatus(String status) async {
    setState(() {
      widget.task.status = status;
    });
    String taskTitle = widget.task.taskTitle;
    String taskDescription = widget.task.taskDescription;
    String token = widget.token;
    String updateTask = jsonEncode({
      "taskTitle": taskTitle,
      "taskDescription": taskDescription,
      "status": status
    });
    String url = "https://karyapp.herokuapp.com/api/tasks/" + task.taskId;
    print(url);
    print(token);
    http.Response response = await http.put(url, body: updateTask, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "x-auth-token": token
    });

    if (response.statusCode == 200) {
      print('updated');
    } else
      print(response.statusCode);
  }

  deleteTask() async {
    String url = "https://karyapp.herokuapp.com/api/tasks/" + task.taskId;
    http.Response response =
        await http.delete(url, headers: {"x-auth-token": token});
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: Home(
                currentUser: currentUser,
                token: token,
              )));
    } else
      print('something failed..' + response.body);
  }

  bool showInfo = false;
  @override
  Widget build(BuildContext context) {
    String path = widget.task.status == 'done'
        ? "assets/images/done.png"
        : widget.task.status == 'incomplete'
            ? "assets/images/lacking.png"
            : "assets/images/pending.png";
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 8.0, left: 14.0, right: 14.0, bottom: 12.0),
          child: Card(
            elevation: 3.0,
            color: decentYellow,
            child: Column(
              children: [
                FlatButton(
                  onPressed: editTask,
                  child: ListTile(
                    leading: Icon(
                      widget.task.status == 'done'
                          ? Icons.cloud_done_rounded
                          : widget.task.status == 'pending'
                              ? Icons.pending
                              : Icons.cancel,
                      color: widget.task.status == 'done'
                          ? Colors.green[300]
                          : widget.task.status == 'pending'
                              ? Colors.purple[300]
                              : Colors.redAccent,
                    ),
                    title: T2(widget.task.taskTitle, 17.0),
                    subtitle: T(widget.task.taskDescription, 16.0),
                  ),
                ),
                if (showInfo)
                  AnimatedContainer(
                    duration: Duration(seconds: 5),
                    curve: Curves.fastOutSlowIn,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[400].withOpacity(.9),
                      // borderRadius: BorderRadius.circular(40.0)
                    ),
                    height: 100.0,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Column(
                                children: [
                                  FlatButton(
                                    onPressed: () => setStatus("done"),
                                    child: CircleAvatar(
                                      backgroundColor:
                                          widget.task.status == "done"
                                              ? Colors.green
                                              : Colors.white,
                                      child: Icon(
                                        Icons.cloud_done,
                                        color: widget.task.status == "done"
                                            ? Colors.white
                                            : Colors.green,
                                      ),
                                    ),
                                  ),
                                  T3('Done', 14.0)
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                FlatButton(
                                  onPressed: () => setStatus("pending"),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        widget.task.status == "pending"
                                            ? Colors.purple
                                            : Colors.white,
                                    child: Icon(
                                      Icons.pending,
                                      color: widget.task.status == 'pending'
                                          ? Colors.white
                                          : Colors.purple,
                                    ),
                                  ),
                                ),
                                T3('Pending', 14.0)
                              ],
                            ),
                            Column(
                              children: [
                                FlatButton(
                                  onPressed: () => setStatus("incomplete"),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        widget.task.status == 'incomplete'
                                            ? Colors.red[300]
                                            : Colors.white,
                                    child: Icon(
                                      Icons.cancel,
                                      color: widget.task.status == 'incomplete'
                                          ? Colors.white
                                          : Colors.red[300],
                                    ),
                                  ),
                                ),
                                T3('Lacking', 14.0)
                              ],
                            ),
                            Column(
                              children: [
                                FlatButton(
                                  onPressed: deleteTask,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.delete_sweep,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                T3('Delete', 14.0)
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
        Positioned(
          right: 6,
          child: Image(
            image: AssetImage(
              path,
            ),
            height: 52.0,
            width: 52.0,
          ),
        )
      ],
    );
  }
}
