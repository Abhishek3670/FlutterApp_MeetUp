import 'package:flutter/material.dart';
import 'package:mysecondapp/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String email = "";
  String password = "";
  String error = "";
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                          validator: (val) =>
                              val!.isEmpty ? 'Enter an email' : null,
                          decoration: InputDecoration(hintText: "Email"),
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          }),
                      TextFormField(
                        validator: (val) =>
                            val!.length > 6 ? 'min 6 char' : null,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
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
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password);
                            }
                          },
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            width: 100,
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              "Sign Up",
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
                                "Log in",
                                style: TextStyle(color: Colors.deepPurple),
                              ))),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                )
              ],
            ),
          ),
        ));
  }
}
