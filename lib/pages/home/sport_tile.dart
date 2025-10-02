import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysecondapp/models/sportiObj.dart';
import 'package:mysecondapp/models/user.dart';
import 'package:mysecondapp/services/database.dart';

class SportiTile extends StatefulWidget {
  final Sporti sporti;

  SportiTile({required this.sporti});

  @override
  _SportiTileState createState() => _SportiTileState();
}

class _SportiTileState extends State<SportiTile> {
  // Mock user for demonstration
  String userId = 'current_user';

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else
      return '$a\_$b';
  }

  validateSportiTile() {
    if (userId != widget.sporti.sportiId)
      return true;
    else
      return false;
  }

  whoLiked(Sporti sporti, UserData userData) {
    if (sporti.sport == userData.sport) {
      String likedRoomId = getChatRoomId(sporti.name, userData.name);
      String interest = sporti.sport;
      String likedBy = userData.name;
      String likedTo = sporti.name;

      DatabaseService(uid: userId, chatId: '')
          .createLikedRoom(likedRoomId, interest, likedBy, likedTo);
    } else
      print("Not Matched");
  }

  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Mock user for demonstration
    String currentUserId = 'current_user';

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: currentUserId, chatId: '').userData,
        builder: (context, snapshot) {
          UserData? userData = snapshot.data;
          return validateSportiTile()
              ? Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Card(
                    margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                            'https://source.unsplash.com/1600x900/?Face,People'),
                      ),
                      title: Text(widget.sporti.name),
                      subtitle: Text('I like ${widget.sporti.sport}.'),
                      trailing: IconButton(
                        onPressed: () {
                          print('like');
                          whoLiked(widget.sporti, userData!);

                          setState(() {
                            isPressed = true;
                          });
                        },
                        icon: Icon(
                          CupertinoIcons.suit_heart_fill,
                          color: isPressed ? Colors.deepPurple : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                )
              : Container();
        });
  }
}