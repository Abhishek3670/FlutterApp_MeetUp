import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysecondapp/models/chatSportiObj.dart';
import 'package:mysecondapp/models/user.dart';
import 'package:mysecondapp/pages/home/conversationScreen.dart';
import 'package:mysecondapp/services/database.dart';
import 'package:provider/provider.dart';

class ChatTile extends StatefulWidget {
  final ChatSporti chatsporti;

  ChatTile({required this.chatsporti});

  @override
  _ChatTileState createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  bool isPressed = false;
  User? user = FirebaseAuth.instance.currentUser;
  createChatRoomAndStartConversation(String chatId) {
    // String message = '';
    // String sender = widget.chatsporti.chatId;
    DatabaseService(uid: user!.uid, chatId: '')
        .createConversationMessage(chatId);
  }

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);
    // chatIdValidator() {
    //   String iD = widget.chatsporti.chatId;
    //   for (int i = 0; i <= iD.length; i++) {
    //     iD.split('_');
    //   }
    // }

    validateUser() {
      if (widget.chatsporti.likedBy == user.name)
        return true;
      else
        return false;
    }

    return validateUser()
        ? Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Card(
              margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                      'https://source.unsplash.com/1600x900/?men,People'),
                ),
                title: Text(widget.chatsporti.likedTo),
                subtitle: Text('Both like ${widget.chatsporti.interest}'),
                trailing: IconButton(
                  onPressed: () {
                    createChatRoomAndStartConversation(
                        widget.chatsporti.chatId);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Conversation(widget.chatsporti),
                        ));
                    setState(() {
                      isPressed = true;
                    });
                  },
                  icon: Icon(
                    CupertinoIcons.chat_bubble_2,
                    color: isPressed ? Colors.deepPurple : Colors.grey,
                  ),
                ),
              ),
            ),
          )
        : Container();
    //    });
  }
}
