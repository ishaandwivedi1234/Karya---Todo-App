import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:karya/model/user.dart';
import 'package:karya/pages/home.dart';
import 'package:karya/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    authCheck();
  }

  User currentuser;
  String userToken;
  bool isLogged = false;

  bool isSplash = true;
  bool checkedAuth = false;
  Future<bool> authCheck() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('token');
    String userstring = preferences.getString('user');
    if (userstring != null) {
      var userJson = jsonDecode(userstring);
      User user = User.fromJson(userJson);
      setState(() {
        currentuser = user;
        userToken = token;
      });
    }
    setState(() {
      isLogged = preferences.getBool('isLogged') ?? false;
      checkedAuth = true;
    });

    return isLogged;
  }

  buildSplash() {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: Image(
              image: AssetImage('assets/images/logo.png'),
              height: 229.0,
              width: 229.0,
            ),
          ),
        ],
      ),
    );
  }

  splash() {
    Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {
        isSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    splash();
    if (isSplash == true) return buildSplash();
    if (checkedAuth == false) {
      return buildSplash();
    }
    if (checkedAuth == true) {
      if (isLogged == true)
        return Home(currentUser: currentuser, token: userToken);
      else
        return Login();
    }
  }
}
