import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mysecondapp/models/chatSportiObj.dart';
import 'package:mysecondapp/models/convercation.dart';
import 'package:mysecondapp/models/sportiObj.dart';
import 'package:mysecondapp/models/user.dart';
import 'package:mysecondapp/pages/home/conversationScreen.dart';
import 'package:mysecondapp/pages/home/setting_form.dart';

import 'package:mysecondapp/pages/home/tabs.dart';
import 'package:mysecondapp/services/auth.dart';
import 'package:mysecondapp/services/database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    void _showSettingPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
              child: SettingForm(),
            );
          });
    }

    User? user = FirebaseAuth.instance.currentUser;
    return MultiProvider(
      providers: [
        StreamProvider<List<Sporti>?>.value(
          value: DatabaseService(uid: '', chatId: '').sportis,
          initialData: null,
        ),
        StreamProvider<List<ChatSporti>>.value(
          value: DatabaseService(uid: '', chatId: '').chatSportis,
          initialData: [],
        ),
        StreamProvider<List<ConversationObj>>.value(
          value: DatabaseService(uid: '', chatId: '').conversationData,
          initialData: [],
        ),
        StreamProvider<UserData>(
          initialData: UserData(name: '', uid: '', sport: '', strength: 0),
          create: (context) =>
              DatabaseService(uid: user!.uid, chatId: '').userData,
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("MeetUp"),
          actions: [
            TextButton.icon(
                onPressed: () async {
                  await _auth.logOut();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                label: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.white),
                )),
            TextButton.icon(
              onPressed: () => _showSettingPanel(),
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              label: Text(''),
            )
          ],
        ),
        body: TabPages(),
      ),
    );
    // return StreamProvider<List<Sporti>?>.value(
    //     value: DatabaseService(uid: '').sportis,
    //     initialData: null,
    //     child: Scaffold(
    //       appBar: AppBar(
    //         title: Text("Spotigramm"),
    //         actions: [
    //           TextButton.icon(
    //               onPressed: () async {
    //                 await _auth.logOut();
    //               },
    //               icon: Icon(
    //                 Icons.exit_to_app,
    //                 color: Colors.white,
    //               ),
    //               label: Text(
    //                 'Sign Out',
    //                 style: TextStyle(color: Colors.white),
    //               )),
    //           TextButton.icon(
    //             onPressed: () => _showSettingPanel(),
    //             icon: Icon(
    //               Icons.settings,
    //               color: Colors.white,
    //             ),
    //             label: Text(''),
    //           )
    //         ],
    //       ),
    //       body: TabPages(),
    //     ));
  }
}
