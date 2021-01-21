import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:karya/model/task.dart';
import 'package:karya/model/user.dart';
import 'package:karya/pages/add_task.dart';
import 'package:karya/pages/login.dart';
import 'package:karya/widgets/appBar.dart';
import 'package:karya/widgets/colors.dart';
import 'package:karya/widgets/drawer.dart';
import 'package:karya/widgets/task_card.dart';
import 'package:http/http.dart' as http;
import 'package:karya/widgets/text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Home extends StatefulWidget {
  User currentUser;
  String token;
  Home({this.currentUser, this.token});
  @override
  _HomeState createState() =>
      _HomeState(currentUser: currentUser, token: token);
}

class _HomeState extends State<Home> {
  User currentUser;
  String token;
  _HomeState({this.currentUser, this.token});

  Future<List<TaskCard>> getTask() async {
    // print("userId : ");
    // print(currentUser.userId);
    List<TaskCard> taskList = [];
    final String url =
        "https://karyapp.herokuapp.com/api/tasks/user/" + currentUser.userId;
    http.Response response = await http.get(url, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "x-auth-token": token
    });
    if (response.statusCode == 200) {
      // print('done');
      List taskJson = jsonDecode(response.body);
      taskJson.forEach((element) {
        Task task = Task.fromJson(element);
        TaskCard taskcard = TaskCard(
          task: task,
          token: token,
          currentUser: currentUser,
        );
        taskList.add(taskcard);
      });
    }
    return taskList;
  }

  FutureBuilder listOfTasks() {
    return FutureBuilder(
        future: getTask(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data,
            );
          } else
            return Center(
                child: SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                        spinnerMode: true,
                        size: 30.0,
                        customColors: CustomSliderColors(
                            trackColor: Colors.grey,
                            progressBarColors: [
                              Colors.blueGrey,
                              Colors.grey[300]
                            ]))));
        });
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.currentUser.name);
    // print(widget.currentUser.userId);
    return Scaffold(
      endDrawer:
          drawer(widget.currentUser.name, widget.currentUser.email, context),
      appBar: AppBar(
        title: T("Todo", 18.0),
        backgroundColor: decentGrey,
        elevation: 2.0,
      ),
      body: Stack(
        children: [
          Container(
              child: Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: listOfTasks())),
          AddTask(
            currentUser: currentUser,
            token: token,
          ),
        ],
      ),
    );
  }
}
