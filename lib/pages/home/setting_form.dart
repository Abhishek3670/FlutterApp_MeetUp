import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mysecondapp/models/user.dart';

import 'package:mysecondapp/services/database.dart';
import 'package:provider/provider.dart';

class SettingForm extends StatefulWidget {
  SettingForm({Key? key}) : super(key: key);

  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sports = [
    'Cricket',
    'Football',
    'Hockey',
    'Volley Ball',
    'Running'
  ];

  //form values
  late String? _currentName = '';
  late String? _currentSport = '';
  late int? _currentStrength = 0;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    //final user = Provider.of<UserData>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user!.uid, chatId: '').userData,
        builder: (context, snapshot) {
          UserData? userData = snapshot.data;

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Update Your profile.",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  initialValue: userData?.name,
                  onChanged: (value) {
                    setState(() {
                      _currentName = value;
                    });
                  },
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter a name' : null,
                  decoration: InputDecoration(hintText: "Name"),
                ),
                SizedBox(
                  height: 20.0,
                ),
                //Dropdown
                DropdownButtonFormField(
                  decoration: InputDecoration(hintText: 'Sports'),
                  onChanged: (value) {
                    setState(() {
                      _currentSport = value.toString();
                    });
                  },
                  items: sports
                      .map((sport) => DropdownMenuItem(
                            value: sport,
                            child: Text('$sport'),
                          ))
                      .toList(),
                ),
                SizedBox(
                  height: 20.0,
                ),
                //slider

                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _currentStrength = value as int?;
                    });
                  },
                  decoration: InputDecoration(hintText: 'Age'),
                ),
                SizedBox(
                  height: 20.0,
                ),
                FloatingActionButton.extended(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await DatabaseService(uid: user.uid, chatId: '')
                          .updateUserData(
                              _currentSport ?? userData!.sport,
                              _currentName ?? userData!.name,
                              _currentStrength ?? userData!.strength);

                      Navigator.pop(context);
                    }
                  },
                  label: Text('Update'),
                  icon: Icon(Icons.thumb_up),
                  backgroundColor: Colors.deepPurple,
                ),
              ],
            ),
          );
        });
  }
}
