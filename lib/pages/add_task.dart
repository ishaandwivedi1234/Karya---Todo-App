import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:karya/model/user.dart';
import 'package:karya/pages/home.dart';
import 'package:karya/widgets/colors.dart';
import 'package:karya/widgets/text.dart';
import 'package:page_transition/page_transition.dart';

class AddTask extends StatefulWidget {
  User currentUser;
  String token;
  AddTask({this.currentUser, this.token});
  @override
  _AddTaskState createState() =>
      _AddTaskState(currentUser: currentUser, token: token);
}

class _AddTaskState extends State<AddTask> {
  User currentUser;
  String token;
  _AddTaskState({this.currentUser, this.token});
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    done = false;
    pending = true;
    incomplete = false;
  }

  bool done = false;
  bool pending = false;
  bool incomplete = false;

  final _formKey = GlobalKey<FormState>();

  selectStatusDone() {
    setState(() {
      pending = false;
      incomplete = false;
      done = true;
    });
  }

  selectStatusPending() {
    setState(() {
      done = false;
      pending = true;
      incomplete = false;
    });
  }

  selectStatusIncomplete() {
    setState(() {
      done = false;
      pending = false;
      incomplete = true;
    });
  }

  TextEditingController _title = new TextEditingController();
  TextEditingController _descripton = new TextEditingController();

  saveForm() async {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();
      var task = jsonEncode({
        'taskTitle': _title.text,
        'taskDescription': _descripton.text,
        'status': pending
            ? 'pending'
            : done
                ? 'done'
                : 'incomplete',
        'userId': currentUser.userId
      });
      http.Response response =
          await http.post("https://karyapp.herokuapp.com/api/tasks/",
              headers: {
                "Accept": "application/json",
                "Content-Type": "application/json",
                "x-auth-token": token
              },
              body: task);
      if (response.statusCode == 200) {
        print('added');

        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: Home(
                  currentUser: currentUser,
                  token: token,
                )));
      }
    }
  }

  Widget _buildTaskTitle() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0), color: Colors.white),
      child: TextFormField(
          controller: _title,
          validator: (val) {
            if (val.length <= 3) {
              return 'Title must be atleast 3 character long';
            }
            return null;
          },
          textAlignVertical: TextAlignVertical.center,
          // textAlign: TextAlign.center,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.note, color: Colors.blue[200]),

            filled: false,
            hintText: "Add A Title To Task",
            // hintStyle: TextStyle(color: Colors.black12),
            alignLabelWithHint: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
            border: InputBorder.none,
          )),
    );
  }

  Widget _buildTaskDescription() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0), color: Colors.white),
      child: TextFormField(
          controller: _descripton,
          validator: (val) {
            if (val.length <= 3) {
              return 'Description must be atleast 10 character long';
            }
            return null;
          },
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.table_chart, color: Colors.blue[200]),
            filled: false,
            hintText: "Describe Your Task",
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            border: InputBorder.none,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      builder: (context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            // border: Border(bottom: 1.0),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            color: lightDecentGrey.withOpacity(.899),
          ),
          width: double.infinity,
          child: ListView(
            controller: scrollController,
            children: [
              Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            T3('Add New Task ', 18.0),
                          ],
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10.0,
                            ),
                            _buildTaskTitle(),
                            SizedBox(
                              height: 10.0,
                            ),
                            _buildTaskDescription(),
                            SizedBox(
                              height: 20.0,
                            ),
                            T3("Set Staus", 16.0),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    FlatButton(
                                      onPressed: selectStatusDone,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            done ? Colors.green : Colors.white,
                                        radius: 30.0,
                                        child: Icon(
                                          Icons.done,
                                          color:
                                              done ? Colors.white : Colors.blue,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    T3("Done", 14.0)
                                  ],
                                ),
                                Column(
                                  children: [
                                    FlatButton(
                                      onPressed: selectStatusPending,
                                      child: CircleAvatar(
                                        backgroundColor: pending
                                            ? Colors.indigoAccent[300]
                                            : Colors.white,
                                        radius: 30.0,
                                        child: Icon(
                                          Icons.receipt,
                                          color: pending
                                              ? Colors.white
                                              : Colors.indigoAccent,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    T3("Pending", 14.0)
                                  ],
                                ),
                                Column(
                                  children: [
                                    FlatButton(
                                      onPressed: selectStatusIncomplete,
                                      child: CircleAvatar(
                                        backgroundColor: incomplete
                                            ? Colors.red[300]
                                            : Colors.white,
                                        radius: 30.0,
                                        child: Icon(
                                          Icons.cancel,
                                          color: incomplete
                                              ? Colors.white
                                              : Colors.red[300],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    T3("Lacking", 14.0)
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 80.0, horizontal: 10.0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: decentYellow),
                              child: FlatButton(
                                child: Center(child: T("Create ", 18.0)),
                                onPressed: saveForm,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            T3('You can change task status later', 14.0),
                          ],
                        ),
                      )
                    ],
                  ))
            ],
          ),
        );
      },
    );
  }
}
