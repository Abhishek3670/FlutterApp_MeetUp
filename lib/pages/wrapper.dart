import 'package:flutter/material.dart';
import 'package:mysecondapp/models/user.dart';
import 'package:mysecondapp/pages/authentication/authenticate.dart';
import 'package:mysecondapp/pages/home/homePage.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserId?>(context);

    //return eihter Home or Auth widget
    if (user == null) {
      return Authenticate();
    } else {
      return HomePage();
    }
  }
}
