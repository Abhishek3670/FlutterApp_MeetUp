import 'package:flutter/material.dart';
import 'package:mysecondapp/services/auth.dart';
import 'package:mysecondapp/utils/route.dart';

class LoginPage extends StatefulWidget {
  final Function toggleView;
  LoginPage({required this.toggleView});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String name = "";
  String password = "";
  bool changeButton = false;
  String error = "";
  bool loading = false;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  moveToHome(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        changeButton = true;
      });

      await Future.delayed(Duration(seconds: 1));
      await Navigator.pushNamed(context, MyRoutes.homeRoute);
      setState(() {
        changeButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  color: Colors.deepPurple,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Welcome $name",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an email' : null,
                        decoration: InputDecoration(hintText: "Email"),
                      ),
                      TextFormField(
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        validator: (val) =>
                            val!.length < 6 ? 'password is weak' : null,
                        obscureText: true,
                        decoration: InputDecoration(hintText: "Password"),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(50),
                        child: InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result = await _auth
                                  .loginWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error = "Can't sign in fireabase";
                                  print(password);
                                });
                              }
                            }
                          },
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            width: changeButton ? 50 : 100,
                            height: 50,
                            alignment: Alignment.center,
                            child: changeButton
                                ? Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          child: TextButton.icon(
                              onPressed: () {
                                widget.toggleView();
                              },
                              icon: Icon(
                                Icons.person,
                                color: Colors.deepPurple,
                              ),
                              label: Text(
                                "Sign Up",
                                style: TextStyle(color: Colors.deepPurple),
                              )))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
