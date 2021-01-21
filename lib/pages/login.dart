import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:karya/model/user.dart';
import 'package:karya/pages/auth.dart';

import 'package:karya/widgets/colors.dart';
import 'package:karya/widgets/text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Image loginImage;

  @override
  void initState() {
    super.initState();
    loginImage = Image.asset('assets/images/login-min.png');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(loginImage.image, context);
  }

  final _formKey = GlobalKey<FormState>();
  String error = "";
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  login() async {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      var user = jsonEncode({"email": email, "password": password});
      http.Response response = await http
          .post('https://karyapp.herokuapp.com/api/auth', body: user, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      });

      if (response.statusCode == 200) {
        var userJson = jsonDecode(response.body);
        User newUser = User.fromJson(userJson);
        print(newUser.name);
        var headers = response.headers;
        var token = headers['x-auth-token'];
        print(token);
        // var user = jsonEncode(newUser);
        // save in shared prefrences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user', response.body);
        prefs.setBool('isLogged', true);
        prefs.setString('token', token);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      currentUser: newUser,
                      token: token,
                    )));
      } else {
        if (response.statusCode == 404) {
          setState(() {
            error = "Wrong email or password";
          });
        } else {
          setState(() {
            error = "unable to connect";
          });
        }
      }
    }
  }

  register() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Auth()));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: customAppBar("Login", false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/images/login-min.png'),
              height: height * 0.5,
              width: width * 0.9,
            ),
            Container(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(Icons.email_outlined),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 50.0),
                          border: InputBorder.none,
                          // fillColor: Colors.amber,
                          hintText: "Email",
                        ),
                        controller: _emailController,
                        validator: (val) {
                          if (!validateEmail(val)) return "Enter a valid email";
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(Icons.lock_outlined),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 50.0),
                          border: InputBorder.none,
                          // fillColor: Colors.amber,
                          hintText: "Password",
                        ),
                        controller: _passwordController,
                        validator: (val) {
                          if (val.length <= 7)
                            return "Password must be atleast 8 character long";
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: decentYellow,
                            // boxShadow: BoxShadow(color: Colors.green),
                            borderRadius: BorderRadius.circular(20.0)),
                        width: width * 0.5,
                        child: FlatButton(
                          onPressed: login,
                          child: T('Login', 15.0),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          T("Dont have an account ?", 15.0),
                          FlatButton(
                              onPressed: register,
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  backgroundColor: Colors.transparent,
                                ),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      T(error, 12.0)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
