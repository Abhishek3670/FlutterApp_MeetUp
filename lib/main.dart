import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysecondapp/pages/wrapper.dart';
import 'package:mysecondapp/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mysecondapp/models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final bool darkMode = false;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserId?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        home: Wrapper(),
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
