import 'package:flutter/material.dart';
import 'package:mysecondapp/models/user.dart';
import 'package:mysecondapp/services/database.dart';

class AccountTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mock user for demonstration
    String userId = 'current_user';

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: userId, chatId: '').userData,
        builder: (context, snapshot) {
          UserData? userData = snapshot.data;

          return Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(children: [
                    SizedBox(
                      height: 60,
                    ),
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(
                          "https://source.unsplash.com/user/erondu/1600x900"),
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text("I Am", style: TextStyle(color: Colors.grey[500])),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '${userData?.name}',
                      style: TextStyle(
                        letterSpacing: 1.5,
                        color: Colors.black,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      "I Like",
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '${userData?.sport}',
                      style: TextStyle(
                        letterSpacing: 1.5,
                        color: Colors.black,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ])));
        });
  }
}