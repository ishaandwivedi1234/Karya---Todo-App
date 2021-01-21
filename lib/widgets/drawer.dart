import 'package:flutter/material.dart';
import 'package:karya/pages/login.dart';
import 'package:karya/pages/stats.dart';
import 'package:karya/widgets/text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colors.dart';

void logout(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool logOut = await preferences.remove('isLogged');
  var p = await preferences.remove('user');
  await preferences.remove('token');
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => Login()));
}

Drawer drawer(String name, String email, BuildContext context) {
  return Drawer(
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 60.0, horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40.0,
            child: T(name[0], 25.0),
            backgroundColor: decentGrey,
            foregroundColor: Colors.white,
          ),
          SizedBox(
            height: 10.0,
          ),
          T(name, 16.0),
          T(email, 12.0),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.show_chart,
                color: Colors.amber,
              ),
              SizedBox(
                width: 10.0,
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: Stats(), type: PageTransitionType.downToUp));
                  },
                  child: T("My Statistics", 14.0))
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.select_all_sharp,
                color: Colors.purple[200],
              ),
              SizedBox(
                width: 10.0,
              ),
              FlatButton(onPressed: () {}, child: T("All Tasks", 14.0))
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.cleaning_services,
                color: Colors.pink[300],
              ),
              SizedBox(
                width: 10.0,
              ),
              FlatButton(onPressed: () {}, child: T("Clear Data", 14.0))
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.touch_app,
                color: Colors.greenAccent,
              ),
              SizedBox(
                width: 10.0,
              ),
              FlatButton(onPressed: () {}, child: T("About Karya", 14.0))
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.login_outlined,
                color: Colors.red[300],
              ),
              SizedBox(
                width: 10.0,
              ),
              FlatButton(
                  onPressed: () => logout(context), child: T("Logout", 14.0))
            ],
          )
        ],
      ),
    ),
  );
}
