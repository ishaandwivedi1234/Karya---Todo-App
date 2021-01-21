import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:karya/model/user.dart';
import 'package:karya/widgets/colors.dart';
import 'package:karya/widgets/text.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  String error = "";
  register() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      FocusScope.of(context).unfocus();
      final String name = _nameController.text.trim();
      final String email = _emailController.text.trim();
      final String password = _passwordController.text;
      print(name);

      var user =
          jsonEncode({"name": name, "email": email, "password": password});

      http.Response response = await http.post(
          'https://karyapp.herokuapp.com/api/users',
          body: user,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          });

      if (response.statusCode == 200) {
        var userJson = jsonDecode(response.body);
        // var token = response.headers("x-auth-toke");

        User newUser = User.fromJson(userJson);
        print(newUser.userId);
        var headers = response.headers;
        var token = headers['x-auth-token'];
        Navigator.pop(context);
        print(token);
      } else {
        if (response.statusCode == 400 &&
            response.body == "User Already Exists") {
          setState(() {
            error = "User already exists";
          });
        } else {
          setState(() {
            error = "Unable to connect";
          });
        }
      }
      print('someting failed');
    }
  }

  login() {
    Navigator.pop(context);
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
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
                autovalidateMode: AutovalidateMode.always,
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(Icons.person),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 50.0),
                          border: InputBorder.none,
                          // fillColor: Colors.amber,
                          hintText: "Full Name",
                        ),
                        controller: _nameController,
                        validator: (val) {
                          if (val.length.toString().trim() == 0)
                            return "Name should be atleast 3 character long";
                          return null;
                        },
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
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
                          if (!validateEmail(val))
                            return "Enter valid email address";
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
                          onPressed: register,
                          child: T('Sign Up ', 15.0),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          T("Already have an account ?", 15.0),
                          FlatButton(
                              onPressed: login,
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  backgroundColor: Colors.transparent,
                                ),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      T(error, 14.0)
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
