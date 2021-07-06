import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mysecondapp/models/chatSportiObj.dart';
import 'package:mysecondapp/models/convercation.dart';
import 'package:mysecondapp/models/user.dart';
import 'package:mysecondapp/services/database.dart';
import 'package:provider/provider.dart';

class Conversation extends StatefulWidget {
  final ChatSporti chatRoomId;
  Conversation(this.chatRoomId);
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  User? user = FirebaseAuth.instance.currentUser;

  TextEditingController messageController = new TextEditingController();
  late Stream chatMessageStream;

  @override
  void initState() {
    DatabaseService(uid: user!.uid, chatId: widget.chatRoomId.chatId)
        .getConversationMessage(widget.chatRoomId.chatId)
        .then((value) {
      chatMessageStream = value;
      print(chatMessageStream.map((event) => event.toString()));
    });
    // DatabaseService(uid: user!.uid, chatId: '').conversationData;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);
    final chatter = Provider.of<List<ConversationObj>>(context);
    sendMessage() {
      if (messageController.text.isNotEmpty) {
        String message = messageController.text;

        String sendby = widget.chatRoomId.likedBy;
        // Map<String, dynamic> messageMap = {
        //   'message': messageController.text,
        //   'sendBy': widget.chatRoomId.likedBy,
        // };
        DatabaseService(uid: user.uid, chatId: '')
            .addConversationMessage(widget.chatRoomId.chatId, message, sendby);
      } else {
        print("empty text");
      }
      messageController.text = '';
    }

    Widget chatMessageList() {
      print(chatter.length);
      return ListView.builder(
          itemCount: chatter.length,
          itemBuilder: (context, index) {
            return MessageTile(
              msg: chatter[index].message,
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.chatRoomId.likedTo),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Text message ... ',
                            hintStyle: TextStyle(color: Colors.white54)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {sendMessage()},
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(20)),
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String msg;
  MessageTile({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(msg),
    );
  }
}
