import 'package:flutter/material.dart';
import 'package:mysecondapp/pages/authentication/loginPage.dart';
import 'package:mysecondapp/pages/authentication/register.dart';

class Authenticate extends StatefulWidget {
  Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showLogin = true;
  void toggleView() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return LoginPage(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
